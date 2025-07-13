//
//  InvalidAmountAlert.swift
//  TransactionsTestTask
//
//  Created by Stanislav Volskyi on 13.07.2025.
//

import UIKit

enum InvalidAmountAlert {
    static func build(handler: (() -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(
            title: L10n.RefillBalance.Error.InvalidAmount.title,
            message: L10n.RefillBalance.Error.InvalidAmount.message,
            preferredStyle: .alert
        )
        alert.addAction(.init(title: L10n.Common.ok, style: .cancel) { _ in
            handler?()
        })
        return alert
    }
}
