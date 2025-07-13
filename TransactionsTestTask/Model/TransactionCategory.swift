//
//  TransactionCategory.swift
//  TransactionsTestTask
//
//  Created by Stanislav Volskyi on 11.07.2025.
//

import UIKit

enum TransactionCategory: String, CaseIterable {
    case groceries
    case taxi
    case electronics
    case restaurant
    case other
}

extension TransactionCategory {
    var text: String {
        switch self {
        case .groceries: L10n.Transactions.Category.groceries
        case .taxi: L10n.Transactions.Category.taxi
        case .electronics: L10n.Transactions.Category.electronics
        case .restaurant: L10n.Transactions.Category.restaurant
        case .other: L10n.Transactions.Category.other
        }
    }

    var color: UIColor {
        switch self {
        case .groceries: .systemOrange
        case .taxi: .systemYellow
        case .electronics: .systemBlue
        case .restaurant: .systemPink
        case .other: .systemBrown
        }
    }
}
