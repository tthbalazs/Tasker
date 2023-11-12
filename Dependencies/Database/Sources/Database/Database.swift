//
//  Database.swift
//
//
//  Created by MaTooSens on 16/10/2023.
//

import DatabaseInterface
import DependencyInjection

public struct Dependencies {
    public static func inject() {
        Assemblies
            .inject(
                type: DatabaseManagerInterface.self,
                object: DatabaseManager()
            )
    }
}
