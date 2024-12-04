//
//  Endpoint.swift
//  BusinessNumberValidate
//
//  Created by SCC-PC on 2024/12/04.
//

import Foundation

struct Endpoint {
    let path: String
    let method: HTTPMethod
    let headers: [String: String]?
    let queryItems: [URLQueryItem]?
    let body: Data?
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.odcloud.kr"
        components.path = path
        components.queryItems = queryItems
        return components.url
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

extension Endpoint {
    // 사업자 상태 조회를 위한 Endpoint 생성
    static func businessStatusEndpoint(businessNumbers: [String]) -> Endpoint {
        let bodyDict: [String: [String]] = ["b_no": businessNumbers]
        let bodyData = try? JSONSerialization.data(withJSONObject: bodyDict)

        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Infuser a/55NV04ZF/MTYBnVZurcRg6PCciclz50TrPlRiDw8dN1AvXeC9V1KjmHtUs/qtvZ1tigKvxiPA9cYoGWr/Efg=="
        ]

        let queryItems = [
            URLQueryItem(name: "serviceKey", value: "a/55NV04ZF/MTYBnVZurcRg6PCciclz50TrPlRiDw8dN1AvXeC9V1KjmHtUs/qtvZ1tigKvxiPA9cYoGWr/Efg==")
        ]

        return Endpoint(
            path: "/api/nts-businessman/v1/status",
            method: .post,
            headers: headers,
            queryItems: queryItems,
            body: bodyData
        )
    }
}
