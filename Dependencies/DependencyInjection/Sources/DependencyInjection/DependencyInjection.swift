//
//  DependencyInjection.swift
//
//
//  Created by MaTooSens on 16/10/2023.
//

import Swinject

public struct Assemblies {
    public static let sharedContainer = Container()
    
    public static func resolve<T>(
        _ type: T.Type
    ) -> T! {
        sharedContainer.resolve(type)
    }
    
    public static func inject<T>(
        type: T.Type,
        object: @escaping @autoclosure () -> T,
        inObjectScope objectScope: ObjectScope = .weak
    ) {
        sharedContainer.register(type) { _ in
            object()
        }
        .inObjectScope(objectScope)
    }
}

@propertyWrapper
public final class Inject<T> {
    public var wrappedValue: T { value }
    private lazy var value: T = Assemblies.resolve(T.self)
    
    public init() { }
}
