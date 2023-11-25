//
//  DatabaseInterface.swift
//
//
//  Created by MaTooSens on 25/10/2023.
//

import Foundation
import RealmSwift

public protocol LocalDAOInterface: Object, DAOReference {
    associatedtype LocalModel: LocalStorable
    init(from: LocalModel)
}

public protocol LocalStorable: Identifiable, Codable, Equatable, StorableReference {
    associatedtype LocalDAO: LocalDAOInterface
    init(from: LocalDAO)
}

// MARK: Reference -
public protocol DAOReference {
    associatedtype Container: LocalDAOInterface // ParentObject
    associatedtype Contents: LocalDAOInterface  // ChildObject
    
    var container: LinkingObjects<Container> { get set }
    var contents: List<Contents> { get set }
}

public extension DAOReference {
    var container: LinkingObjects<Container> {
        get { LinkingObjects(fromType: Container.self, property: "") }
        set { }
    }
    
    var contents: List<Contents> {
        get { List<Contents>() }
        set { }
    }
}

public protocol StorableReference {
    associatedtype Contents: LocalStorable
    var contents: [Contents]? { get set }
}

public extension StorableReference {
    var contents: [Contents]? {
        get { nil }
        set { }
    }
}

// MARK: ManagerInterface -
public protocol DatabaseManagerInterface {
    func save<ParentObject: LocalStorable, Object: LocalStorable>(parentObject: ParentObject?, object: Object) async throws
    func getAll<ParentObject: LocalStorable, Object: LocalStorable>(parentObject: ParentObject?) async throws -> [Object]
}

// MARK: Errors -
public enum DatabaseError: Error {
    case unableToOpenRealm
    case unableToSave
    case unableToFind
    case unableToUpdate
    case unableToDelete
}
