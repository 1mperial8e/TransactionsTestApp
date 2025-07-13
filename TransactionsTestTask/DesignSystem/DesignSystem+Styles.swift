//
//  DesignSystem+Styles.swift
//  TransactionsTestTask
//
//  Created by Stanislav Volskyi on 13.07.2025.
//

import UIKit

extension DesignSystem {
    static func addBorder(_ view: UIView) {
        view.layer.cornerRadius = CornerRadius.md
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
    }
}
