//
//  AddTransactionViewController.swift
//  TransactionsTestTask
//
//  Created by Stanislav Volskyi on 10.07.2025.
//

import UIKit

final class AddTransactionViewController: UIViewController {

    private let viewModel: AddTransactionViewModel

    // MARK: Init
    init(viewModel: AddTransactionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = L10n.Transactions.AddTransaction.title
    }
}
