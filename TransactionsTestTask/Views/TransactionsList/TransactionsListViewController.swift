//
//  TransactionsListViewController.swift
//  TransactionsTestTask
//
//  Created by Stanislav Volskyi on 12.07.2025.
//

import UIKit
import Combine

final class TransactionsListViewController: UIViewController {
    private let viewModel: any TransactionsListViewModel

    private var loadDataSubject: PassthroughSubject<Void, Never> = .init()
    private var loadMoreSubject: PassthroughSubject<Void, Never> = .init()

    private var sections: [TransactionsSection] = []
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Init
    init(viewModel: any TransactionsListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        bindViewModel()
        loadDataSubject.send()
    }

    // MARK: Bindings
    private func bindViewModel() {
        let output = viewModel.bind(
            input: .init(
                loadData: loadDataSubject.eraseToAnyPublisher(),
                loadMore: loadMoreSubject.eraseToAnyPublisher()
            )
        )
        output
            .sections
            .receive(on: DispatchQueue.main)
            .sink { [weak self] sections in
                self?.handle(sections: sections)
            }
            .store(in: &cancellables)
    }

    private func handle(sections: [TransactionsSection]) {
        self.sections = sections
        self.tableView.reloadData()
        if sections.isEmpty {
            show(stateData: TransactionsEmptyStateData())
        } else {
            hideStateView()
        }
    }

    // MARK: - Layout
    private func setupLayout() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func show(stateData: StateViewData) {
        stateView.configure(with: stateData)
        view.addSubview(stateView)
        NSLayoutConstraint.activate([
            stateView.topAnchor.constraint(equalTo: view.topAnchor),
            stateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stateView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func hideStateView() {
        stateView.removeFromSuperview()
    }

    // MARK: - UI Elements
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: TransactionTableViewCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
        return tableView
    }()

    private lazy var stateView: StateView = {
        let stateView = StateView()
        stateView.translatesAutoresizingMaskIntoConstraints = false
        return stateView
    }()
}

// MARK: - UITableViewDataSource
extension TransactionsListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTableViewCell.reuseIdentifier, for: indexPath) as? TransactionTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: sections[indexPath.section].items[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TransactionsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == sections.count - 1,
           indexPath.row == sections[indexPath.section].items.count - 1 {
            loadMoreSubject.send()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
