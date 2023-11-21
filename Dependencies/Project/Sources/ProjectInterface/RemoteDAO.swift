//
//  RemoteDAO.swift
//  
//
//  Created by MaTooSens on 27/10/2023.
//

import Foundation
import CloudDatabaseInterface

public struct ProjectRemoteDAO: RemoteDAO {
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

public struct TodoRemoteDAO: RemoteDAO {
    public static var collection: String { "Todo" }
    public var parentId: String?
    
    public let id: String
    public let name: String
    
    public init(
        parentId: String?,
        id: String,
        name: String
    ) {
        self.parentId = parentId
        self.id = id
        self.name = name
    }
    
    public init(from todo: Todo) {
        self.parentId = todo.parentId
        self.id = todo.id
        self.name = todo.name
    }
}
