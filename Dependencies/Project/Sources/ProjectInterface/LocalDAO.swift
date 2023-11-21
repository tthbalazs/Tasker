//
//  LocalDAO.swift
//  
//
//  Created by MaTooSens on 27/10/2023.
//

import Foundation
import RealmSwift
import DatabaseInterface

public final class ProjectLocalDAO: Object, LocalDAO {
    @Persisted(primaryKey: true) public var id: String
    @Persisted public var name: String
    @Persisted public var contents: List<TodoLocalDAO>
    
    @available(*, deprecated, message: "This initializer is required by Realm and should not be used directly to create objects.")
    override public init() {
        super.init()
        self.name = ""
    }
    
    public init(from project: Project) {
        super.init()
        self.id = project.id
        self.name = project.name
        self.contents = List<TodoLocalDAO>()
        
        let projects = project
            .contents?
            .compactMap {
                TodoLocalDAO(from: $0)
            } ?? []
        
        print("\nProjects ProjectLocalDAO: ", projects)
        self.contents.append(objectsIn: projects)
    }
}

public final class TodoLocalDAO: Object, LocalDAO {
    @Persisted(primaryKey: true) public var id: String
    @Persisted public var name: String
    @Persisted public var parentId: String?
    @Persisted public var contents: List<TodoLocalDAO>
    
    @available(*, deprecated, message: "This initializer is required by Realm and should not be used directly to create objects.")
    override public init() {
        super.init()
        self.name = ""
        self.parentId = ""
        self.contents = List<TodoLocalDAO>()
        
    }
    
    public init(from todo: Todo) {
        super.init()
        self.id = todo.id
        self.name = todo.name
        self.parentId = todo.parentId
        self.contents = List<TodoLocalDAO>()
                
        self.contents.append(
            objectsIn: todo
                .contents?
                .compactMap {
                    TodoLocalDAO(from: $0)
                } ?? []
        )
    }
}
