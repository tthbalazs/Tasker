//
//  ProjectInterface.swift
//
//
//  Created by MaTooSens on 27/10/2023.
//

import CloudDatabaseInterface
import DatabaseInterface
import Foundation

public typealias CombinedStorable = DatabaseInterface.Storable & CloudDatabaseInterface.Storable
public typealias RemoteStorable = CloudDatabaseInterface.Storable
public typealias LocalStorable = DatabaseInterface.Storable

public typealias LocalDAO = DatabaseInterface.DAOInterface
public typealias RemoteDAO = CloudDatabaseInterface.DAOInterface


public protocol ProjectManagerInterface {
    func save<ParentObject: CombinedStorable, Object: CombinedStorable>(parentObject: ParentObject?, object: Object) async throws
    func getAll<ParentObject: CombinedStorable, Object: CombinedStorable>(parentObject: ParentObject?, objectsOfType type: Object.Type) async throws -> [Object]
}

public extension ProjectManagerInterface {
    func save<Object: CombinedStorable>(_ object: Object) async throws {
        try await save(parentObject: Object?.none, object: object)
    }
    
    func getAll<Object: CombinedStorable>(objectsOfType type: Object.Type) async throws -> [Object] {
        try await getAll(parentObject: Object?.none, objectsOfType: type)
    }
}

public struct Project: CombinedStorable {
    public let id: String
    public let name: String
    public var contents: [Todo]?
    
    public init(
        id: String = UUID().uuidString,
        name: String,
        contents: [Todo]? = []
    ) {
        self.id = id
        self.name = name
        self.contents = contents
    }
    
    public init(from dao: ProjectRemoteDAO) {
        self.id = dao.id
        self.name = dao.name
    }
    
    public init(from dao: ProjectLocalDAO) {
        self.id = dao.id
        self.name = dao.name
        self.contents = dao.contents.compactMap { Todo(from: $0) }
        
        let projects =  dao.contents.compactMap { Todo(from: $0) }
        print("\nProject - Project: ", contents)
    }
}

public struct Todo: CombinedStorable {
    public var parentId: String?
    public var contents: [Todo]?
    
    public let id: String
    public let name: String
    
    public init(
        parentId: String,
        id: String = UUID().uuidString,
        name: String
    ) {
        self.id = id
        self.name = name
        self.parentId = parentId
    }
    
    public init(from dao: TodoRemoteDAO) {
        self.parentId = dao.parentId
        self.id = dao.id
        self.name = dao.name
    }
    
    public init(from dao: TodoLocalDAO) {
        self.id = dao.id
        self.name = dao.name
        self.parentId = dao.parentId
        self.contents = []
        
        self.contents?.append(
            contentsOf: dao.contents.compactMap {
                Todo(from: $0)
            }
        )
    }
}
