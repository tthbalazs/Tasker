//
//  CloudDatabaseInterface.swift
//  
//
//  Created by MaTooSens on 25/10/2023.
//

import Foundation
import FirebaseFirestore

public protocol DataConvertible: Identifiable, Codable, Equatable, Hashable { }

public protocol DAOInterface: DataConvertible, DocRef {
    associatedtype Model: Storable
    init(from: Model)
    
    static var collection: String { get }
}

public protocol Storable: DataConvertible, DocRef {
    associatedtype RemoteDAO: DAOInterface
    init(from: RemoteDAO)
}

public protocol DocRef {
    var parentId: String? { get set }
}

public extension DocRef {
    var parentId: String? {
        get { nil }
        set { }
    }
}

public protocol CloudDatabaseManagerInterface {
    func save<ParentObject: Storable, Object: Storable>(parentObject: ParentObject?, object: Object) throws
    func getAll<ParentObject: Storable, Object: Storable>(parentObject: ParentObject?, objectsOfType type: Object.Type) async throws -> [Object]
}

public enum DatabaseError: Error {
    case unableToCreate
    case unableToRead
}
