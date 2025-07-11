//
//  String+Extension.swift
//  TransactionsTestTask
//
//  Created by Stanislav Volskyi on 11.07.2025.
//

import Foundation

extension String {
    var decimal: Decimal? {
        DecimalFormatter.numberFormatter.number(from: self)?.decimalValue
    }
}

