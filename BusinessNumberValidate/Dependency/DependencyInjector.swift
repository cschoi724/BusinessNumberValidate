//
//  DependencyInjector.swift
//  BusinessNumberValidate
//
//  Created by SCC-PC on 2024/12/04.
//

import Swinject

public protocol DependencyAssemblable {
    func assemble(_ assemblies: [Assembly])
}

public protocol DependencyResolvable {
    func resolve<T>(_ serviceType: T.Type) -> T
}

public typealias DependencyInjector = DependencyAssemblable & DependencyResolvable

public final class DependencyInjectorImpl: DependencyInjector {
    private let assembler: Assembler
    private let container: Container
    
    public init(container: Container = Container()) {
        self.container = container
        self.assembler = Assembler(container: container)
    }
    
    public func assemble(_ assemblies: [Assembly]) {
        assembler.apply(assemblies: assemblies)
    }
    
    public func resolve<T>(_ serviceType: T.Type) -> T {
        assembler.resolver.resolve(serviceType)!
    }
}
