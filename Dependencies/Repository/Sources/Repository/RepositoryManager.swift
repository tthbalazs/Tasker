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
    
    func save<Object: RemoteStorable>(_ object: Object) throws {
        try cloudDatabaseManager.save(object)
    }
    
    func getAll<ParentObject: RemoteStorable, Object: RemoteStorable>(parentObject: ParentObject? = nil, objectsOfType type: Object.Type) async throws -> [Object] {
        try await cloudDatabaseManager.getAll(parentObject: parentObject, objectsOfType: type)
    }
}

/*
 func saveProject<Object: RemoteStorable>(object: Object) throws {
     try cloudDatabaseManager.saveProject(object: object)
 }

 func getProjects<Object: RemoteStorable>(objectsOfType type: Object.Type) async throws -> [Object] {
     try await cloudDatabaseManager.getProjects(object: type)
 }
 
 func saveTask<Object: RemoteStorable>(object: Object) throws {
     try cloudDatabaseManager.saveTask(object: object)
 }
 
 func getAll<ParentObject: RemoteStorable, Object: RemoteStorable>(
     parentObject: ParentObject? = nil,
     objectsOfType type: Object.Type
 ) async throws -> [Object] {
//        try await cloudDatabaseManager.getAll(parentObject: parentObject, objectsOfType: type)
//        try await databaseManager.getAll()
     
     try await cloudDatabaseManager.getAll(parentObject: parentObject, objectsOfType: type)
 }
 
 
 func save<ParentObject: RemoteStorable, Object: RemoteStorable>(
     parentObject: ParentObject? = nil,
     object: Object
 ) async throws {
//        try await databaseManager.save(parentObject: parentObject, object: object)
     
     try cloudDatabaseManager.saveProject(object: object)
 }
 */
