//
//  RefillAlert.swift
//  TransactionsTestTask
//
//  Created by Stanislav Volskyi on 11.07.2025.
//

import UIKit

enum RefillAlert {
    static func build(handler: @escaping (String) -> Void) -> UIAlertController {
        let alert = UIAlertController(title: L10n.RefillBalance.title, message: L10n.RefillBalance.message, preferredStyle: .alert)
        alert.addTextField { $0.keyboardType = .decimalPad }
        alert.addAction(.init(title: L10n.Common.cancel, style: .cancel))
        alert.addAction(.init(title: L10n.Common.done, style: .default) { _ in
            handler(alert.textFields?.first?.text ?? "")
        })
        return alert
    }
}
