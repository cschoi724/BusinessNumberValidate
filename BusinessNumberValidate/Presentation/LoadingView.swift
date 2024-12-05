//
//  LoadingView.swift
//  BusinessNumberValidate
//
//  Created by SCC-PC on 2024/12/04.
//

import SwiftUI

struct LoadingView: View {
    @Binding var isLoading: Bool
    @State private var internalLoading: Bool = false // 최소 로딩 지속 시간 제어
    
    var body: some View {
        if isLoading || internalLoading {
            ZStack {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.5)
                    Text("조회 중...")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.top, 8)
                }
            }
            .onAppear {
                // 최소 로딩 지속 시간 설정
                internalLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    internalLoading = false
                }
            }
        }
    }
}
