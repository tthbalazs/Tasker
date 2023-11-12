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
}
