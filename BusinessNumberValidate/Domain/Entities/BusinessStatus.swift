//
//  BusinessStatus.swift
//  BusinessNumberValidate
//
//  Created by SCC-PC on 2024/12/04.
//

import Foundation

struct BusinessStatus: Equatable {
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
}
