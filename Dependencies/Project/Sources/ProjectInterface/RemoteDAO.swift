//
//  RemoteDAO.swift
//  
//
//  Created by MaTooSens on 27/10/2023.
//

import Foundation
import CloudDatabaseInterface

public struct ProjectRemoteDAO: RemoteDAO {
    public typealias Container = ProjectRemoteDAO
    public static let collection: String = "Projects"
        
    public let id: String
    public let name: String
    
    public init(
        id: String,
        name: String
    ) {
        self.id = id
        self.name = name
    }
    
    public init(from project: Project) {
        self.id = project.id
        self.name = project.name
    }
}

public struct TodoRemoteDAO<Container: RemoteDAO>: RemoteDAO {
    public static var collection: String { "Todo" }
    public var container: Container?
    
    public let id: String
    public let name: String
    
    public init(
        id: String,
        name: String
    ) {
        self.id = id
        self.name = name
    }
    
    public init(from todo: Todo<Container.Model>) {
        self.id = todo.id
        self.name = todo.name
        self.container = todo.container.map {
            let some = Container(from: $0)
            print("Container in remoteDAO: ", some)
            return some
        }
    }
}
