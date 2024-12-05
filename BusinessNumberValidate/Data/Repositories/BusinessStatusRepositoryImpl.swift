//
//  BusinessStatusRepositoryImpl.swift
//  BusinessNumberValidate
//
//  Created by SCC-PC on 2024/12/04.
//

import Foundation
import Combine

final class BusinessStatusRepositoryImpl: BusinessStatusRepository {
    let apiClient: NetworkService
    let storage: BusinessStatusStorageProtocol
    private let taskQueue = TaskQueue()
    private var cancellables: Set<AnyCancellable> = []
    
    init(apiClient: NetworkService, storage: BusinessStatusStorageProtocol) {
        self.apiClient = apiClient
        self.storage = storage
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleNetworkRestored),
            name: .networkRestored,
            object: nil
        )
    }

    func fetchBusinessStatus(for businessNumber: String) -> AnyPublisher<BusinessStatus, BusinessError> {
        let endpoint = Endpoint.businessStatusEndpoint(businessNumbers: [businessNumber])
        print("[Repository] Fetching business status for: \(businessNumber)")
        
        if let cachedBusinessStatus = storage.fetch(predicate: NSPredicate(format: "bNo == %@", businessNumber)).first {
            if isCacheValid(for: cachedBusinessStatus, expirationInterval: 3600) { // 1시간 유효
                print("[Repository] Using valid cached data: \(cachedBusinessStatus)")
                return Just(cachedBusinessStatus)
                    .setFailureType(to: BusinessError.self)
                    .eraseToAnyPublisher()
            }
        }
        print("[Repository] No cached data found, fetching from network...")
        return apiClient.request(endpoint)
            .tryMap { (response: ResponseDTO<[BusinessStatusDTO]>) in
                guard let data = response.data,
                      let businessDTO = data.first else {
                    throw BusinessError.networkError("응답 데이터가 비어있습니다.")
                }
                print("[Repository] Successfully fetched business data: \(businessDTO)")
                let businessStatus = businessDTO.domain
                self.storage.save(businessStatus)
                return businessStatus
            }
            .retryWithExponentialBackoff(retries: 3, initialDelay: 1)
            .mapError { error in
                if let apiError = error as? APIError,
                   case .networkError(let statusCode) = apiError {
                    print("[Repository] Adding task to queue for networkError: \(statusCode)")
                    self.taskQueue.addTask(
                        NetworkTask(businessNumber: businessNumber, retryCount: 3)
                    )
                }
                return self.resolveAPIError(error)
            }
            .eraseToAnyPublisher()
    }
}

extension BusinessStatusRepositoryImpl {
    private func resolveAPIError(_ error: Error) -> BusinessError {
        if let apiError = error as? APIError {
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
        }

        return .unknownError("알 수 없는 에러 발생: \(error.localizedDescription)")
    }
    
    private func isCacheValid(for businessStatus: BusinessStatus, expirationInterval: TimeInterval) -> Bool {
        guard let lastUpdated = businessStatus.lastUpdated else {
            return false // 업데이트된 적이 없으면 무효화
        }
        return Date().timeIntervalSince(lastUpdated) < expirationInterval
    }
    
    @objc private func handleNetworkRestored() {
        print("[Repository] Network restored, retrying tasks...")
        processQueue()
    }

    private func processQueue() {
        while let task = taskQueue.fetchNextTask() {
            print("[Test] Processing task for business number: \(task.businessNumber)")
            fetchBusinessStatus(for: task.businessNumber)
                .sink(receiveCompletion: { completion in
                    if case .failure = completion {
                        if task.retryCount > 0 {
                            print("[Test] Task failed, re-queuing: \(task.businessNumber)")
                            self.taskQueue.addTask(
                                NetworkTask(businessNumber: task.businessNumber, retryCount: task.retryCount - 1)
                            )
                        } else {
                            print("[Test] Task permanently failed: \(task.businessNumber)")
                        }
                    }
                }, receiveValue: { businessStatus in
                    print("[Test] Task succeeded: \(businessStatus.bNo)")
                    // 재시도한 결과를 외부로 전달할 비즈니스 요구사항이 없음..
                })
                .store(in: &cancellables)
        }
    }
}
