//
//  BusinessStatusDTO.swift
//  BusinessNumberValidate
//
//  Created by SCC-PC on 2024/12/04.
//

import Foundation

struct BusinessStatusDTO: Codable {
    let bNo: String            // 사업자 번호
    let bStt: String           // 사업 상태
    let bSttCd: String         // 사업 상태 코드
    let taxType: String        // 세금 유형 (메시지)
    let taxTypeCd: String      // 세금 유형 코드
    let endDt: String          // 사업 종료일
    let utccYn: String         // 유효성 여부
    let taxTypeChangeDt: String  // 세금 유형 변경일
    let invoiceApplyDt: String   // 계산서 적용일
    let rbfTaxType: String       // 환급 세금 유형
    let rbfTaxTypeCd: String     // 환급 세금 유형 코드

    enum CodingKeys: String, CodingKey {
        case bNo = "b_no"
        case bStt = "b_stt"
        case bSttCd = "b_stt_cd"
        case taxType = "tax_type"
        case taxTypeCd = "tax_type_cd"
        case endDt = "end_dt"
        case utccYn = "utcc_yn"
        case taxTypeChangeDt = "tax_type_change_dt"
        case invoiceApplyDt = "invoice_apply_dt"
        case rbfTaxType = "rbf_tax_type"
        case rbfTaxTypeCd = "rbf_tax_type_cd"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.bNo = (try? container.decode(String.self, forKey: .bNo)) ?? ""
        self.bStt = (try? container.decode(String.self, forKey: .bStt)) ?? ""
        self.bSttCd = (try? container.decode(String.self, forKey: .bSttCd)) ?? ""
        self.taxType = (try? container.decode(String.self, forKey: .taxType)) ?? ""
        self.taxTypeCd = (try? container.decode(String.self, forKey: .taxTypeCd)) ?? ""
        self.endDt = (try? container.decode(String.self, forKey: .endDt)) ?? ""
        self.utccYn = (try? container.decode(String.self, forKey: .utccYn)) ?? ""
        self.taxTypeChangeDt = (try? container.decode(String.self, forKey: .taxTypeChangeDt)) ?? ""
        self.invoiceApplyDt = (try? container.decode(String.self, forKey: .invoiceApplyDt)) ?? ""
        self.rbfTaxType = (try? container.decode(String.self, forKey: .rbfTaxType)) ?? ""
        self.rbfTaxTypeCd = (try? container.decode(String.self, forKey: .rbfTaxTypeCd)) ?? ""
    }
}

extension BusinessStatusDTO {
    var domain: BusinessStatus {
        return BusinessStatus(
            bNo: bNo,
            bStt: bStt,
            bSttCd: bSttCd,
            taxType: taxType,
            taxTypeCd: taxTypeCd,
            endDt: endDt,
            utccYn: utccYn,
            taxTypeChangeDt: taxTypeChangeDt,
            invoiceApplyDt: invoiceApplyDt,
            rbfTaxType: rbfTaxType,
            rbfTaxTypeCd: rbfTaxTypeCd
        )
    }
}
