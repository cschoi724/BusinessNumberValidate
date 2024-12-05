//
//  ResponseDTO.swift
//  BusinessNumberValidate
//
//  Created by SCC-PC on 2024/12/04.
//

import Foundation

struct ResponseDTO<Result: Codable>: Codable {
    let requestCnt: Int
    let statusCode: String
    let data: Result!
    
    enum CodingKeys: String, CodingKey {
        case requestCnt = "request_cnt"
        case statusCode = "status_code"
        case data = "data"
    }
}
