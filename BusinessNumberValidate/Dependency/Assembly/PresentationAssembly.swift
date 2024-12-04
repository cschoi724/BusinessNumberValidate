//
//  PresentationAssembly.swift
//  BusinessNumberValidate
//
//  Created by SCC-PC on 2024/12/04.
//

import Swinject
import ComposableArchitecture
import Foundation

public struct PresentationAssembly: Assembly {
    public func assemble(container: Swinject.Container) {
        container.register(BusinessStatusReducer.self) { resolver in
            return BusinessStatusReducer(
                environment: .init(
                    mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
                    fetchBusinessStatusUseCase: resolver.resolve(FetchBusinessStatusUseCase.self)!
                )
            )
        }
    }
}
