//
//  BusinessStatusRepository.swift
//  BusinessNumberValidate
//
//  Created by SCC-PC on 2024/12/04.
//

import Combine

protocol BusinessStatusRepository {
    func fetchBusinessStatus(for businessNumber: String) -> AnyPublisher<BusinessStatus, BusinessError>
}
