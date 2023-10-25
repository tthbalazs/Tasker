//
//  Assembly.swift
//  Tasker
//
//  Created by MaTooSens on 25/10/2023.
//

import Authentication
import DependencyInjection

extension Assemblies {
    static func setupDependencies() {
        Authentication.Dependencies.inject()
    }
}

