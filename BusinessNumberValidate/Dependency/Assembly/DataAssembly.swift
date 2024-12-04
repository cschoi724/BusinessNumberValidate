//
//  DataAssembly.swift
//  BusinessNumberValidate
//
//  Created by SCC-PC on 2024/12/04.
//

import Swinject

public struct DataAssembly: Assembly {
    public func assemble(container: Swinject.Container) {
        container.register(NetworkService.self) { _ in
            return APIClient(session: .shared)
        }
        
        container.register(BusinessStatusRepository.self) { resolver in
            return BusinessStatusRepositoryImpl(
                apiClient: resolver.resolve(NetworkService.self)!
            )
        }
    }
}
