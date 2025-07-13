//
//  TransactionsListViewModel.swift
//  TransactionsTestTask
//
//  Created by Stanislav Volskyi on 12.07.2025.
//

import Foundation
import Combine

protocol TransactionsListViewModel: PaginatedDataProvider {
    init(transactionsService: TransactionsService)
    func bind(input: Input) -> Output
}

struct TransactionsSection {
    let title: String
    let items: [Transaction]
}

struct Input {
    var loadData: AnyPublisher<Void, Never>
    var loadMore: AnyPublisher<Void, Never>
}

struct Output {
    var sections: AnyPublisher<[TransactionsSection], Never>
}

final class TransactionsListViewModelImpl: TransactionsListViewModel {
    typealias Item = Transaction

    var hasMore: Bool {
        let transactionsCount = sections.flatMap { $0.items }.count
        return transactionsCount % pageSize == 0
    }
    private var dataReachetToEnd: Bool = false

    private let transactionsService: TransactionsService
    @Published private var sections: [TransactionsSection] = []
    private var cancellables: Set<AnyCancellable> = []

    private var page: Int = 1
    private let pageSize: Int = 20

    init(transactionsService: TransactionsService) {
        self.transactionsService = transactionsService
    }
    
    func bind(input: Input) -> Output {
        input
            .loadData
            .sink { [weak self] _ in
                self?.loadData()
            }
            .store(in: &cancellables)
        input
            .loadMore
            .sink { [weak self] _ in
                self?.loadMore()
            }
            .store(in: &cancellables)
        transactionsService
            .transactionsChangePublisher
            .sink { [weak self] _ in
                self?.loadData()
            }
            .store(in: &cancellables)
        return .init(sections: $sections.eraseToAnyPublisher())
    }

    // MARK: PaginatedDataProvider
    func loadData() {
        page = 1
        loadTransactions(reloadAll: true)
    }

    func loadMore() {
        guard hasMore, !dataReachetToEnd else { return }
        page += 1
        loadTransactions()
    }

    private func loadTransactions(reloadAll: Bool = false) {
        do {
            let fetchResult = try transactionsService.getTransactions(page: page, size: pageSize)
            if fetchResult.isEmpty {
                dataReachetToEnd = true
                return
            }
            if reloadAll {
                sections.removeAll()
            }
            sections += transform(fetchResult)
        } catch {
            #if DEBUG
                print("Error: \(error)")
            #endif
        }
    }

    private func transform(_ transactions: [Transaction]) -> [TransactionsSection] {
        guard transactions.count > 1 else {
            return []
        }
        var sections: [TransactionsSection] = []
        var transactionsByDay: [Transaction] = []
        var currentDate = transactions.first?.valueDate ?? Date()
        for transaction in transactions {
            if !Calendar.current.isDate(currentDate, inSameDayAs: transaction.date) {
                sections.append(.init(title: currentDate.shortDateString, items: transactionsByDay))
                transactionsByDay.removeAll()
                currentDate = transaction.date
            }
            transactionsByDay.append(transaction)
        }
        sections.append(.init(title: currentDate.shortDateString, items: transactionsByDay))
        return sections
    }
}
