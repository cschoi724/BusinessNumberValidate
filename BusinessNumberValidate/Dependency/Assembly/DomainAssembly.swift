//
//  DomainAssembly.swift
//  BusinessNumberValidate
//
//  Created by SCC-PC on 2024/12/04.
//

import Swinject

public struct DomainAssembly: Assembly {
    public func assemble(container: Swinject.Container) {
        
        container.register(FetchBusinessStatusUseCase.self) { resolver in
            return FetchBusinessStatusUseCaseImpl(
                repository: resolver.resolve(BusinessStatusRepository.self)!
            )
        }
    }
}
