//
//  PaginatedDataProvider.swift
//  TransactionsTestTask
//
//  Created by Stanislav Volskyi on 12.07.2025.
//

import Foundation

protocol PaginatedDataProvider {
    associatedtype Item

    var hasMore: Bool { get }

    func loadData()
    func loadMore()
}
