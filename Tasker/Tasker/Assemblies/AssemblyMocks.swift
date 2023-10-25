//
//  AssemblyMocks.swift
//  Tasker
//
//  Created by MaTooSens on 25/10/2023.
//

import AuthenticationMocks
import DependencyInjection
import RepositoryMocks

extension Assemblies {
    static func setupDependencies() {
        AuthenticationMocks.Dependencies.inject()
    }
}

