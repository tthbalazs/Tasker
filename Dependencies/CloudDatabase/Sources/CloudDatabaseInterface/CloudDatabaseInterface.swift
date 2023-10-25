//
//  CloudDatabaseInterface.swift
//  
//
//  Created by MaTooSens on 25/10/2023.
//

import Foundation
import FirebaseFirestore

public protocol DAOInterface: Identifiable, Codable, Equatable, Reference {
    associatedtype Model: Storable
    init(from: Model)
}

public protocol Storable: Identifiable, Codable, Equatable, Hashable {
    associatedtype RemoteDAO: DAOInterface
    init(from: RemoteDAO)
}

public protocol Reference {
    static var collection: String { get }
    var docRef: String? { get set }
}

public protocol CloudDatabaseManagerInterface {
    func save<ParentObject: Storable, Object: Storable>(parentObject: ParentObject?, object: Object) throws
    func get<ParentObject: Storable, Object: Storable>(parentObject: ParentObject?, object: Object) async throws -> Object
    func getAll<ParentObject: Storable, Object: Storable>(parentObject: ParentObject?, objectsOfType type: Object.Type) async throws -> [Object]
}

public enum DatabaseError: Error {
    case unableToFindDocRef
    
    case unableToCreate
    case unableToRead
}
