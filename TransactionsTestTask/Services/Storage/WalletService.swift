//
//  WalletService.swift
//  TransactionsTestTask
//
//  Created by Stanislav Volskyi on 11.07.2025.
//

import Foundation

protocol WalletService {
    func getWallet() throws -> Wallet
    func refillWallet(_ amount: Decimal) throws
    func updateLatestRate(_ rate: Decimal) throws
}

final class WalletServiceImpl: WalletService {
    private let storage = DataStorageImpl<Wallet>()

    func getWallet() throws -> Wallet {
        guard let wallet = try storage.fetch(predicate: nil, sortDescriptors: nil).first else {
            let newWallet = Wallet(context: storage.context)
            newWallet.balance = 0
            try storage.save()
            return newWallet
        }
        return wallet
    }

    func refillWallet(_ amount: Decimal) throws {
        let wallet = try getWallet()
        let updatedBalance = wallet.balanceValue + amount
        wallet.balance = NSDecimalNumber(decimal: updatedBalance)
        try storage.save()
    }

    func updateLatestRate(_ rate: Decimal) throws {
        let wallet = try getWallet()
        wallet.btcUsdRate = NSDecimalNumber(decimal: rate)
        try storage.save()
    }
}
