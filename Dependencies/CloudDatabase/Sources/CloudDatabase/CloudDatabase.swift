//
//  CloudDatabase.swift
//
//
//  Created by MaTooSens on 25/10/2023.
//

import CloudDatabaseInterface
import DependencyInjection

public struct Dependencies {
    public static func inject() {
        Assemblies
            .inject(
                type: CloudDatabaseManagerInterface.self,
                object: CloudDatabaseManager()
            )
    }
}
