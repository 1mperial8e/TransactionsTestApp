//
//  AddTransactionViewController.swift
//  TransactionsTestTask
//
//  Created by Stanislav Volskyi on 10.07.2025.
//

import UIKit
import Combine

final class AddTransactionViewController: UIViewController {
    private let viewModel: any AddTransactionViewModel

    private var amountSubject = PassthroughSubject<String?, Never>()
    private var categorySubject = PassthroughSubject<TransactionCategory, Never>()
    private var referenceSubject = PassthroughSubject<String?, Never>()
    private var onAddTransaction = PassthroughSubject<Void, Never>()

    @Published private var categories: [TransactionCategory] = []

    // MARK: - Init
    init(viewModel: any AddTransactionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationitem()
        setupLayout()
        amountTextField.becomeFirstResponder()
        bindViewModel()
    }

    // MARK: - Bindings
    private func bindViewModel() {
        let output = viewModel.bind(input:
                .init(
                    amount: amountSubject.eraseToAnyPublisher(),
                    reference: referenceSubject.eraseToAnyPublisher(),
                    category: categorySubject.eraseToAnyPublisher(),
                    addTapped: onAddTransaction.eraseToAnyPublisher()
                )
        )
        output.categories.assign(to: &$categories)
    }

    // MARK: - Layout
    private func setupLayout() {
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        scrollView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            stackView.bottomAnchor.constraint(greaterThanOrEqualTo: scrollView.bottomAnchor, constant: 0),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
        ])
        stackView.addArrangedSubview(amountInput)
        stackView.addArrangedSubview(categoryInput)
        stackView.addArrangedSubview(referenceInput)

        amountTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        categoryTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        referenceTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
    }

    private func setupNavigationitem() {
        navigationItem.title = L10n.Transactions.AddTransaction.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            systemItem: .add,
            primaryAction: .init(handler: { [weak self] _ in
                self?.onAddTransaction.send()
            })
        )
    }

    // MARK: - UI Components
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = false
        return scrollView
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Spacer.md
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layoutMargins = .init(top: Spacer.md, left: Spacer.md, bottom: view.safeAreaInsets.bottom, right: Spacer.md)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    private lazy var amountTextField: UITextField = {
        let textField = UITextField()
        textField.font = .preferredFont(forTextStyle: .title2)
        textField.textColor = .label
        textField.keyboardType = .decimalPad
        textField.delegate = self
        textField.rightViewMode = .always
        textField.rightView = btcLabel
        textField.layoutMargins = UIEdgeInsets(top: Spacer.xs, left: Spacer.md, bottom: Spacer.xs, right: Spacer.md)
        DesignSystem.addBorder(textField)
        return textField
    }()

    private lazy var btcLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        label.text = L10n.Transactions.Btc.code
        return label
    }()

    private lazy var amountInput: InputView = {
        .init(title: L10n.Transactions.AddTransaction.Amount.title, inputField: amountTextField)
    }()

    private lazy var referenceTextView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .body)
        textView.textColor = .label
        textView.delegate = self
        textView.setContentHuggingPriority(.defaultLow, for: .vertical)
        textView.isScrollEnabled = false
        DesignSystem.addBorder(textView)
        return textView
    }()

    private lazy var referenceInput: InputView = {
        .init(title: L10n.Transactions.AddTransaction.Reference.title, inputField: referenceTextView)
    }()

    private lazy var categoryPicker: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.showsLargeContentViewer = true
        return pickerView
    }()

    private lazy var categoryTextField: UITextField = {
        let textField = UITextField()
        textField.font = .preferredFont(forTextStyle: .body)
        textField.inputView = categoryPicker
        DesignSystem.addBorder(textField)
        return textField
    }()

    private lazy var categoryInput: InputView = {
        .init(title: L10n.Transactions.AddTransaction.Category.title, inputField: categoryTextField)
    }()
}

// MARK: - UITextFieldDelegate
extension AddTransactionViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text as? NSString)?.replacingCharacters(in: range, with: string)
        amountSubject.send(newText)
        return true
    }
}

// MARK: - UITextViewDelegate
extension AddTransactionViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        referenceSubject.send(textView.text)
    }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension AddTransactionViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row].text
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categorySubject.send(categories[row])
        categoryTextField.text = categories[row].text
    }
}
