//
//  Wallet.swift
//  TransactionsTestTask
//
//  Created by Stanislav Volskyi on 11.07.2025.
//


import Foundation
import CoreData

@objc(Wallet)
class Wallet: NSManagedObject {
    var balanceValue: Decimal {
        balance?.decimalValue ?? 0
    }
}
