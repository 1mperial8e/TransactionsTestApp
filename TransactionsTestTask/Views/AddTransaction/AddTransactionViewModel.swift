//
//  AddTransactionViewModel.swift
//  TransactionsTestTask
//
//  Created by Stanislav Volskyi on 10.07.2025.
//

import Foundation
import Combine

protocol AddTransactionViewModel {
    init(router: AppRouter, transactionService: TransactionsService, walletService: WalletService)
    func bind(input: AddTransactionViewModelInput) -> AddTransactionViewModelOutput
}

struct AddTransactionViewModelInput {
    var amount: AnyPublisher<String?, Never>
    var reference: AnyPublisher<String?, Never>
    var category: AnyPublisher<TransactionCategory, Never>
    var addTapped: AnyPublisher<Void, Never>
}

struct AddTransactionViewModelOutput {
    var categories: AnyPublisher<[TransactionCategory], Never>
}

final class AddTransactionViewModelImpl: AddTransactionViewModel {
    private let router: AppRouter
    private let transactionService: TransactionsService
    private let walletService: WalletService
    @Published private var transactionModel: AddTransactionModel = .init()

    private var cancellables: Set<AnyCancellable> = []

    init(router: AppRouter, transactionService: TransactionsService, walletService: WalletService) {
        self.router = router
        self.transactionService = transactionService
        self.walletService = walletService
    }

    func bind(input: AddTransactionViewModelInput) -> AddTransactionViewModelOutput {
        input
            .amount
            .sink(receiveValue: { [weak self] in
                self?.transactionModel.amount = $0?.decimal
            })
            .store(in: &cancellables)
        input
            .category
            .sink(receiveValue: { [weak self] in
                self?.transactionModel.category = $0
            })
            .store(in: &cancellables)
        input
            .reference
            .sink(receiveValue: { [weak self] in
                self?.transactionModel.reference = $0
            })
            .store(in: &cancellables)
        input
            .addTapped
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.handleAddTransaction()
            }
            .store(in: &cancellables)
        return .init(categories: Just(TransactionCategory.allCases).eraseToAnyPublisher())
    }

    private func handleAddTransaction() {
        guard let amount = transactionModel.amount, let category = transactionModel.category else {
            router.show(alert: EmptyTransactionFieldsAlert.build())
            return
        }

        do {
            let wallet = try walletService.getWallet()
            if wallet.balanceValue < amount {
                router.show(alert: InsufficientBalanceAlert.build())
                return
            }
            try transactionService.addCreditTransaction(category: category, amount: amount, reference: transactionModel.reference)
            router.goBack()
        } catch {
            router.show(alert: GenericErrorAlert.build())
        }
    }

}
