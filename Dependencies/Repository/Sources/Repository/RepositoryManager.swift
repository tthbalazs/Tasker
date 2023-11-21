//
//  RepositoryManager.swift
//  
//
//  Created by MaTooSens on 16/10/2023.
//

import CloudDatabaseInterface
import DatabaseInterface
import DependencyInjection
import Foundation
import RepositoryInterface

final class RepositoryManager: RepositoryManagerInterface {
    @Inject private var cloudDatabaseManager: CloudDatabaseManagerInterface
    @Inject private var databaseManager: DatabaseManagerInterface
    
    func save<ParentObject: CombinedStorable, Object: CombinedStorable>(parentObject: ParentObject? = nil, object: Object) async throws {
        try cloudDatabaseManager.save(parentObject: parentObject, object: object)
        try await databaseManager.save(parentObject: parentObject, object: object)
    }
    
    func getAll<ParentObject: CombinedStorable, Object: CombinedStorable>(parentObject: ParentObject? = nil, objectsOfType type: Object.Type) async throws -> [Object] {
        let _ = try await cloudDatabaseManager.getAll(parentObject: parentObject, objectsOfType: type)
        return try await databaseManager.getAll(parentObject: parentObject)
    }
}
