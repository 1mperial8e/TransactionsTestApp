//
//  InputView.swift
//  TransactionsTestTask
//
//  Created by Stanislav Volskyi on 13.07.2025.
//

import UIKit

final class InputView: UIView {

    // MARK: - Init
    init(title: String, inputField: UIView) {
        super.init(frame: .zero)
        build(inputField: inputField)
        titleLabel.text = title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration
    func configure(with data: StateViewData) {
        titleLabel.text = data.title
    }

    private func build(inputField: UIView) {
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacer.lg),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacer.lg),
            stackView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor)
        ])
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(inputField)
    }

    // MARK: - UI Elements
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Spacer.sm
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
}
