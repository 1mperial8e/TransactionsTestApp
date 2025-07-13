//
//  DesignSystem.swift
//  TransactionsTestTask
//
//  Created by Stanislav Volskyi on 13.07.2025.
//

import Foundation

typealias Spacer = DesignSystem.Spacer
typealias CornerRadius = DesignSystem.CornerRadius

struct DesignSystem {
    enum Spacer {
        /// 4pt
        static let xs: CGFloat = 4
        /// 8pt
        static let sm: CGFloat = 8
        /// 16pt
        static let md: CGFloat = 16
        /// 24pt
        static let lg: CGFloat = 24
        /// 32pt
        static let xl: CGFloat = 32
    }

    enum CornerRadius {
        /// 4pt
        static let sm: CGFloat = 4
        /// 8pt
        static let md: CGFloat = 8
        /// 16pt
        static let lg: CGFloat = 16
    }
}
