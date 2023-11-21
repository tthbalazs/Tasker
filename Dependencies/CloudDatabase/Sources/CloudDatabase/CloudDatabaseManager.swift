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
    static func initializeObject<DAO: DAOInterface, Object: Storable>(from dao: DAO) -> Object {
        guard let dao = dao as? Object.RemoteDAO else {
            fatalError()
        }
        
        return Object(from: dao)
    }
    
    static func initializeDAO<Object: Storable, DAO: DAOInterface>(from object: Object) -> DAO {
        guard let object = object as? DAO.Model else {
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
    
    private lazy var documentReferences: [String:String] = [:]
    
    private func collectionReference<ParentObject: Storable, Object: Storable>(parentObject: ParentObject? = nil, objectOfType: Object.Type) -> CollectionReference {
        let collection = Object.RemoteDAO.collection
        let parentObjectCollection = ParentObject.RemoteDAO.collection
        
        func getCollectionReference(for parentObject: ParentObject) -> CollectionReference {
            let parentObjectDAO: ParentObject.RemoteDAO = DAOFactory.initializeDAO(from: parentObject)
            let parentObjectID = String(describing: parentObjectDAO.id)
            let parentDocumentReference: DocumentReference
            
            if let parentId = parentObject.parentId, let containerDocumentReference = documentReferences[parentId] {
                parentDocumentReference = database
                    .document(containerDocumentReference)
                    .collection(parentObjectCollection)
                    .document(parentObjectID)
            } else {
                parentDocumentReference = database
                    .collection(parentObjectCollection)
                    .document(parentObjectID)
            }
            
            documentReferences[parentObjectID] = parentDocumentReference.path
            return parentDocumentReference.collection(collection)
        }
        
        return parentObject.map(getCollectionReference) ?? database.collection(collection)
    }
}

// MARK: CRUD
extension CloudDatabaseManager {
    func save<ParentObject: Storable, Object: Storable>(parentObject: ParentObject? = nil, object: Object) throws {
        let objectDAO: Object.RemoteDAO = DAOFactory.initializeDAO(from: object)
        let documentID = String(describing: objectDAO.id)
        
        do {
            try collectionReference(parentObject: parentObject, objectOfType: Object.self)
                .document(documentID)
                .setData(from: objectDAO, merge: false, encoder: encoder)
        } catch {
            throw DatabaseError.unableToCreate
        }
    }
    
    func getAll<ParentObject: Storable, Object: Storable>(parentObject: ParentObject? = nil, objectsOfType type: Object.Type) async throws -> [Object] {
        do {
            return try await collectionReference(parentObject: parentObject, objectOfType: type)
                .getDocuments()
                .documents
                .map { document in
                    let objectDAO = try document.data(as: Object.RemoteDAO.self, decoder: decoder)
                    
                    return DAOFactory.initializeObject(from: objectDAO)
                }
        } catch {
            throw DatabaseError.unableToRead
        }
    }
}

/*
 func collectionReference<ParentObject: Storable, Object: Storable>(parentObject: ParentObject? = nil, objectOfType: Object.Type) -> CollectionReference {
     let collection = Object.RemoteDAO.collection
     let collectionReference: CollectionReference
     
     if let parentObject {
         let parentObjectDAO: ParentObject.RemoteDAO = DAOFactory.initializeDAO(from: parentObject)
         let parentObjectCollection = ParentObject.RemoteDAO.collection
         let parentObjectID = String(describing: parentObjectDAO.id)
         
         if let parentId = parentObject.parentId, let containerDocumentReference = documentReferences[parentId] {
             let parentDocumentReference = database.document(containerDocumentReference).collection(parentObjectCollection).document(parentObjectID)
             documentReferences[parentObjectID] = parentDocumentReference.path
             
             collectionReference = parentDocumentReference.collection(collection)
             
         } else {
             let parentDocumentReference = database.collection(parentObjectCollection).document(parentObjectID)
             documentReferences[parentObjectID] = parentDocumentReference.path
             
             collectionReference = parentDocumentReference.collection(collection)
         }
         
         
     } else {
         collectionReference = database .collection(collection)
     }
     
     return collectionReference
 }


 func collectionReference<Object: DAOInterface>(_ object: Object) -> CollectionReference {
     if let parentID = object.containerId, let parentDocRef = documentReferences[parentID] {
         return database
             .document(parentDocRef)
             .collection(Object.collection)
     } else {
         return database
             .collection(Object.collection)
     }
 }


 func getAll<ParentObject: Storable, Object: Storable>(parentObject: ParentObject? = nil, objectsOfType type: Object.Type) async throws -> [Object] {
     let collection = Object.RemoteDAO.collection
     var snapshot: QuerySnapshot
     
     if let parentObject {
         let parentObjectDAO: ParentObject.RemoteDAO = DAOFactory.initializeDAO(from: parentObject)
         let parentID = String(describing: parentObjectDAO.id)
         
         let parentDocumentReference = collectionReference(parentObjectDAO).document(parentID)
         print("ParentDocumentReference :", parentDocumentReference.path)
         documentReferences[parentID] = parentDocumentReference.path
         
         snapshot = try await parentDocumentReference
             .collection(collection)
             .getDocuments()
     } else {
         snapshot = try await database
             .collection(collection)
             .getDocuments()
     }
     
     do {
         return try snapshot
             .documents
             .map { document in
                 let objectDAO = try document.data(as: Object.RemoteDAO.self, decoder: decoder)
                 
                 return DAOFactory.initializeObject(from: objectDAO)
             }
     } catch {
         throw DatabaseError.unableToRead
     }
 }
 */
