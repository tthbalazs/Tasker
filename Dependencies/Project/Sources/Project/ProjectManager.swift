//
//  ProjectManager.swift
//
//
//  Created by MaTooSens on 27/10/2023.
//

import ProjectInterface
import RepositoryInterface

public final class ProjectManager: ProjectManagerInterface {
    private var repositoryManager: RepositoryManagerInterface

    public init(repositoryManager: RepositoryManagerInterface) {
        self.repositoryManager = repositoryManager
    }
    
    public func save<ParentObject: CombinedStorable, Object: CombinedStorable>(parentObject: ParentObject? = nil, object: Object) async throws {
        try await repositoryManager.save(parentObject: parentObject, object: object)
    }
    
    public func getAll<ParentObject: CombinedStorable, Object: CombinedStorable>(parentObject: ParentObject? = nil, objectsOfType type: Object.Type) async throws -> [Object] {
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
