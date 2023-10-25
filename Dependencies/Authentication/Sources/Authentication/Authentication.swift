//
//  Authentication.swift
//
//
//  Created by MaTooSens on 22/10/2023.
//

import AuthenticationInterface
import DependencyInjection

public struct Dependencies {
    public static func inject() {
        Assemblies.inject(
            type: AuthenticationManagerInterface.self,
            object: AuthenticationManager()
        )
    }
}
