//
//  CloudDatabaseInterface.swift
//  
//
//  Created by MaTooSens on 25/10/2023.
//

import Foundation
import FirebaseFirestore

public protocol DAOInterface: DataConvertible, DAOReference {
    static var collection: String { get }
    
    associatedtype Model: Storable
    init(from: Model)
}

public protocol Storable: DataConvertible, StorableReference  {
    associatedtype RemoteDAO: DAOInterface
    init(from: RemoteDAO)
}

public protocol DataConvertible: Identifiable, Codable, Equatable, Hashable { }


public protocol DAOReference {
    associatedtype Container: DAOInterface
    var container: Container? { get set }
}

public extension DAOReference {
    var container: Container? {
            get { nil }
            set {}
        }
}

public protocol StorableReference {
    associatedtype Container: Storable
    var container: Container? { get set }
}

public extension StorableReference {
    var container: Container? {
            get { nil }
            set {}
        }
}




//public extension StorableReference {
//    func buildDocRef<T: Storable>(_ container: T) -> String {
//        var components: [String] = []
//        var currentContainer: (any Storable)? = container.container
//        
//        while currentContainer != nil {
//            if let container = currentContainer {
//                let path = getPath(container)
//                components.insert("\(path)", at: 0)
//                            
//                currentContainer = container.container
//            } else {
//                currentContainer = nil
//            }
//        }
//        
//        return components.joined(separator: "/")
//    }
//    
//    private func getPath<T: Storable>(_ container: T) -> String {
//        let documentID = String(describing: container.id)
//        let collection = T.RemoteDAO.collection
//        
//        return "\(collection)/\(documentID)"
//    }
//}

public protocol CloudDatabaseManagerInterface {
    func save<Object: Storable>(_ object: Object) throws
    func getAll<ParentObject: Storable, Object: Storable>(parentObject: ParentObject?, objectsOfType type: Object.Type) async throws -> [Object]
}

public enum DatabaseError: Error {
    case unableToFindDocRef
    
    case unableToCreate
    case unableToRead
}
