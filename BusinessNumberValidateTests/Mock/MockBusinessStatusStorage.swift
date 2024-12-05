//
//  MockBusinessStatusStorage.swift
//  BusinessNumberValidate
//
//  Created by 일하는석찬 on 12/5/24.
//
import CoreData
import XCTest

@testable import BusinessNumberValidate

final class MockCoreDataStorage: BusinessStatusStorageProtocol {
    private var mockData: [BusinessStatus] = []

    func save(_ object: BusinessStatus) {
        if let index = mockData.firstIndex(where: { $0.bNo == object.bNo }) {
            mockData[index] = object
        } else {
            mockData.append(object)
        }
    }

    func fetch(predicate: NSPredicate?) -> [BusinessStatus] {
        guard let predicate = predicate else {
            return mockData
        }
        if let businessNumber = predicate.extractBusinessNumber() {
            return mockData.filter { $0.bNo == businessNumber }
        }

        return []
    }

    func delete(predicate: NSPredicate?) {
        guard let predicate = predicate else { return }
        if let businessNumber = predicate.extractBusinessNumber() {
            mockData.removeAll { $0.bNo == businessNumber }
        }
    }
}

private extension NSPredicate {
    func compoundFormatValue() -> Any? {
        let format = self.predicateFormat
        let components = format.split(separator: "'")
        return components.count > 1 ? components[1] : nil
    }
    
    func extractBusinessNumber() -> String? {
        guard let comparisonPredicate = self as? NSComparisonPredicate else {
            print("[MockCoreDataStorage] Unsupported NSPredicate type.")
            return nil
        }

        if let businessNumber = comparisonPredicate.rightExpression.constantValue as? String {
            return businessNumber
        }

        print("[MockCoreDataStorage] Could not extract business number.")
        return nil
    }
}
