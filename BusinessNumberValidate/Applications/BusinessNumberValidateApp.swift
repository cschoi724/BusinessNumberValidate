//
//  BusinessNumberValidateApp.swift
//  BusinessNumberValidate
//
//  Created by SCC-PC on 2024/12/04.
//

import SwiftUI
import Swinject
import ComposableArchitecture

@main
struct BusinessStatusApp: App {
    let injector: DependencyInjector
    init() {
        injector = DependencyInjectorImpl(container: Container())
        injector.assemble([
            DataAssembly(),
            DomainAssembly(),
            PresentationAssembly()
        ])
    }
    
    var body: some Scene {
        WindowGroup {
            let reducer = injector.resolve(BusinessStatusReducer.self)
            BusinessStatusView(
                store: StoreOf<BusinessStatusReducer>(
                    initialState: BusinessStatusReducer.State(),
                    reducer: {
                        reducer
                    }
                )
            )
        }
    }
}
