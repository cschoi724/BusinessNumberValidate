//
//  BusinessStatusRepositoryImpl.swift
//  BusinessNumberValidate
//
//  Created by SCC-PC on 2024/12/04.
//

import Foundation
import Combine

struct BusinessStatusRepositoryImpl: BusinessStatusRepository {
    let apiClient: NetworkService

    init(apiClient: NetworkService) {
        self.apiClient = apiClient
    }

    func fetchBusinessStatus(for businessNumber: String) -> AnyPublisher<BusinessStatus, Error> {
        let endpoint = Endpoint.businessStatusEndpoint(businessNumbers: [businessNumber])

        return apiClient.request(endpoint)
            .tryMap { (response: ResponseDTO<[BusinessStatusDTO]>) in
                guard let dto = response.data.first else {
                    throw URLError(.badServerResponse)
                }
                return dto.domain
            }
            .eraseToAnyPublisher()
    }
}
