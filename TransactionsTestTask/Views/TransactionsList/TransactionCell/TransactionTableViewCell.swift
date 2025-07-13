//
//  TransactionTableViewCell.swift
//  TransactionsTestTask
//
//  Created by Stanislav Volskyi on 12.07.2025.
//

import UIKit

final class TransactionTableViewCell: UITableViewCell {
    static let reuseIdentifier = "TransactionTableViewCell"

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Data
    func configure(with transaction: Transaction) {
        amountLabel.text = amountString(transaction)
        categoryLabel.text = transaction.isDebit ? L10n.Transactions.List.deposit : transaction.category?.text
        referenceLabel.text = transaction.reference
        dateLabel.text = transaction.valueDate?.timeString
        categoryIndicatorView.backgroundColor = transaction.isDebit ? .systemGreen : transaction.category?.color
    }

    private func amountString(_ transaction: Transaction) -> String {
        let sign = transaction.isDebit ? "+" : "-"
        let btc = L10n.Transactions.Btc.code
        return "\(sign)\(transaction.amountValue.formatted()) \(btc)"
    }

    // MARK: - Layout
    private func setupLayout() {
        amountLabel.setContentHuggingPriority(.required, for: .horizontal)
        dateLabel.setContentHuggingPriority(.required, for: .horizontal)
        amountLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        dateLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        let indicatorSize = CornerRadius.sm * 2
        categoryIndicatorView.heightAnchor.constraint(equalToConstant: indicatorSize).isActive = true
        categoryIndicatorView.widthAnchor.constraint(equalToConstant: indicatorSize).isActive = true

        let balanceStackView = UIStackView(arrangedSubviews: [categoryLabel, amountLabel])
        balanceStackView.spacing = Spacer.md
        balanceStackView.alignment = .center
        
        referenceLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        let detailsStackView = UIStackView(arrangedSubviews: [referenceLabel, dateLabel])
        detailsStackView.spacing = Spacer.md

        let transactionStackView = UIStackView(arrangedSubviews: [balanceStackView, detailsStackView])
        transactionStackView.axis = .vertical
        transactionStackView.spacing = Spacer.sm

        let stackView = UIStackView(arrangedSubviews: [categoryIndicatorView, transactionStackView])
        stackView.axis = .horizontal
        stackView.spacing = Spacer.md
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Spacer.sm),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Spacer.sm)
        ])
    }

    // MARK: - UI Elements
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var referenceLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var categoryIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = CornerRadius.sm
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
}
