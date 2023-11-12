//
//  DatabaseInterface.swift
//  
//
//  Created by MaTooSens on 25/10/2023.
//

import Foundation
import RealmSwift

public protocol DAOInterface: Object {
    associatedtype Model: Storable
    
    init(from: Model)
}

public protocol Storable: Identifiable, Codable, Equatable {
    associatedtype LocalDAO: DAOInterface
    init(from: LocalDAO)
}

public protocol DatabaseManagerInterface {
//    func createMain<Object: Storable>(object: Object) async throws
//    func getAll<Object: Storable>() async throws -> [Object]
//    
//    func save<ParentObject: Storable, Object: Storable>(
//        parentObject: ParentObject?,
//        object: Object
//    ) async throws
}

public enum DatabaseError: Error {
    case unableToOpenRealm
    case unableToSave
    case unableToFind
    case unableToUpdate
    case unableToDelete
}
