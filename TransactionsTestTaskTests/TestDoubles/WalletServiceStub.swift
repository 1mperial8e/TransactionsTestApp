//
//  WalletServiceStub.swift
//  TransactionsTestTask
//
//  Created by Stanislav Volskyi on 13.07.2025.
//

import Foundation
import Combine
@testable import TransactionsTestTask

final class WalletServiceStub: WalletService {
    var balancePublisher: AnyPublisher<Decimal, Never> {
        fatalError("Stub not implemented")
    }

    var storedRate: Decimal = .nan

    func getWallet() throws -> Wallet {
        Wallet(context: CoreDataContainer.appContainer.viewContext)
    }
    
    func refillWallet(_ amount: Decimal) throws {
        fatalError("Stub not implemented")
    }

    func updateLatestRate(_ rate: Decimal) throws {
        storedRate = rate
    }
    
    func deduct(amount: Decimal) throws {
        fatalError("Stub not implemented")
    }

}
