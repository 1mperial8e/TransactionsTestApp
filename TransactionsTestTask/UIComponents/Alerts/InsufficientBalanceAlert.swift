//
//  InsufficientBalanceAlert.swift
//  TransactionsTestTask
//
//  Created by Stanislav Volskyi on 12.07.2025.
//

import UIKit

enum InsufficientBalanceAlert {
    static func build() -> UIAlertController {
        let alert = UIAlertController(
            title: L10n.Transactions.Error.InsufficientBalance.title,
            message: L10n.Transactions.Error.InsufficientBalance.message,
            preferredStyle: .alert
        )
        alert.addAction(.init(title: L10n.Common.ok, style: .cancel))
        return alert
    }
}
