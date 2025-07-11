//
//  Decimal+Extension.swift
//  TransactionsTestTask
//
//  Created by Stanislav Volskyi on 11.07.2025.
//

import Foundation

extension Decimal {
    var formatted: String? {
        DecimalFormatter.numberFormatter.string(from: NSDecimalNumber(decimal: self))
    }
}
