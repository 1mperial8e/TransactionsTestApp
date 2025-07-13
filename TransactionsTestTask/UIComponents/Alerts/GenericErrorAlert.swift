//
//  GenericErrorAlert.swift
//  TransactionsTestTask
//
//  Created by Stanislav Volskyi on 11.07.2025.
//

import UIKit

enum GenericErrorAlert {
    static func build() -> UIAlertController {
        let alert = UIAlertController(title: L10n.Common.Error.Generic.title, message: L10n.Common.Error.Generic.message, preferredStyle: .alert)
        alert.addAction(.init(title: L10n.Common.ok, style: .cancel))
        return alert
    }
}
