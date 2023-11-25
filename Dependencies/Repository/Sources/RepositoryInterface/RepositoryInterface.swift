//
//  RepositoryInterface.swift
//
//
//  Created by MaTooSens on 16/10/2023.
//

import CloudDatabaseInterface
import DatabaseInterface

// Storable
public typealias CombinedStorable = LocalStorable & RemoteStorable

public protocol RepositoryManagerInterface {
    func save<ParentObject: CombinedStorable, Object: CombinedStorable>(parentObject: ParentObject?, object: Object) async throws
    func getAll<ParentObject: CombinedStorable, Object: CombinedStorable>(parentObject: ParentObject?, objectsOfType type: Object.Type) async throws -> [Object]
}

/*
 public protocol RepositoryManagerInterface {
     func saveProject<Object: RemoteStorable>(object: Object) throws
     func getProjects<Object: RemoteStorable>(objectsOfType type: Object.Type) async throws -> [Object]
     
     func saveTask<Object: RemoteStorable>(object: Object) throws
     
     
 //    func save<ParentObject: RemoteStorable, Object: RemoteStorable>(parentObject: ParentObject?, object: Object) async throws
 //    func saveTask<Object: RemoteStorable>(object: Object) throws
     func getAll<ParentObject: RemoteStorable, Object: RemoteStorable>(parentObject: ParentObject?, objectsOfType type: Object.Type) async throws -> [Object]
 }
 */
