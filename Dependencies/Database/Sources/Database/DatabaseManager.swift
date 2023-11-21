//
//  DatabaseManager.swift
//  
//
//  Created by MaTooSens on 25/10/2023.
//

import DatabaseInterface
import RealmSwift

fileprivate struct DAOFactory {
    static func initializeObject<DAO: DAOInterface, Object: Storable>(from dao: DAO) -> Object {
        guard let dao = dao as? Object.LocalDAO else {
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

actor DatabaseManager: DatabaseManagerInterface {
    private var realm: Realm?
    
    private func openRealmIfNeeded() async throws {
        if realm == nil {
            try await initializeRealm()
        }
    }
    
    private func initializeRealm() async throws {
        do {
            self.realm = try await Realm(actor: self)
            print("\nInitialized Realm: \(realm?.configuration.fileURL?.absoluteString ?? "--")\n")
        } catch {
            throw DatabaseError.unableToOpenRealm
        }
    }
}

// MARK: CRUD
extension DatabaseManager {
    
//    func getAll<ParentObject: Storable, Object: Storable>(parentObject: ParentObject? = nil) async throws -> [Object] {
//        try await openRealmIfNeeded()
//        
//        if let parentObject {
//            let parentObjectID = String(describing: parentObject.id)
//            guard let parentObjectDAO = realm?.object(ofType: ParentObject.LocalDAO.self, forPrimaryKey: parentObjectID) else { throw DatabaseError.unableToFind }
//            
//            let parent: ParentObject = DAOFactory.initializeObject(from: parentObjectDAO)
//            
//            let some: [Object] = parent.contents as? [Object] ?? []
//            return some
//            
//        } else {
//            return realm?
//                .objects(Object.LocalDAO.self)
//                .compactMap { dao in
//                    DAOFactory.initializeObject(from: dao)
//                } ?? []
//        }
//    }
    
    
//    func getAll<ParentObject: Storable, Object: Storable>(parentObject: ParentObject? = nil) async throws -> [Object] {
//        try await openRealmIfNeeded()
//        
//        if let parentObject {
//            let parentObjectID = String(describing: parentObject.id)
//            
//            guard let parentObjectDAO = realm?.object(ofType: ParentObject.LocalDAO.self, forPrimaryKey: parentObjectID) else {
//                throw DatabaseError.unableToFind
//            }
//            
//            let parentObject: ParentObject = DAOFactory.initializeObject(from: parentObjectDAO)
//            
//            let objects: [Object] = parentObject.contents as? [Object] ?? []
//            return objects
//        } else {
//            return realm?
//                .objects(Object.LocalDAO.self)
//                .compactMap { dao in
//                    DAOFactory.initializeObject(from: dao)
//                } ?? []
//        }
//    }
    
    func save<ParentObject: Storable, Object: Storable>(parentObject: ParentObject? = nil, object: Object) async throws {
        try await openRealmIfNeeded()
        let objectDAO: Object.LocalDAO = DAOFactory.initializeDAO(from: object)
        
        do {
            if let parentObject = parentObject {
                try await saveToParentObject(parentObject, objectDAO: objectDAO)
            } else {
                try await saveObject(objectDAO)
            }
        } catch {
            throw DatabaseError.unableToSave
        }
    }
    
    private func saveToParentObject<ParentObject: Storable, Object: DAOInterface>(_ parentObject: ParentObject, objectDAO: Object) async throws {
        let parentObjectID = String(describing: parentObject.id)
        
        guard
            var parentObjectDAO = realm?.object(ofType: ParentObject.LocalDAO.self, forPrimaryKey: parentObjectID),
            let objectDAO = objectDAO as? ParentObject.LocalDAO.Contents
        else {
            throw DatabaseError.unableToFind
        }
        
        try await realm?.asyncWrite {
            parentObjectDAO.contents.append(objectDAO)
            realm?.add(parentObjectDAO, update: .modified)
        }
    }
    
    private func saveObject<Object: DAOInterface>(_ objectDAO: Object) async throws {
        try await realm?.asyncWrite {
            realm?.add(objectDAO, update: .modified)
        }
    }
    
    
    // MARK: Get all
    func getAll<ParentObject: Storable, Object: Storable>(parentObject: ParentObject? = nil) async throws -> [Object] {
        try await openRealmIfNeeded()
        
        if let parentObject = parentObject {
            return try await getObjectsForParentObject(parentObject)
        } else {
            return getObjects()
        }
    }
    
    private func getObjectsForParentObject<ParentObject: Storable, Object: Storable>(_ parentObject: ParentObject) async throws -> [Object] {
        let parentObjectID = String(describing: parentObject.id)
        
        guard let parentObjectDAO = realm?.object(ofType: ParentObject.LocalDAO.self, forPrimaryKey: parentObjectID) else {
            throw DatabaseError.unableToFind
        }
        
        let parentObject: ParentObject = DAOFactory.initializeObject(from: parentObjectDAO)
        
        let objects: [Object] = parentObject.contents as? [Object] ?? []
        return objects
    }

    private func getObjects<Object: Storable>() -> [Object] {
        return realm?
            .objects(Object.LocalDAO.self)
            .compactMap { dao in
                DAOFactory.initializeObject(from: dao)
            } ?? []
    }
}

/*
 //            let contents = parentObjectDAO?.contents
 //            let objects: [Object] = contents?.compactMap { content in
 //                   DAOFactory.initializeObject(from: content)
 //               } ?? []
 //
 //            print("\nObjects: ", objects)
 //            print("\n")
 //            return objects
 */
