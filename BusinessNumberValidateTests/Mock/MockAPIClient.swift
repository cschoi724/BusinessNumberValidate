//
//  MockAPIClient.swift
//  BusinessNumberValidate
//
//  Created by 일하는석찬 on 12/4/24.
//

import Combine
import XCTest

@testable import BusinessNumberValidate

final class MockAPIClient: NetworkService {
    var response: Result<Data, APIError>?
    var delay: TimeInterval = 0
    private var delayedResponses: [String: (Result<Data, APIError>, TimeInterval)] = [:]
    private var isNetworkAvailable: Bool = true
    
    func request<T: Decodable>(_ endpoint: Endpoint) -> AnyPublisher<T, APIError> {
        if let (response, delay) = delayedResponses[endpoint.path] {
            return Future { promise in
                DispatchQueue.global().asyncAfter(deadline: .now() + delay) {
                    self.handleResponse(response: response, promise: promise)
                }
            }
            .eraseToAnyPublisher()
        }

        guard isNetworkAvailable else {
            print("[MockAPIClient] Simulating network unavailability.")
            return Fail(error: .networkError(NSError(domain: "Network unavailable", code: -1, userInfo: nil)))
                .eraseToAnyPublisher()
        }

        guard let response = response else {
            print("[MockAPIClient] No response set.")
            return Fail(error: .networkError(NSError(domain: "No Mock Response", code: -1, userInfo: nil)))
                .eraseToAnyPublisher()
        }

        // 일반 요청 처리
        return Future { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + self.delay) {
                self.handleResponse(response: response, promise: promise)
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func handleResponse<T: Decodable>(
        response: Result<Data, APIError>,
        promise: @escaping (Result<T, APIError>) -> Void
    ) {
        switch response {
        case .success(let data):
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                promise(.success(decoded))
                print("[MockAPIClient] Decoded data: \(decoded)")
            } catch {
                print("[MockAPIClient] Decoding failed: \(error.localizedDescription)")
                promise(.failure(.decodingError("Decoding failed: \(error.localizedDescription)")))
            }
        case .failure(let error):
            print("[MockAPIClient] Returning failure: \(error).")
            promise(.failure(error))
        }
    }
    
    func setResponseAfterDelay(for businessNumber: String, response: Result<Data, APIError>, delay: TimeInterval) {
        delayedResponses[businessNumber] = (response, delay)
    }
    
    func setNetworkAvailability(_ available: Bool) {
        isNetworkAvailable = available
        if available {
            print("[MockAPIClient] Network restored.")
        } else {
            print("[MockAPIClient] Network unavailable.")
        }
    }
}
