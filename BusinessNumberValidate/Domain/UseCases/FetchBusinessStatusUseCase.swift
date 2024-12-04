//
//  FetchBusinessStatusUseCase.swift
//  BusinessNumberValidate
//
//  Created by SCC-PC on 2024/12/04.
//

import Foundation
import Combine

protocol FetchBusinessStatusUseCase {
    func execute(businessNumber: String) -> AnyPublisher<BusinessStatus, BusinessError>
}

struct FetchBusinessStatusUseCaseImpl: FetchBusinessStatusUseCase {
    let repository: BusinessStatusRepository

    init(repository: BusinessStatusRepository) {
        self.repository = repository
    }

    func execute(businessNumber: String) -> AnyPublisher<BusinessStatus, BusinessError> {
        return repository.fetchBusinessStatus(for: businessNumber)
    }
}
