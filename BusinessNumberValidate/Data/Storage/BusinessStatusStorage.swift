//
//  CoreDataStorage.swift
//  BusinessNumberValidate
//
//  Created by 일하는석찬 on 12/5/24.
//

import CoreData

public protocol BusinessStatusStorageProtocol {
    func save(_ object: BusinessStatus)
    func fetch(predicate: NSPredicate?) -> [BusinessStatus]
    func delete(predicate: NSPredicate?)
}

public class BusinessStatusStorage: BusinessStatusStorageProtocol {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
    }

    public func save(_ object: BusinessStatus) {
        let entity = BusinessStatusEntity(context: context)
        entity.update(from: object)
        entity.lastUpdated = Date() // 저장 시 현재 시간으로 갱신
        do {
            try context.save()
        } catch {
            print("Failed to save object: \(error.localizedDescription)")
        }
    }

    public func fetch(predicate: NSPredicate? = nil) -> [BusinessStatus] {
        let request: NSFetchRequest<BusinessStatusEntity> = BusinessStatusEntity.fetchRequest()
        request.predicate = predicate

        do {
            let results = try context.fetch(request)
            return results.map { $0.domain}
        } catch {
            print("Failed to fetch objects: \(error.localizedDescription)")
            return []
        }
    }

    public func delete(predicate: NSPredicate? = nil) {
        let request: NSFetchRequest<BusinessStatusEntity> = BusinessStatusEntity.fetchRequest()
        request.predicate = predicate

        do {
            let results = try context.fetch(request)
            results.forEach { context.delete($0) }
            try context.save()
        } catch {
            print("Failed to delete objects: \(error.localizedDescription)")
        }
    }
}
