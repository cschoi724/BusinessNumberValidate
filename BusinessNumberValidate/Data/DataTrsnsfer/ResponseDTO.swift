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
    
//    init(from decoder: Decoder) throws {
//        let container: KeyedDecodingContainer<ResponseDTO<Result>.CodingKeys> = try decoder.container(keyedBy: ResponseDTO<Result>.CodingKeys.self)
//        self.requestCnt = (try? container.decode(Int.self, forKey: ResponseDTO<Result>.CodingKeys.requestCnt)) ?? 0
//        self.statusCode = (try? container.decode(String.self, forKey: ResponseDTO<Result>.CodingKeys.statusCode)) ?? "0"
//        self.data = try? container.decodeIfPresent(Result.self, forKey: ResponseDTO<Result>.CodingKeys.data)
//    }
}


//"request_cnt": 1,
//"status_code": "OK",
//"data": [
//    {
//        "b_no": "0000",
//        "b_stt": "",
//        "b_stt_cd": "",
//        "tax_type": "국세청에 등록되지 않은 사업자등록번호입니다.",
//        "tax_type_cd": "",
//        "end_dt": "",
//        "utcc_yn": "",
//        "tax_type_change_dt": "",
//        "invoice_apply_dt": "",
//        "rbf_tax_type": "",
//        "rbf_tax_type_cd": ""
//    }
//]
