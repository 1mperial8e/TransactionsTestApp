//
//  BitcoinRateServiceTests.swift
//  TransactionsTestTaskTests
//
//  Created by Stanislav Volskyi on 13.07.2025.
//

import Foundation
import XCTest
import Combine
@testable import TransactionsTestTask

final class BitcoinRateServiceTests: XCTestCase {
    private var sut: BitcoinRateService!
    private var walletServiceStub: WalletServiceStub!
    private var networkClientStub: NetworkClientStub!

    private var cancellables: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        walletServiceStub = .init()
        networkClientStub = .init()
        sut = BitcoinRateServiceImpl(networkClient: networkClientStub, walletService: walletServiceStub)
    }

    func test_scheduledUpdates() throws {
        networkClientStub.stubbedJson = mockRateJsonResponse
        // Expect 10 updates in 1 second
        let expectation = XCTestExpectation(description: "10 updates in 1 second")
        expectation.expectedFulfillmentCount = 10
        // Count every update
        sut.currentRatePublisher
            .dropFirst() // Skipping initial currentValueSubject update
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        let startDate = Date()
        // Schedule update every 100ms
        sut.scheduleRateUpdate(interval: 100 / 1000)
        wait(for: [expectation], timeout: 1.0001)

        // Validate rate update tracked 10 times
        let analyticsService = ServicesAssembler.analyticsService()
        let events = analyticsService.getEvents(from: startDate, to: nil, eventName: AnalyticsEventName.bitcoinRateUpdate)
        XCTAssertEqual(events.count, 10)
    }

    func test_updatedRateIsStored() async throws {
        networkClientStub.stubbedJson = mockRateJsonResponse
        let newRate = try await sut.updateRate()
        // Validate rate is stored in wallet
        // Since decimal has high precision we are checking formatted value (5 fraction digits)
        XCTAssertEqual(walletServiceStub.storedRate.formatted(), newRate.formatted())
    }

}

// MARK: - Helpers
extension BitcoinRateServiceTests {
    var mockRateJsonResponse: [String: Any] {
        [
            "Data": [
                "BTC-USD":
                    [
                        "VALUE": 117190.156390
                    ]
            ]
        ]
    }
}
