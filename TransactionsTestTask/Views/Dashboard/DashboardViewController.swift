//
//  DashboardViewController.swift
//  TransactionsTestTask
//
//

import UIKit
import Combine

class DashboardViewController: UIViewController {
    private let viewModel: any DashboardViewModel

    private var onRefill = PassthroughSubject<Void, Never>()
    private var onAddTransaction = PassthroughSubject<Void, Never>()
    private var cancellables: Set<AnyCancellable> = []

    // MARK: Init
    init(viewModel: any DashboardViewModel) {
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
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.balanceLabel.text = L10n.Dashboard.Balance.title(value.formatted())
            }
            .store(in: &cancellables)
        output
            .rate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let self else { return }
                if let value, value > 0, let formatted = value.formatted(fractions: 2) {
                    rateLabel.text = L10n.Dashboard.Rate.btcUsd(formatted)
                } else {
                    rateLabel.text = nil
                }
            }
            .store(in: &cancellables)
        output
            .transactionsViewModel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] viewModel in
                self?.showTransactionsView(viewModel: viewModel)
            }
            .store(in: &cancellables)
    }

    // MARK: Layout
    private func buildView() {
        view.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        addTransactionButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        stackView.addArrangedSubview(balanceStackView)
        stackView.addArrangedSubview(addTransactionButton)

        rateLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        rateLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 60).isActive = true
        navigationItem.rightBarButtonItem = .init(customView: rateLabel)
    }

    private func showTransactionsView(viewModel: any TransactionsListViewModel) {
        let transactionsViewController = TransactionsListViewController(viewModel: viewModel)
        transactionsViewController.loadViewIfNeeded()
        addChild(transactionsViewController)
        if let transactionsView = transactionsViewController.view {
            transactionsView.translatesAutoresizingMaskIntoConstraints = false
            transactionsView.setContentHuggingPriority(.defaultLow, for: .vertical)
            transactionsView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
            stackView.addArrangedSubview(transactionsView)
        }
        self.transactionsViewController = transactionsViewController
    }

    // MARK: - UI Components
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Spacer.md
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layoutMargins = .init(top: Spacer.md, left: Spacer.md, bottom: view.safeAreaInsets.bottom, right: Spacer.md)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    private lazy var balanceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Spacer.sm
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

    private lazy var rateLabel:  UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var transactionsViewController: UIViewController?
}
