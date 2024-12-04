//
//  FetchBusinessStatusUseCase.swift
//  BusinessNumberValidate
//
//  Created by SCC-PC on 2024/12/04.
//

import Foundation
import Combine

protocol FetchBusinessStatusUseCase {
    func execute(businessNumber: String) -> AnyPublisher<BusinessStatus, Error>
}

struct FetchBusinessStatusUseCaseImpl: FetchBusinessStatusUseCase {
    let repository: BusinessStatusRepository

    init(repository: BusinessStatusRepository) {
        self.repository = repository
    }

    func execute(businessNumber: String) -> AnyPublisher<BusinessStatus, Error> {
        return repository.fetchBusinessStatus(for: businessNumber)
    }
}
