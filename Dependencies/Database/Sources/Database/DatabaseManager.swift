//
//  DatabaseManager.swift
//
//
//  Created by MaTooSens on 25/10/2023.
//

import DatabaseInterface
import RealmSwift

fileprivate struct DAOFactory {
    static func initializeObject<DAO: LocalDAOInterface, Object: LocalStorable>(from dao: DAO) -> Object {
        guard let dao = dao as? Object.LocalDAO else {
            fatalError()
        }

        return Object(from: dao)
    }

    static func initializeDAO<Object: LocalStorable, DAO: LocalDAOInterface>(from object: Object) -> DAO {
        guard let object = object as? DAO.LocalModel else {
            fatalError()
        }

        return DAO(from: object)
    }
}

public actor DatabaseManager: DatabaseManagerInterface {
    public init() {}

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
            print("Error: ", error.localizedDescription)
            throw DatabaseError.unableToOpenRealm
        }
    }
}

// MARK: Create
extension DatabaseManager {
//    func save<ParentObject: LocalStorable, Object: LocalStorable>(parentObject: ParentObject? = nil, object: Object) async throws {
//        try await openRealmIfNeeded()
//        let objectDAO: Object.LocalDAO = DAOFactory.initializeDAO(from: object)
//
//        do {
//            if let parentObject = parentObject {
//                try await saveToParentObject(parentObject, objectDAO: objectDAO)
//            } else {
//                try await saveObject(objectDAO)
//            }
//        } catch {
//            throw DatabaseError.unableToSave
//        }
//    }
//
//
//    private func saveToParentObject<ParentObject: LocalStorable, Object: LocalDAOInterface>(_ parentObject: ParentObject, objectDAO: Object) async throws {
//        let parentObjectID = String(describing: parentObject.id)
//
//        guard
//            var parentObjectDAO = realm?.object(ofType: ParentObject.LocalDAO.self, forPrimaryKey: parentObjectID),
//            let objectDAO = objectDAO as? ParentObject.LocalDAO.Contents
//        else {
//            throw DatabaseError.unableToFind
//        }
//
//        try await realm?.asyncWrite {
//            parentObjectDAO.contents.append(objectDAO)
//            realm?.add(parentObjectDAO, update: .modified)
//        }
//    }
//
//    private func saveObject<Object: LocalDAOInterface>(_ objectDAO: Object) async throws {
//        try await realm?.asyncWrite {
//            realm?.add(objectDAO, update: .modified)
//        }
//    }
    
    public func save<ParentObject: LocalStorable, Object: LocalStorable>(parentObject: ParentObject? = nil, object: Object) async throws {
        try await openRealmIfNeeded()
        let objectDAO: Object.LocalDAO = DAOFactory.initializeDAO(from: object)
        
        print("ObjectDAO: ", objectDAO)
        
        do {
            if let parentObject = parentObject {
                print("ParentObject: ", parentObject)
                try await saveToParentObject(parentObject, objectDAO: objectDAO)
            } else {
                try await saveObject(objectDAO)
            }
        } catch {
            print(error.localizedDescription)
            throw DatabaseError.unableToSave
        }
    }
    
    private func saveToParentObject<ParentObject: LocalStorable, Object: LocalDAOInterface>(_ parentObject: ParentObject, objectDAO: Object) async throws {
        let parentObjectID = String(describing: parentObject.id)
        
        guard
            var parentObjectDAO = realm?.object(ofType: ParentObject.LocalDAO.self, forPrimaryKey: parentObjectID)
        else {
            print("parentObjectDAO: ")
            throw DatabaseError.unableToFind
        }
        
        print("Object before: ", objectDAO as? ParentObject.LocalDAO.Contents)
//
//        guard
//            let objectDAO = objectDAO as? ParentObject.LocalDAO.Contents
//        else {
//            print("objectDAO = objectDAO as? ParentObject.LocalDAO.Contents  ")
//            throw DatabaseError.unableToFind
//        }
        
        try await realm?.asyncWrite {
//            parentObjectDAO.contents.append(objectDAO as! ParentObject.LocalDAO.Contents)
            realm?.add(parentObjectDAO, update: .modified)
        }
    }
    
    private func saveObject<Object: LocalDAOInterface>(_ objectDAO: Object) async throws {
        try await realm?.asyncWrite {
            realm?.add(objectDAO, update: .modified)
        }
    }
}


// MARK: Reate
extension DatabaseManager {
    public func getAll<ParentObject: LocalStorable, Object: LocalStorable>(parentObject: ParentObject? = nil) async throws -> [Object] {
        try await openRealmIfNeeded()
        
        if let parentObject = parentObject {
            return try await getObjectsForParentObject(parentObject)
        } else {
            return getObjects()
        }
    }
    
    private func getObjectsForParentObject<ParentObject: LocalStorable, Object: LocalStorable>(_ parentObject: ParentObject) async throws -> [Object] {
        let parentObjectID = String(describing: parentObject.id)
        
        guard let parentObjectDAO = realm?.object(ofType: ParentObject.LocalDAO.self, forPrimaryKey: parentObjectID) else {
            throw DatabaseError.unableToFind
        }
        
        let parentObject: ParentObject = DAOFactory.initializeObject(from: parentObjectDAO)
        
        let objects: [Object] = parentObject.contents as? [Object] ?? []
        return objects
    }

    private func getObjects<Object: LocalStorable>() -> [Object] {
        return realm?
            .objects(Object.LocalDAO.self)
            .compactMap { dao in
                DAOFactory.initializeObject(from: dao)
            } ?? []
    }
}


/*
 //    func save<Object: Storable>(object: Object) async throws {
 //        try await openRealmIfNeeded()
 //        let objectDAO: Object.LocalDAO = DAOFactory.initializeDAO(from: object)
 //
 //        do {
 //            try await realm?.asyncWrite {
 //                realm?.add(objectDAO)
 //            }
 //        } catch {
 //            throw DatabaseError.unableToSave
 //        }
 //    }
 //
 //
 //    func getAll<Object: Storable>() async throws -> [Object] {
 //        try await openRealmIfNeeded()
 //
 //        return realm?
 //            .objects(Object.LocalDAO.self)
 //            .filter {
 //                $0.id == parentObject.id
 //            }
 //            .compactMap { dao in
 //                DAOFactory.initializeObject(from: dao)
 //            } ?? []
 //    }
 */
