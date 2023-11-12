//
//  Repository.swift
//
//
//  Created by MaTooSens on 16/10/2023.
//

import CloudDatabase
import Database
import DependencyInjection
import RepositoryInterface

public struct Dependencies {
    public static func inject() {
        Assemblies
            .inject(
                type: RepositoryManagerInterface.self,
                object: RepositoryManager()
            )
        
        CloudDatabase.Dependencies.inject()
        Database.Dependencies.inject()
    }
}
