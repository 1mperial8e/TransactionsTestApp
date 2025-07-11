//
//  AppRouter.swift
//  TransactionsTestTask
//
//  Created by Stanislav Volskyi on 10.07.2025.
//

import UIKit

protocol AppRouter {
    var navigationController: UINavigationController { get }

    func showDashboard()
    func showAddNewTransaction()
    func show(alert: UIAlertController)
    func goBack()
}
