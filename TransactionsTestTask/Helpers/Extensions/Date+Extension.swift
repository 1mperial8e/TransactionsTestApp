//
//  Date+Extension.swift
//  TransactionsTestTask
//
//  Created by Stanislav Volskyi on 13.07.2025.
//

import Foundation

extension Date {
    static let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM YYYY"
        return formatter
    }()

    static let timeDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm"
        return formatter
    }()

    var shortDateString: String {
        Date.shortDateFormatter.string(from: self)
    }

    var timeString: String {
        Date.timeDateFormatter.string(from: self)
    }
}
