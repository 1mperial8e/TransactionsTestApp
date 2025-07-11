//
//  DashboardViewModel.swift
//  TransactionsTestTask
//
//  Created by Stanislav Volskyi on 10.07.2025.
//

import Foundation
import UIKit
import Combine

protocol DashboardViewModel {
    init(router: AppRouter, walletService: WalletService)
    func bind(input: DashboardViewModelInput) -> DashboardViewModelOutput
}

struct DashboardViewModelInput {
    var refillTapped: AnyPublisher<Void, Never>
    var addTransactionTapped: AnyPublisher<Void, Never>
}

struct DashboardViewModelOutput {
    var balance: AnyPublisher<Decimal, Never>
}

final class DashboardViewModelImpl: DashboardViewModel {
    private let router: AppRouter
    private let walletService: WalletService
    private var wallet: Wallet

    private let balancePublisher: CurrentValueSubject<Decimal, Never>
    private var cancellables: Set<AnyCancellable> = []

    // MARK: Init
    init(router: AppRouter, walletService: WalletService) {
        self.router = router
        self.walletService = walletService
        do {
            self.wallet = try walletService.getWallet()
            self.balancePublisher = .init(wallet.balanceValue)
        } catch {
            fatalError("Wallet can not be initialized")
        }
    }

    private func handleAddTransactionAction() {
        router.showAddNewTransaction()
    }

    private func handleRefillAction() {
        let alert = RefillAlert.build { [weak self] value in
            self?.handleRefillAmount(value)
        }
        router.show(alert: alert)
    }

    private func handleRefillAmount(_ value: String) {
        guard let amount = value.decimal, amount > 0 else { return }
        do {
            try walletService.refillWallet(amount)
            balancePublisher.send(wallet.balanceValue)
        } catch {
            router.show(alert: GenericErrorAlert.build())
        }
    }
}

// MARK: - Binding
extension DashboardViewModelImpl {

    func bind(input: DashboardViewModelInput) -> DashboardViewModelOutput {
        input
            .refillTapped
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] _ in
                self.handleRefillAction()
            }
            .store(in: &cancellables)
        input
            .addTransactionTapped
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] _ in
                self.handleAddTransactionAction()
            }
            .store(in: &cancellables)

        return .init(balance: balancePublisher.eraseToAnyPublisher())
    }
}
