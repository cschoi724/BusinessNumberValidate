//
//  BusinessStatusEntity.swift
//  BusinessNumberValidate
//
//  Created by 일하는석찬 on 12/5/24.
//

import CoreData

@objc(BusinessStatusEntity)
public class BusinessStatusEntity: NSManagedObject {
    @NSManaged var bNo: String?
    @NSManaged var bStt: String?
    @NSManaged var bSttCd: String?
    @NSManaged var taxType: String?
    @NSManaged var taxTypeCd: String?
    @NSManaged var endDt: String?
    @NSManaged var utccYn: String?
    @NSManaged var taxTypeChangeDt: String?
    @NSManaged var invoiceApplyDt: String?
    @NSManaged var rbfTaxType: String?
    @NSManaged var rbfTaxTypeCd: String?
    @NSManaged var lastUpdated: Date?
}

extension BusinessStatusEntity: CoreDataConvertible {
    public typealias DomainModel = BusinessStatus

    public var domain: DomainModel {
        return BusinessStatus(
            bNo: self.bNo ?? "",
            bStt: self.bStt ?? "",
            bSttCd: self.bSttCd ?? "",
            taxType: self.taxType ?? "",
            taxTypeCd: self.taxTypeCd ?? "",
            endDt: self.endDt ?? "",
            utccYn: self.utccYn ?? "",
            taxTypeChangeDt: self.taxTypeChangeDt ?? "",
            invoiceApplyDt: self.invoiceApplyDt ?? "",
            rbfTaxType: self.rbfTaxType ?? "",
            rbfTaxTypeCd: self.rbfTaxTypeCd ?? "",
            lastUpdated: self.lastUpdated
        )
    }

    public func update(from model: BusinessStatus) {
        self.bNo = model.bNo
        self.bStt = model.bStt
        self.bSttCd = model.bSttCd
        self.taxType = model.taxType
        self.taxTypeCd = model.taxTypeCd
        self.endDt = model.endDt
        self.utccYn = model.utccYn
        self.taxTypeChangeDt = model.taxTypeChangeDt
        self.invoiceApplyDt = model.invoiceApplyDt
        self.rbfTaxType = model.rbfTaxType
        self.rbfTaxTypeCd = model.rbfTaxTypeCd
        self.lastUpdated = model.lastUpdated
    }
}

extension BusinessStatusEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<BusinessStatusEntity> {
        return NSFetchRequest<BusinessStatusEntity>(entityName: "BusinessStatusEntity")
    }
}
