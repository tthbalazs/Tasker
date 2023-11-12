//
//  Project.swift
//
//
//  Created by MaTooSens on 27/10/2023.
//

import DependencyInjection
import ProjectInterface
import Repository

public struct Dependencies {
    public static func inject() {
        Assemblies
            .inject(
                type: ProjectManagerInterface.self,
                object: ProjectManager()
            )
        
        Repository.Dependencies.inject()
    }
}
