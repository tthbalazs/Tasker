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
    
    private func collectionReference<ParentObject: Storable, Object: Storable>(
        parentObject: ParentObject? = nil,
        objectOfType type: Object.Type
    ) throws -> CollectionReference {
        
        // Get the collection name from the appropriate DAO
        let collection = Object.RemoteDAO.collection
        
        if let parentObject = parentObject {
            
            // If a parent object exists, retrieve its docRef
            // - protocol Reference
            let parentObjectDAO: ParentObject.RemoteDAO = DAOFactory.initializeDAO(from: parentObject)
            
            guard let docRef = parentObjectDAO.docRef else {
                throw DatabaseError.unableToFindDocRef
            }
            
            // Create and return a CollectionReference with the parent object
            return database
                .document(docRef)
                .collection(collection)
        } else {
            // Create and return a CollectionReference without a parent object
            return database
                .collection(collection)
        }
    }
}

// MARK: CRUD
extension CloudDatabaseManager {
    func save<ParentObject: Storable, Object: Storable>(parentObject: ParentObject? = nil, object: Object) throws {
        // Initialize a RemoteDAO for the Object using a DAOFactory
        var objectDAO: Object.RemoteDAO = DAOFactory.initializeDAO(from: object)
        let objectID = String(describing: object.id)
        
        // Set the document reference for the objectDAO
        objectDAO.docRef = try collectionReference(parentObject: parentObject, objectOfType: Object.self).path
        
        do {
            // Try to set data for the object in the database
            try database
                .document(objectDAO.docRef ?? "")
                .setData(from: objectDAO, merge: false, encoder: encoder)
        } catch {
            throw DatabaseError.unableToCreate
        }
    }
    
    func get<ParentObject: Storable, Object: Storable>(parentObject: ParentObject? = nil, object: Object) async throws -> Object {
        let objectID = String(describing: object.id)
        
        do {
            // Fetch the object from the database
            let objectDAO = try await collectionReference(parentObject: parentObject, objectOfType: Object.self)
                .document(objectID)
                .getDocument(as: Object.RemoteDAO.self, decoder: decoder)
            
            // Initialize and return the Object from the retrieved objectDAO
            return DAOFactory.initializeObject(from: objectDAO)
        } catch {
            throw DatabaseError.unableToRead
        }
    }
    
    func getAll<ParentObject: Storable, Object: Storable>(parentObject: ParentObject? = nil, objectsOfType type: Object.Type) async throws -> [Object] {
        do {
            // Fetch all documents from the collection
            let snapshot = try await collectionReference(parentObject: parentObject, objectOfType: type).getDocuments()
            
            // Map the documents to an array of Objects
            return try snapshot
                .documents
                .compactMap { document in
                    let objectDAO = try document.data(as: Object.RemoteDAO.self, decoder: decoder)
                    
                    // Initialize Objects from the retrieved ObjectDAO
                    return DAOFactory.initializeObject(from: objectDAO)
                }
        } catch {
            throw DatabaseError.unableToRead
        }
    }
}
