//
//  Decimal+Extension.swift
//  TransactionsTestTask
//
//  Created by Stanislav Volskyi on 11.07.2025.
//

import Foundation

extension Decimal {
    func formatted(fractions: Int = 5) -> String? {
        let formatter = DecimalFormatter.numberFormatter
        formatter.minimumFractionDigits = fractions
        formatter.maximumFractionDigits = fractions
        return formatter.string(from: NSDecimalNumber(decimal: self))
    }
}
