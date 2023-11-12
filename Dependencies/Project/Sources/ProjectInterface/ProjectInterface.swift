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
    func save<Object: RemoteStorable>(_ object: Object) throws
    func getAll<ParentObject: RemoteStorable, Object: RemoteStorable>(parentObject: ParentObject?, objectsOfType type: Object.Type) async throws -> [Object]
}

public extension ProjectManagerInterface {
    func getAll<Object: RemoteStorable>(objectsOfType type: Object.Type) async throws -> [Object] {
        try await getAll(parentObject: Object?.none, objectsOfType: type)
    }
}

public struct Project: RemoteStorable, Hashable {
    public typealias Container = Project

    public let id: String
    public let name: String
    
    public init(
        id: String = UUID().uuidString,
        name: String
    ) {
        self.id = id
        self.name = name
    }
    
    public init(from dao: ProjectRemoteDAO) {
        self.id = dao.id
        self.name = dao.name
    }
}

public struct Todo<Container: RemoteStorable>: RemoteStorable, Hashable {
    public var container: Container?
    public let id: String
    public let name: String
    
    public init(
        container: Container?,
        id: String = UUID().uuidString,
        name: String
    ) {
        self.container = container
        self.id = id
        self.name = name
    }
    
    public init(from dao: TodoRemoteDAO<Container.RemoteDAO>) {
        self.id = dao.id
        self.name = dao.name
        self.container = dao.container.map {
            let some = Container(from: $0)
            print("Container in Domain: ", some)
            return some
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
    }
}
