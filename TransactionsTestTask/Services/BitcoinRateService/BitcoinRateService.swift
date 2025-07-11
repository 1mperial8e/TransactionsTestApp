//
//  BitcoinRateService.swift
//  TransactionsTestTask
//
//

/// Rate Service should fetch data from https://api.coindesk.com/v1/bpi/currentprice.json
/// Fetching should be scheduled with dynamic update interval
/// Rate should be cached for the offline mode
/// Every successful fetch should be logged with analytics service
/// The service should be covered by unit tests

import Foundation
import Combine

protocol BitcoinRateService: AnyObject {
    var currentRatePublisher: AnyPublisher<Decimal?, Never> { get }

    func scheduleRateUpdate(interval: TimeInterval)
    func updateRate() async throws -> Decimal
}

final class BitcoinRateServiceImpl {
    var currentRatePublisher: AnyPublisher<Decimal?, Never> {
        $currentRate.eraseToAnyPublisher()
    }

    @Published private var currentRate: Decimal?

    private let networkClient: NetworkClient
    private let walletService: WalletService
    private let analyticsService: AnalyticsService

    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Init
    init(networkClient: NetworkClient, walletService: WalletService, analyticsService: AnalyticsService) {
        self.networkClient = networkClient
        self.walletService = walletService
        self.analyticsService = analyticsService
        self.currentRate = try? walletService.getWallet().btcUsdRate?.decimalValue
    }
}

// MARK: - BitcoinRateService
extension BitcoinRateServiceImpl: BitcoinRateService {

    func scheduleRateUpdate(interval: TimeInterval) {
        Timer
            .publish(every: interval, on: .main, in: .common)
            .autoconnect()
            .receive(on: DispatchQueue.main)
            .prepend(.now)
            .sink { [weak self] _ in
                guard let self else { return }
                Task {
                    guard let newRate = try? await self.updateRate() else { return }
                    self.currentRate = newRate
                }
            }
            .store(in: &cancellables)
    }

    func updateRate() async throws -> Decimal {
        let result: BitcoinRateResponse = try await networkClient.perform(endpoint: BitcoinEndpoint.currentRate)
        // Store latest rate value
        try walletService.updateLatestRate(result.value)
        // Track succesful fetch
        logNewRate(result.value)
        return result.value
    }
}

// MARK: - Analytics
private extension BitcoinRateServiceImpl {
    func logNewRate(_ value: Decimal) {
        analyticsService.trackEvent(
            name: "bitcoin_rate_update",
            parameters: ["rate": value.formatted()]
        )
    }
}
