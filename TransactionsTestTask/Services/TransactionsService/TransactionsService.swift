//
//  TransactionsService.swift
//  TransactionsTestTask
//
//  Created by Stanislav Volskyi on 11.07.2025.
//

import Foundation
import Combine

protocol TransactionsService {
    var transactionsChangePublisher: AnyPublisher<Void, Never> { get }

    func getTransactions(page: Int, size: Int) throws -> [Transaction]
    func addCreditTransaction(category: TransactionCategory, amount: Decimal, reference: String?) throws
    func addDebitTransaction(amount: Decimal) throws
}

final class TransactionsServiceImpl: TransactionsService {
    var transactionsChangePublisher: AnyPublisher<Void, Never> { transactionsChanged.eraseToAnyPublisher() }
    private var transactionsChanged = PassthroughSubject<Void, Never>()

    private let storage = DataStorageImpl<Transaction>()
    private let analyticsService: AnalyticsService = ServicesAssembler.analyticsService()

    func getTransactions(page: Int, size: Int) throws -> [Transaction] {
        try storage.fetch(
            sortDescriptors: [.init(key: "valueDate", ascending: false)],
            paginationData: .init(page: page, size: size)
        )
    }

    func addCreditTransaction(category: TransactionCategory, amount: Decimal, reference: String?) throws {
        newTransaction(amount: amount, reference: reference, category: category, creditDebitIndicator: .credit)
        try storage.save()
        transactionsChanged.send()
    }

    func addDebitTransaction(amount: Decimal) throws {
        newTransaction(amount: amount, creditDebitIndicator: .debit)
        try storage.save()
        transactionsChanged.send()
    }

    @discardableResult
    private func newTransaction(
        amount: Decimal,
        reference: String? = nil,
        category: TransactionCategory? = nil,
        creditDebitIndicator: CreditDebitIndicator
    ) -> Transaction {
        let newTransaction = Transaction(context: storage.context)
        newTransaction.amount = NSDecimalNumber(decimal: amount)
        newTransaction.reference = reference
        newTransaction.categoryValue = category?.rawValue
        newTransaction.valueDate = Date()
        newTransaction.id = UUID()
        newTransaction.debitCreditIndicator = creditDebitIndicator.rawValue
        return newTransaction
    }

}

// MARK: - Analytics
private extension TransactionsServiceImpl {
    func logNewTransaction(_ transaction: Transaction) {
        let parameters: [String: String?] = [
            AnalyticsParameterName.category: transaction.categoryValue,
            AnalyticsParameterName.transactionDate: transaction.date.ISO8601Format(),
            AnalyticsParameterName.hasReference: transaction.reference == nil ? "false" : "true"
        ]
        analyticsService.trackEvent(
            name: AnalyticsEventName.newTransaction,
            parameters: parameters.compactMapValues { $0 }
        )
    }
}
