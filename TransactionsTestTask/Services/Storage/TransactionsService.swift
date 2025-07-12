//
//  TransactionsService.swift
//  TransactionsTestTask
//
//  Created by Stanislav Volskyi on 11.07.2025.
//

import Foundation

protocol TransactionsService {
    func getTransactions(page: Int, size: Int) throws -> [Transaction]
    func addCreditTransaction(category: TransactionCategory, amount: Decimal, reference: String?) throws
    func addDebitTransaction(amount: Decimal) throws
}

final class TransactionsServiceImpl: TransactionsService {
    private let storage = DataStorageImpl<Transaction>()

    func getTransactions(page: Int, size: Int) throws -> [Transaction] {
        try storage.fetch(sortDescriptors: [.init(key: "valueDate", ascending: false)])
    }

    func addCreditTransaction(category: TransactionCategory, amount: Decimal, reference: String?) throws {
        newTransaction(amount: amount, reference: reference, category: category, creditDebitIndicator: .credit)
        try storage.save()
    }

    func addDebitTransaction(amount: Decimal) throws {
        newTransaction(amount: amount, creditDebitIndicator: .debit)
        try storage.save()
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
        newTransaction.category = category?.rawValue
        newTransaction.valueDate = Date()
        newTransaction.id = UUID()
        newTransaction.debitCreditIndicator = creditDebitIndicator.rawValue
        return newTransaction
    }

}
