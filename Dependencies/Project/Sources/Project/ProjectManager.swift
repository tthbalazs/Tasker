//
//  ProjectManager.swift
//
//
//  Created by MaTooSens on 27/10/2023.
//

import DependencyInjection
import ProjectInterface
import RepositoryInterface

final class ProjectManager: ProjectManagerInterface {
    @Inject private var repositoryManager: RepositoryManagerInterface
    
    func save<Object: RemoteStorable>(_ object: Object) throws {
        try repositoryManager.save(object)
    }
    
    func getAll<ParentObject: RemoteStorable, Object: RemoteStorable>(parentObject: ParentObject? = nil, objectsOfType type: Object.Type) async throws -> [Object] {
        try await repositoryManager.getAll(parentObject: parentObject, objectsOfType: type)
    }
}


/*
 func save<ParentObject: RemoteStorable, Object: RemoteStorable>(
     parentObject: ParentObject? = nil,
     object: Object
 ) async throws {
     try await repositoryManager.save(parentObject: parentObject, object: object)
 }
 
 func saveTask<Object: RemoteStorable>(object: Object) throws {
     try repositoryManager.saveTask(object: object)
 }
 
 
 func getAll<ParentObject: RemoteStorable, Object: RemoteStorable>(
     parentObject: ParentObject? = nil,
     objectsOfType type: Object.Type
 ) async throws -> [Object] {
     try await repositoryManager.getAll(parentObject: parentObject, objectsOfType: type)
 }
 */
