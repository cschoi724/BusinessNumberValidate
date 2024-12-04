//
//  LoadingView.swift
//  BusinessNumberValidate
//
//  Created by SCC-PC on 2024/12/04.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
            Text("조회 중...")
                .font(.caption)
        }
        .padding()
    }
}
