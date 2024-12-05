//
//  Convertible.swift
//  BusinessNumberValidate
//
//  Created by 일하는석찬 on 12/5/24.
//

public protocol CoreDataConvertible {
    associatedtype DomainModel

    var domain: DomainModel { get }    
    func update(from model: DomainModel)
}
