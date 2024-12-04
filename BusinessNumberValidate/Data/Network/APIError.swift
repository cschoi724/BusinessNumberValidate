//
//  APIError.swift
//  BusinessNumberValidate
//
//  Created by 일하는석찬 on 12/4/24.
//

enum APIError: Error {
    case invalidURL
    case badServerResponse(statusCode: Int)
    case decodingError(String)
    case networkError(Error)
}
