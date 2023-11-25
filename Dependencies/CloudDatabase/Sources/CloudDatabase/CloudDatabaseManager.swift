//
//  CloudDatabaseManager.swift
//
//
//  Created by MaTooSens on 25/10/2023.
//

import CloudDatabaseInterface
import FirebaseFirestore
import FirebaseFirestoreSwift

fileprivate struct DAOFactory {
    static func initializeObject<DAO: RemoteDAOInterface, Object: RemoteStorable>(from dao: DAO) -> Object {
        guard let dao = dao as? Object.RemoteDAO else {
            fatalError()
        }
        
        return Object(from: dao)
    }
    
    static func initializeDAO<Object: RemoteStorable, DAO: RemoteDAOInterface>(from object: Object) -> DAO {
        guard let object = object as? DAO.RemoteModel else {
            fatalError()
        }
        
        return DAO(from: object)
    }
}

final class CloudDatabaseManager: CloudDatabaseManagerInterface {
    private lazy var database = Firestore.firestore()
    
    private lazy var encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
    
    private lazy var decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
//
//    private func collectionReference<T: DAOInterface>(_ container: T) -> CollectionReference {
//        if container.container != nil {
//            let docRef = buildDocRef(container)
//
//            return database
//                .document(docRef)
//                .collection(T.collection)
//        } else {
//            return database
//                .collection(T.collection)
//        }
//    }
//
//    private func buildDocRef<T: DAOInterface>(_ container: T?) -> String {
//        var components: [String] = []
//        var currentContainer: (any DAOInterface)? = container?.container
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
//    private func getPath<T: DAOInterface>(_ container: T) -> String {
//        let documentID = String(describing: container.id)
//        let collection = T.collection
//
//        return "\(collection)/\(documentID)"
//    }
}


// MARK: CRUD
extension CloudDatabaseManager {
    func save<Object: RemoteStorable>(_ object: Object) throws {
        
    }
    
    func getAll<ParentObject: RemoteStorable, Object: RemoteStorable>(parentObject: ParentObject?, objectsOfType type: Object.Type) async throws -> [Object] {
        
        []
    }
}

//    func objectExist<Object: Storable>(object: Object) async throws -> Bool {
//        try await database.collection(Object.RemoteDAO.collection).document(String(describing: object.id)).getDocument().exists
//    }
//
//    func save<Object: Storable>(_ object: Object) throws {
//        let objectDAO: Object.RemoteDAO = DAOFactory.initializeDAO(from: object)
//        let documentID: String = String(describing: objectDAO.id)
//
//        do {
//            try collectionReference(objectDAO)
//                .document(documentID)
//                .setData(from: objectDAO, merge: false, encoder: encoder)
//        } catch {
//            throw DatabaseError.unableToCreate
//        }
//    }
//
//    func getProject<Object: Storable>(objectsOfType type: Object.Type) async throws -> [Object] {
//        do {
//            let snapshot = try await database.collection(Object.RemoteDAO.collection).getDocuments()
//
//            return try snapshot
//                .documents
//                .map { document in
//                    let objectDAO = try document.data(as: Object.RemoteDAO.self, decoder: decoder)
//
//                    return DAOFactory.initializeObject(from: objectDAO)
//                }
//        } catch {
//            throw DatabaseError.unableToRead
//        }
//    }
//
//    func getAll<ParentObject: Storable, Object: Storable>(parentObject: ParentObject? = nil, objectsOfType type: Object.Type) async throws -> [Object] {
//        var snapshot: QuerySnapshot
//
//        do {
//            if let parentObject = parentObject {
//                let parentObjectDAO: ParentObject.RemoteDAO = DAOFactory.initializeDAO(from: parentObject)
//                let documentID = String(describing: parentObjectDAO.id)
////                snapshot = try await collectionReference(parentObjectDAO).getDocuments()
//                print("Collection reference: ", collectionReference(parentObjectDAO).path)
//
//                snapshot = try await collectionReference(parentObjectDAO).document(documentID).collection(Object.RemoteDAO.collection).getDocuments()
//            } else {
//                snapshot = try await database.collection(Object.RemoteDAO.collection).getDocuments()
//            }
//
//            return try snapshot
//                .documents
//                .map { document in
//                    let objectDAO = try document.data(as: Object.RemoteDAO.self, decoder: decoder)
//
//                    return DAOFactory.initializeObject(from: objectDAO)
//                }
//        } catch {
//            throw DatabaseError.unableToRead
//        }
//    }
//
//
// - - - - - - - - - - - - - - - - - - - - - - - - - -
    
//    func getAll<ParentObject: Storable, Object: Storable>(parentObject: ParentObject? = nil, objectsOfType type: Object.Type) async throws -> [Object] {
//        do {
//            var snapshot: QuerySnapshot
//
//            if let parentObject = parentObject {
//                let parentObjectDAO: ParentObject.RemoteDAO = DAOFactory.initializeDAO(from: parentObject)
//                let documentID = String(describing: parentObject.id)
//
//                if let docRef = parentObjectDAO.docRef {
//                    snapshot = try await database
//                        .document(docRef)
//                        .collection(Object.RemoteDAO.collection)
//                        .getDocuments()
//                } else {
//                    snapshot = try await database
//                        .collection(ParentObject.RemoteDAO.collection)
//                        .document(documentID)
//                        .collection(Object.RemoteDAO.collection)
//                        .getDocuments()
//                }
//
//            } else {
//                snapshot = try await database.collection(Object.RemoteDAO.collection).getDocuments()
//            }
//
//            return try snapshot
//                .documents
//                .map { document in
//                    let objectDAO = try document.data(as: Object.RemoteDAO.self, decoder: decoder)
//
//                    return DAOFactory.initializeObject(from: objectDAO)
//                }
//        } catch {
//            throw DatabaseError.unableToRead
//        }
//    }
//}

/*
 private func collectionReference<Object: Storable>(_ object: Object) -> CollectionReference {
 let objectDAO: Object.RemoteDAO = DAOFactory.initializeDAO(from: object)
 let collection = Object.RemoteDAO.collection
 
 if let docRef = objectDAO.docRef {
 let collection = database
 .document(docRef)
 .collection(collection)
 
 print("collectionReference - objectDAO.docRef: ", collection.path)
 return collection
 } else {
 let collection = database
 .collection(collection)
 
 print("collectionReference: ", collection.path)
 return collection
 }
 }
 */

/*
 //    private func collectionReference<ParentObject: Storable, Object: Storable>(
 //        parentObject: ParentObject? = nil,
 //        objectOfType type: Object.Type
 //    ) throws -> CollectionReference {
 //
 //        // Get the collection name from the appropriate DAO
 //        let collection = Object.RemoteDAO.collection
 //
 //        if let parentObject = parentObject {
 //
 //            // If a parent object exists, retrieve its docRef
 //            // - protocol Reference
 //            let parentObjectDAO: ParentObject.RemoteDAO = DAOFactory.initializeDAO(from: parentObject)
 //
 //            guard let docRef = parentObjectDAO.docRef else {
 //                throw DatabaseError.unableToFindDocRef
 //            }
 //
 //            // Create and return a CollectionReference with the parent object
 //            return database
 //                .document(docRef)
 //                .collection(collection)
 //        } else {
 //            // Create and return a CollectionReference without a parent object
 //            return database
 //                .collection(collection)
 //        }
 //    }
 
 //    func saveProject<Object: Storable>(object: Object) throws {
 //        let objectDAO: Object.RemoteDAO = DAOFactory.initializeDAO(from: object)
 //        let documentID = String(describing: object.id)
 //
 //        do {
 //            try database
 //                .collection(Object.RemoteDAO.collection)
 //                .document(documentID)
 //                .setData(from: objectDAO, merge: false, encoder: encoder)
 //        } catch {
 //            throw DatabaseError.unableToCreate
 //        }
 //    }
 //
 //    func saveTask<Object: Storable>(object: Object) throws {
 //        let objectDAO: Object.RemoteDAO = DAOFactory.initializeDAO(from: object)
 //        let documentID = String(describing: object.id)
 //        print("DocRef - CloudDatabaseManager: ", objectDAO.docRef as Any)
 //
 //        do {
 //            try database
 //                .document(objectDAO.docRef ?? "" )
 //                .collection(Object.RemoteDAO.collection)
 //                .document(documentID)
 //                .setData(from: objectDAO, merge: false, encoder: encoder)
 //        } catch {
 //            throw DatabaseError.unableToCreate
 //        }
 //    }
 
 //    func getProjects<Object: Storable>(objectsOfType type: Object.) async throws -> [Object] {
 //        do {
 //            let snapshot = try await database.collection(Object.RemoteDAO.collection).getDocuments()
 //
 //            return try snapshot
 //                .documents
 //                .compactMap { document in
 //                    let objectDAO = try document.data(as: Object.RemoteDAO.self, decoder: decoder)
 //
 //                    return DAOFactory.initializeObject(from: objectDAO)
 //                }
 //        } catch {
 //            throw DatabaseError.unableToRead
 //        }
 //    }
 */

/*
 //    func save<ParentObject: Storable, Object: Storable>(parentObject: ParentObject? = nil, object: Object) throws {
 //        // Initialize a RemoteDAO for the Object using a DAOFactory
 //        var objectDAO: Object.RemoteDAO = DAOFactory.initializeDAO(from: object)
 //        let objectID = String(describing: object.id)
 //
 //        // Set the document reference for the objectDAO
 //        objectDAO.docRef = try collectionReference(parentObject: parentObject, objectOfType: Object.self).document(objectID).path
 //
 //        do {
 //            // Try to set data for the object in the database
 //            try database
 //                .document(objectDAO.docRef ?? "")
 //                .setData(from: objectDAO, merge: false, encoder: encoder)
 //        } catch {
 //            throw DatabaseError.unableToCreate
 //        }
 //    }
 //
 //    func get<ParentObject: Storable, Object: Storable>(parentObject: ParentObject? = nil, object: Object) async throws -> Object {
 //        let objectID = String(describing: object.id)
 //
 //        do {
 //            // Fetch the object from the database
 //            let objectDAO = try await collectionReference(parentObject: parentObject, objectOfType: Object.self)
 //                .document(objectID)
 //                .getDocument(as: Object.RemoteDAO.self, decoder: decoder)
 //
 //            // Initialize and return the Object from the retrieved objectDAO
 //            return DAOFactory.initializeObject(from: objectDAO)
 //        } catch {
 //            throw DatabaseError.unableToRead
 //        }
 //    }
 
 //    func getAll<ParentObject: Storable, Object: Storable>(parentObject: ParentObject? = nil, objectsOfType type: Object.Type) async throws -> [Object] {
 //        do {
 //            // Fetch all documents from the collection
 //            let snapshot = try await collectionReference(parentObject: parentObject, objectOfType: type).getDocuments()
 //
 //            // Map the documents to an array of Objects
 //            return try snapshot
 //                .documents
 //                .compactMap { document in
 //                    let objectDAO = try document.data(as: Object.RemoteDAO.self, decoder: decoder)
 //
 //                    // Initialize Objects from the retrieved ObjectDAO
 //                    return DAOFactory.initializeObject(from: objectDAO)
 //                }
 //        } catch {
 //            throw DatabaseError.unableToRead
 //        }
 //    }
 */
