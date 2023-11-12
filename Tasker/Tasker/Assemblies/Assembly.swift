//
//  Assembly.swift
//  Tasker
//
//  Created by MaTooSens on 25/10/2023.
//

import Authentication
import DependencyInjection
import Project

extension Assemblies {
    static func setupDependencies() {
        Authentication.Dependencies.inject()
        Project.Dependencies.inject()
    }
}

