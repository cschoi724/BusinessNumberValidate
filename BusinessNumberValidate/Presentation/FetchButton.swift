//
//  FetchButton.swift
//  BusinessNumberValidate
//
//  Created by 일하는석찬 on 12/5/24.
//

import SwiftUI
import ComposableArchitecture

struct FetchButton: View {
    let viewStore: ViewStore<BusinessStatusReducer.State, BusinessStatusReducer.Action>
    let geometry: GeometryProxy

    var body: some View {
        Button("사업자 조회") {
            viewStore.send(.fetchBusinessStatus)
        }
        .disabled(viewStore.businessNumber.isEmpty || viewStore.isLoading)
        .padding(.horizontal, geometry.size.width * 0.05)
    }
}
