//
//  DatabaseInterface.swift
//  
//
//  Created by MaTooSens on 25/10/2023.
//

import Foundation
import RealmSwift

public protocol DAOInterface: Object, Identifiable, DAOReference {
    associatedtype Model: Storable
    init(from: Model)
}

public protocol Storable: Identifiable, Codable, Equatable, StorableReference {
    associatedtype LocalDAO: DAOInterface
    init(from: LocalDAO)
}

public protocol DAOReference {
    associatedtype Contents: DAOInterface
    var contents: List<Contents> { get set }
}

public extension DAOReference {
    var contents: List<Contents> {
        get { List<Contents>() }
        set { }
    }
}

public protocol StorableReference {
    associatedtype Contents: Storable
    var contents: [Contents]? { get set }
}

public extension StorableReference {
    var contents: [Contents]? {
        get { nil }
        set { }
    }
}

public protocol DatabaseManagerInterface {
//    func save<Object: Storable>(object: Object) async throws
    func save<ParentObject: Storable, Object: Storable>(parentObject: ParentObject?, object: Object) async throws
//    func getAll<Object: Storable>() async throws -> [Object]
    func getAll<ParentObject: Storable, Object: Storable>(parentObject: ParentObject?) async throws -> [Object] 
}

public enum DatabaseError: Error {
    case unableToOpenRealm
    case unableToSave
    case unableToFind
    case unableToUpdate
    case unableToDelete
}
