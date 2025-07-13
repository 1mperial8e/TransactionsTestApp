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
    func fetch(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?, paginationData: PaginationData?) throws -> [Entity]
    func delete(object: Entity) throws
}

struct PaginationData {
    let page: Int
    let size: Int
}

class DataStorageImpl<T: NSManagedObject>: DataStorage {
    typealias Entity = T
    var context: NSManagedObjectContext {
        return CoreDataContainer.appContainer.viewContext
    }

    func save() throws {
        if context.hasChanges {
            try context.save()
        }
    }

    func fetch(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, paginationData: PaginationData? = nil) throws -> [T] {
        let entityName = String(describing: T.self)
        let request = NSFetchRequest<T>(entityName: entityName)
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        if let paginationData = paginationData {
            request.fetchLimit = paginationData.size
            request.fetchOffset = (paginationData.page - 1) * paginationData.size
        }
        return try context.fetch(request)
    }

    func delete(object: T) throws {
        context.delete(object)
        try context.save()
    }
}
