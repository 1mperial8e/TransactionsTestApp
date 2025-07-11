//
//  DecimalFormatter.swift
//  TransactionsTestTask
//
//  Created by Stanislav Volskyi on 11.07.2025.
//

import Foundation

enum DecimalFormatter {
    static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = .current
        return formatter
    }()
}
