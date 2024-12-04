//
//  BusinessStatusView.swift
//  BusinessNumberValidate
//
//  Created by SCC-PC on 2024/12/04.
//

import SwiftUI
import ComposableArchitecture

struct BusinessStatusView: View {
    let store: StoreOf<BusinessStatusReducer>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(spacing: 16) {
                TextField("사업자 번호를 입력하세요", text: viewStore.binding(
                    get: \.businessNumber,
                    send: BusinessStatusReducer.Action.updateBusinessNumber
                ))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

                if viewStore.isLoading {
                    ProgressView("Loading...")
                }

                Button("사업자 조회") {
                    viewStore.send(.fetchBusinessStatus)
                }
                .disabled(viewStore.businessNumber.isEmpty || viewStore.isLoading)

                if let businessStatus = viewStore.businessStatus {
                    if viewStore.errorMessage != nil {
                          Text(viewStore.errorMessage!)
                              .foregroundColor(.red)
                              .padding()
                      } else {
                          VStack(alignment: .leading, spacing: 8) {
                              Text("사업자 상태: \(businessStatus.bStt.isEmpty ? "알 수 없음" : businessStatus.bStt)")
                              Text("과세 유형: \(businessStatus.taxType)")
                          }
                          .padding()
                      }
                }
                if let errorMessage = viewStore.errorMessage, viewStore.businessStatus == nil {
                    Text("오류: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .padding()
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                viewStore.send(.cancelFetch)
            }
            .onDisappear {
                viewStore.send(.cancelFetch)
            }
        }
    }
}
