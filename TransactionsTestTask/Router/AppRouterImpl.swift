//
//  AppRouterImpl.swift
//  TransactionsTestTask
//
//  Created by Stanislav Volskyi on 10.07.2025.
//

import UIKit

final class AppRouterImpl: AppRouter {
    private(set) var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func showDashboard() {
        let walletService = ServicesAssembler.walletService()
        let transactionService = ServicesAssembler.transactionsService()
        let bitcoinService = ServicesAssembler.bitcoinRateService()
        let dashboardViewModel = DashboardViewModelImpl(
            router: self,
            walletService: walletService,
            transactionsService: transactionService,
            bitcoinRateService: bitcoinService
        )
        let dashboardViewController = DashboardViewController(viewModel: dashboardViewModel)
        navigationController.viewControllers = [dashboardViewController]
    }
    
    func showAddNewTransaction() {
        let transactionService = ServicesAssembler.transactionsService()
        let walletService = ServicesAssembler.walletService()
        let addTransactionViewModel = AddTransactionViewModelImpl(
            router: self,
            transactionService: transactionService,
            walletService: walletService
        )
        let addTransactionViewController = AddTransactionViewController(viewModel: addTransactionViewModel)
        navigationController.pushViewController(addTransactionViewController, animated: true)
    }
    
    func show(alert: UIAlertController) {
        navigationController.present(alert, animated: true)
    }

    func goBack() {
        navigationController.popViewController(animated: true)
    }
}
