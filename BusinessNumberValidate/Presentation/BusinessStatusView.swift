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
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            GeometryReader { geometry in
                ZStack {
                    VStack(spacing: 16) {
                        MainContentView(viewStore: viewStore, geometry: geometry)
             
                        StatusOrErrorView(
                            businessStatus: viewStore.businessStatus,
                            errorMessage: viewStore.errorMessage
                        )
                        .padding(.horizontal, geometry.size.width * 0.05)
                        Spacer(minLength: geometry.size.height * 0.05)
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .background(Color.yellow.opacity(0.1))
                    LoadingView(isLoading: viewStore.binding(
                        get: \.isLoading,
                        send: .cancelFetch
                    ))
                    if showError {
                        ErrorToastView(message: errorMessage)
                            .transition(.opacity)
                            .animation(.easeInOut, value: showError)
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                    viewStore.send(.cancelFetch)
                }
                .onDisappear {
                    viewStore.send(.cancelFetch)
                }
                .onChange(of: viewStore.errorMessage) { newValue in
                    if let newValue = newValue {
                        errorMessage = newValue
                        withAnimation {
                            showError = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                            withAnimation {
                                showError = false
                            }
                        }
                    }
                }
            }
        }
    }
}

