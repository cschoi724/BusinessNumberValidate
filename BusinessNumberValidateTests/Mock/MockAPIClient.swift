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

    func request<T: Decodable>(_ endpoint: Endpoint) -> AnyPublisher<T, APIError> {
        guard let response = response else {
            print("[MockAPIClient] No response set.")
            return Fail(error: .networkError(NSError(domain: "No Mock Response", code: -1, userInfo: nil)))
                .eraseToAnyPublisher()
        }

        return Future { promise in
            print("[MockAPIClient] Sending mock response after \(self.delay) seconds.")
            DispatchQueue.global().asyncAfter(deadline: .now() + self.delay) {
                switch response {
                case .success(let data):
                    print("[MockAPIClient] Returning success response.")
                    do {
                        let decoded = try JSONDecoder().decode(T.self, from: data)
                        promise(.success(decoded))
                        print("[MockAPIClient] decoded data: \(decoded)")
                    } catch {
                        print("[MockAPIClient] Decoding failed: \(error.localizedDescription)")
                        promise(.failure(.decodingError("Decoding failed: \(error.localizedDescription)")))
                    }
                case .failure(let error):
                    print("[MockAPIClient] Returning failure: \(error).")
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
