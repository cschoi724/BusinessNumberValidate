//
//  StatusOrErrorView.swift
//  BusinessNumberValidate
//
//  Created by 일하는석찬 on 12/5/24.
//

import SwiftUI

struct StatusOrErrorView: View {
    let businessStatus: BusinessStatus?
    let errorMessage: String?

    var body: some View {
        if let businessStatus = businessStatus {
            VStack(alignment: .leading, spacing: 8) {
                Text("사업자 상태: \(businessStatus.bStt.isEmpty ? "알 수 없음" : businessStatus.bStt)")
                Text("과세 유형: \(businessStatus.taxType)")
            }
        } else if let errorMessage = errorMessage {
            Text("오류: \(errorMessage)")
                .foregroundColor(.red)
                .padding()
        }
    }
}
