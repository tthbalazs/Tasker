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
public typealias StorableReference = CloudDatabaseInterface.StorableReference


public protocol RepositoryManagerInterface {
    func save<Object: RemoteStorable>(_ object: Object) throws
    func getAll<ParentObject: RemoteStorable, Object: RemoteStorable>(parentObject: ParentObject?, objectsOfType type: Object.Type) async throws -> [Object]
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
