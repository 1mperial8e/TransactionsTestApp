//
//  Transaction.swift
//  TransactionsTestTask
//
//  Created by Stanislav Volskyi on 11.07.2025.
//

import Foundation
import CoreData

@objc(Transaction)
class Transaction: NSManagedObject {
    var amountValue: Decimal {
        amount?.decimalValue ?? 0
    }

    var date: Date {
        valueDate ?? Date()
    }

    var category: TransactionCategory? {
        guard let categoryValue else { return nil }
        return TransactionCategory(rawValue: categoryValue)
    }

    var isDebit: Bool {
        debitCreditIndicator == CreditDebitIndicator.debit.rawValue
    }
}
