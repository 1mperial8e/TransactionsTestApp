//
//  CoreDataContainer.swift
//  TransactionsTestTask
//
//  Created by Stanislav Volskyi on 12.07.2025.
//

import Foundation
import CoreData

enum CoreDataContainer {
    static let modelName = "TransactionsTestTask"
    
    static let appContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: modelName)
        persistentContainer.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Failed to load store: \(error)")
            }
        }
        return persistentContainer
    }()
}
