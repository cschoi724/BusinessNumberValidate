//
//  ErrorToastView.swift
//  BusinessNumberValidate
//
//  Created by 일하는석찬 on 12/5/24.
//

import SwiftUI

struct ErrorToastView: View {
    let message: String

    var body: some View {
        VStack {
            Spacer()
            Text(message)
                .font(.headline)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding()
                .background(Color.red.opacity(0.9))
                .cornerRadius(12)
                .shadow(radius: 4)
                .padding(.horizontal, 16)
            Spacer(minLength: 50)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .edgesIgnoringSafeArea(.all)
    }
}
