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

    func fetchBusinessStatus(for businessNumber: String) -> AnyPublisher<BusinessStatus, BusinessError> {
        let endpoint = Endpoint.businessStatusEndpoint(businessNumbers: [businessNumber])
        print("[Repository] Fetching business status for: \(businessNumber)")
        
        return apiClient.request(endpoint)
            .tryMap { (response: ResponseDTO<[BusinessStatusDTO]>) in
                guard let data = response.data,
                      let businessDTO = data.first else {
                    throw BusinessError.networkError("응답 데이터가 비어있습니다.")
                }
                print("[Repository] Successfully fetched business data: \(businessDTO)")
                return businessDTO.domain
            }
            .retryWithExponentialBackoff(retries: 3, initialDelay: 1)
            .mapError { apiError -> BusinessError in
                print("[Repository] Error occurred: \(apiError)")
                switch apiError {
                case let apiError as APIError:
                    switch apiError {
                    case .invalidURL:
                        return .networkError("유효하지 않은 URL입니다.")
                    case .badServerResponse(let statusCode):
                        return statusCode >= 400 && statusCode < 500
                            ? .clientError(statusCode, "클라이언트 요청 오류")
                            : .serverError(statusCode, "서버 응답 오류")
                    case .decodingError(let message):
                        return .decodingError("데이터 처리 오류: \(message)")
                    case .networkError(let error):
                        return .networkError(error.localizedDescription)
                    }
                default:
                    return .unknownError("알 수 없는 에러 발생")
                }
            }
            .eraseToAnyPublisher()
    }
}

extension Publisher {
    func retryWithExponentialBackoff(retries: Int, initialDelay: TimeInterval) -> AnyPublisher<Output, Failure> {
        self.catch { error -> AnyPublisher<Output, Failure> in
            guard retries > 0 else {
                return Fail(error: error).eraseToAnyPublisher()
            }

            let delay = initialDelay * pow(2.0, Double(3 - retries))
            return Just(())
                .delay(for: .seconds(delay), scheduler: DispatchQueue.global())
                .flatMap { self.retryWithExponentialBackoff(retries: retries - 1, initialDelay: initialDelay) }
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
}
