//
//  TextFieldView.swift
//  BusinessNumberValidate
//
//  Created by 일하는석찬 on 12/5/24.
//

import SwiftUI
import ComposableArchitecture

struct TextFieldView: View {
    let viewStore: ViewStore<BusinessStatusReducer.State, BusinessStatusReducer.Action>

    var body: some View {
        TextField("사업자 번호를 입력하세요", text: viewStore.binding(
            get: \.businessNumber,
            send: BusinessStatusReducer.Action.updateBusinessNumber
        ))
        .textFieldStyle(RoundedBorderTextFieldStyle())
    }
}
