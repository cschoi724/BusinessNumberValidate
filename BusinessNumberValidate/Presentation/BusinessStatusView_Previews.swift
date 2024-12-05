//
//  BusinessStatusView_Previews.swift
//  BusinessNumberValidate
//
//  Created by 일하는석찬 on 12/5/24.
//

import SwiftUI
import ComposableArchitecture
import Swinject

struct BusinessStatusView_Previews: PreviewProvider {
    static var previews: some View {
        // 의존성 컨테이너 생성
        let injector = DependencyInjectorImpl(container: Container())
        injector.assemble([
            DataAssembly(),
            DomainAssembly(),
            PresentationAssembly()
        ])

        // Reducer 주입
        let reducer = injector.resolve(BusinessStatusReducer.self)

        return Group {
            BusinessStatusView(
                store: StoreOf<BusinessStatusReducer>(
                    initialState: BusinessStatusReducer.State(),
                    reducer: { reducer }
                )
            )
            .previewDevice("iPhone SE (3rd generation)")
            .previewDisplayName("Small Device")

            BusinessStatusView(
                store: StoreOf<BusinessStatusReducer>(
                    initialState: BusinessStatusReducer.State(),
                    reducer: { reducer }
                )
            )
            .previewDevice("iPhone 14 Pro Max")
            .previewDisplayName("Large Device")

            BusinessStatusView(
                store: StoreOf<BusinessStatusReducer>(
                    initialState: BusinessStatusReducer.State(),
                    reducer: { reducer }
                )
            )
            .previewDevice("iPad Pro (12.9-inch)")
            .previewDisplayName("iPad")
        }
    }
}
