//
//  WalletService.swift
//  TransactionsTestTask
//
//  Created by Stanislav Volskyi on 11.07.2025.
//

import Foundation
import Combine

protocol WalletService {
    var balancePublisher: AnyPublisher<Decimal, Never> { get }
    func getWallet() throws -> Wallet
    func refillWallet(_ amount: Decimal) throws
    func updateLatestRate(_ rate: Decimal) throws
    func deduct(amount: Decimal) throws
}

final class WalletServiceImpl: WalletService {
    var balancePublisher: AnyPublisher<Decimal, Never> { $walletBalance.eraseToAnyPublisher() }

    private let storage = DataStorageImpl<Wallet>()
    @Published private var walletBalance: Decimal = 0

    func getWallet() throws -> Wallet {
        guard let wallet = try storage.fetch(predicate: nil, sortDescriptors: nil).first else {
            let newWallet = Wallet(context: storage.context)
            newWallet.balance = 0
            try storage.save()
            walletBalance = 0
            return newWallet
        }
        walletBalance = wallet.balanceValue
        return wallet
    }

    func refillWallet(_ amount: Decimal) throws {
        let wallet = try getWallet()
        let updatedBalance = wallet.balanceValue + amount
        wallet.balance = NSDecimalNumber(decimal: updatedBalance)
        try storage.save()
        walletBalance = updatedBalance
    }

    func updateLatestRate(_ rate: Decimal) throws {
        let wallet = try getWallet()
        wallet.btcUsdRate = NSDecimalNumber(decimal: rate)
        try storage.save()
    }

    func deduct(amount: Decimal) throws {
        let wallet = try getWallet()
        let updatedBalance = wallet.balanceValue - amount
        wallet.balance = NSDecimalNumber(decimal: updatedBalance)
        try storage.save()
        walletBalance = updatedBalance
    }
}
