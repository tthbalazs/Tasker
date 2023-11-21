//
//  RepositoryInterface.swift
//  
//
//  Created by MaTooSens on 16/10/2023.
//

import CloudDatabaseInterface
import DatabaseInterface

// Storable
public typealias CombinedStorable = DatabaseInterface.Storable & CloudDatabaseInterface.Storable
public typealias LocalStorable = DatabaseInterface.Storable
public typealias RemoteStorable = CloudDatabaseInterface.Storable


public protocol RepositoryManagerInterface {
    func save<ParentObject: CombinedStorable, Object: CombinedStorable>(parentObject: ParentObject?, object: Object) async throws
    func getAll<ParentObject: CombinedStorable, Object: CombinedStorable>(parentObject: ParentObject?, objectsOfType type: Object.Type) async throws -> [Object]
}
