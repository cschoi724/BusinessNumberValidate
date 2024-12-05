//
//  APIClient.swift
//  BusinessNumberValidate
//
//  Created by SCC-PC on 2024/12/04.
//

import Foundation
import Combine

protocol NetworkService {
    func request<T: Decodable>(_ endpoint: Endpoint) -> AnyPublisher<T, APIError>
}

final class APIClient: NetworkService {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func request<T: Decodable>(_ endpoint: Endpoint) -> AnyPublisher<T, APIError> {
        guard let url = endpoint.url else {
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        
        if let body = endpoint.body {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                return Fail(error: .decodingError("Failed to serialize JSON body: \(error.localizedDescription)")).eraseToAnyPublisher()
            }
        }
        
        return Future { [weak self, request] promise in
            guard let self = self else { return }
            
            Task {
                do {
                    let (data, response) = try await self.session.data(for: request)
                    guard let httpResponse = response as? HTTPURLResponse else {
                        throw APIError.badServerResponse(statusCode: 0)
                    }
                    
                    switch httpResponse.statusCode {
                    case 200..<300:
                        let decodedData = try JSONDecoder().decode(T.self, from: data)
                        promise(.success(decodedData))
                    default:
                        throw APIError.badServerResponse(statusCode: httpResponse.statusCode)
                    }
                } catch let error as APIError {
                    promise(.failure(error))
                } catch {
                    promise(.failure(.networkError(error)))
                }
            }
        }
        .receive(on: DispatchQueue.main)
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
