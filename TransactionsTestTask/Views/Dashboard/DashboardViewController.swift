//
//  DashboardViewController.swift
//  TransactionsTestTask
//
//

import UIKit
import Combine

class DashboardViewController: UIViewController {
    private let viewModel: DashboardViewModel

    private var onRefill = PassthroughSubject<Void, Never>()
    private var onAddTransaction = PassthroughSubject<Void, Never>()
    private var cancellables: Set<AnyCancellable> = []

    // MARK: Init
    init(viewModel: DashboardViewModel) {
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
        navigationItem.title = L10n.Dashboard.title
        navigationItem.backButtonDisplayMode = .minimal
        buildView()
        bindViewModel()
    }

    // MARK: Bindings
    private func bindViewModel() {
        let output = viewModel.bind(
            input: .init(
                refillTapped: onRefill.eraseToAnyPublisher(),
                addTransactionTapped: onAddTransaction.eraseToAnyPublisher()
            )
        )
        output
            .balance
            .sink { [weak self] value in
                self?.balanceLabel.text = L10n.Dashboard.Balance.title(value.formatted())
            }
            .store(in: &cancellables)
    }

    // MARK: Layout
    private func buildView() {
        view.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor).isActive = true

        addTransactionButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        stackView.addArrangedSubview(balanceStackView)
        stackView.addArrangedSubview(addTransactionButton)
    }

    // MARK: - UI Components
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layoutMargins = .init(top: 16, left: 16, bottom: view.safeAreaInsets.bottom, right: 16)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    private lazy var balanceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.addArrangedSubview(balanceLabel)
        stackView.addArrangedSubview(refillButton)
        return stackView
    }()

    private lazy var balanceLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        return label
    }()

    private lazy var refillButton: UIButton = {
        let button = UIButton(type: .system)
        button.addAction(.init(handler: { [weak self] _ in
            self?.onRefill.send()
        }), for: .touchUpInside)
        button.setTitle(L10n.Dashboard.Balance.refillButton, for: .normal)
        return button
    }()

    private lazy var addTransactionButton: UIButton = {
        let button = UIButton(type: .system)
        button.addAction(.init(handler: { [weak self] _ in
            self?.onAddTransaction.send()
        }), for: .touchUpInside)
        button.setTitle(L10n.Dashboard.addTransactionButton, for: .normal)
        return button
    }()
}
