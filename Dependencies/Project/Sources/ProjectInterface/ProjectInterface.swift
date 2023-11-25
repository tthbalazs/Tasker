//
//  ProjectInterface.swift
//
//
//  Created by MaTooSens on 27/10/2023.
//

import CloudDatabaseInterface
import DatabaseInterface
import Foundation

public typealias CombinedStorable = LocalStorable & RemoteStorable
public typealias LocalDAO = LocalDAOInterface
public typealias RemoteDAO = RemoteDAOInterface

public protocol ProjectManagerInterface {
    func save<ParentObject: CombinedStorable, Object: CombinedStorable>(parentObject: ParentObject?, object: Object) async throws
    func getAll<ParentObject: CombinedStorable, Object: CombinedStorable>(parentObject: ParentObject?, objectsOfType type: Object.Type) async throws -> [Object]
}

public extension ProjectManagerInterface {
    func save<Object: CombinedStorable>(_ object: Object) async throws {
        try await save(parentObject: Object?.none, object: object)
    }
    
    func getAll<Object: CombinedStorable>(objectsOfType type: Object.Type) async throws -> [Object] {
        try await getAll(parentObject: Object?.none, objectsOfType: type)
    }
}

public struct Project: CombinedStorable {
    public typealias Contents = Todo<Project>
    
    public let id: String
    public let name: String
    public let contents: [Todo<Project>]
    
    public init(
        id: String = UUID().uuidString,
        name: String,
        contents: [Todo<Project>] = []
    ) {
        self.id = id
        self.name = name
        self.contents = contents
    }
    
    public init(from dao: ProjectLocalDAO) {
        self.id = dao.id
        self.name = dao.name
        self.contents = dao.contents.compactMap {
            print("Name: ", $0.name)
            return nil
        }
//        self.contents = nil
    }
    
    public init(from dao: ProjectRemoteDAO) {
        self.id = dao.id
        self.name = dao.name
        self.contents = []
    }
}

public struct Todo<Container: CombinedStorable>: CombinedStorable {
    public typealias Contents = Todo<Container>
    
    public let id: String
    public let name: String
    
    public let container: Container?
    public let contents: [Todo<Container>]?
    
    public init (
        id: String = UUID().uuidString,
        name: String,
        container: Container? = nil,
        contents: [Todo<Container>]? = nil
    ) {
        self.id = id
        self.name = name
        self.container = container
        self.contents = contents
    }
    
    public init(from dao: TodoLocalDAO<Container>) {
        self.id = dao.id
        self.name = dao.name
        self.container = dao.container.first.map { Container(from: $0) }
//        self.contents = dao.contents.compactMap { Todo(from: $0) }
//        self.container = nil
        self.contents = nil
    }
    
    public init(from dao: TodoRemoteDAO<Container>) {
        self.id = dao.id
        self.name = dao.name
        self.container = nil
        self.contents = nil
    }
}


public extension Todo where Container: LocalStorable {

}

public extension Todo where Container: RemoteStorable {
   
}


/*
 class Person: Object {
     @Persisted(originProperty: "members") var clubs: LinkingObjects<DogClub>
 }
 
 class DogClub: Object {
     @Persisted var members: List<Person>
 }
 
 // Later, query the specific person
 let specificPerson = realm.object(ofType: Person.self, forPrimaryKey: 12345)
 
 // Access directly through an inverse relationship
 let clubs = specificPerson!.clubs
 let firstClub = clubs[0]
*/
 
 
/*
 public protocol ProjectManagerInterface {
     func save<Object: RemoteStorable>(_ object: Object) throws
     func getAll<ParentObject: RemoteStorable, Object: RemoteStorable>(parentObject: ParentObject?, objectsOfType type: Object.Type) async throws -> [Object]
 }

 public extension ProjectManagerInterface {
     func getAll<Object: RemoteStorable>(objectsOfType type: Object.Type) async throws -> [Object] {
         try await getAll(parentObject: Object?.none, objectsOfType: type)
     }
 }
 
 public init(from dao: TodoRemoteDAO<Container.RemoteDAO>) {
     self.id = dao.id
     self.name = dao.name
     self.container = dao.container.map {
         let some = Container(from: $0)
         print("Container in Domain: ", some)
         return some
     }
 }
 
 public func hash(into hasher: inout Hasher) {
     hasher.combine(id)
     hasher.combine(name)
 }
 */
