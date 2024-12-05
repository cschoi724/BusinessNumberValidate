//
//  MainContentView.swift
//  BusinessNumberValidate
//
//  Created by 일하는석찬 on 12/5/24.
//
import SwiftUI
import ComposableArchitecture

struct MainContentView: View {
    let viewStore: ViewStore<BusinessStatusReducer.State, BusinessStatusReducer.Action>
    let geometry: GeometryProxy

    var body: some View {
        VStack(spacing: 16) {
            TextFieldView(viewStore: viewStore)
                .frame(
                    width: geometry.size.width > geometry.size.height
                        ? geometry.size.width * 0.33 // 가로 모드: 화면 가로 크기의 1/3
                        : geometry.size.width * 0.9  // 세로 모드: 화면 가로 크기의 90%
                )
                .padding(.horizontal, geometry.size.width > geometry.size.height ? 0 : 16) // 세로 모드에서만 양옆 패딩
                .multilineTextAlignment(.center)
            FetchButton(viewStore: viewStore, geometry: geometry)
                .frame(
                    width: geometry.size.width > geometry.size.height
                        ? geometry.size.width * 0.33 // 가로 모드: 화면 가로 크기의 1/3
                        : geometry.size.width * 0.5  // 세로 모드: 화면 가로 크기의 50%
                )
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .center
        )
        .background(Color.red.opacity(0.1))
    }
}
