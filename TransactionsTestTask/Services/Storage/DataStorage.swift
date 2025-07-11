//
//  DataStorage.swift
//  TransactionsTestTask
//
//  Created by Stanislav Volskyi on 11.07.2025.
//

import Foundation
import CoreData

protocol DataStorage {
    associatedtype Entity: NSManagedObject
    var context: NSManagedObjectContext { get }
    
    func save() throws
    func fetch(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) throws -> [Entity]
    func delete(object: Entity) throws
}

class DataStorageImpl<T: NSManagedObject>: DataStorage {
    typealias Entity = T
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    private let persistentContainer: NSPersistentContainer
    private let modelName = "TransactionsTestTask"

    init() {
        persistentContainer = NSPersistentContainer(name: modelName)
        persistentContainer.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Failed to load store: \(error)")
            }
        }
    }

    func save() throws {
        if context.hasChanges {
            try context.save()
        }
    }

    func fetch(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) throws -> [T] {
        let entityName = String(describing: T.self)
        let request = NSFetchRequest<T>(entityName: entityName)
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors

        return try context.fetch(request)
    }

    func delete(object: T) throws {
        context.delete(object)
        try context.save()
    }
}
