//
//  LocalDAO.swift
//  
//
//  Created by MaTooSens on 27/10/2023.
//

import Foundation
import RealmSwift
import DatabaseInterface

//public final class ProjectLocalDAO<Container: LocalDAO>: Object, LocalDAO {
//    @Persisted(primaryKey: true) public var id: String
//    @Persisted public var docRef: String?
//    @Persisted public var name: String
//    @Persisted public var tasks: List< TodoLocalDAO<Container> >
//    
//    @available(*, deprecated, message: "This initializer is required by Realm and should not be used directly to create objects.")
//    override public init() {
//        super.init()
//        self.name = ""
//        self.docRef = nil
//        self.tasks = List< TodoLocalDAO<Container> >()
//    }
//    
//    public init(from project: Project) {
//        super.init()
//        self.id = project.id
//        self.name = project.name
//        self.tasks = List< TodoLocalDAO<Container> >()
//        
//        self.tasks.append(
//            objectsIn: project.tasks.map {
//                TodoLocalDAO(from: $0)
//            }
//        )
//    }
//}
//
//public final class TodoLocalDAO<Container: LocalDAO>: Object, LocalDAO {
//    @Persisted(primaryKey: true) public var id: String
//    @Persisted public var docRef: String?
//    @Persisted public var name: String
//    @Persisted public var tasks: List<TodoLocalDAO>
//    
//    @available(*, deprecated, message: "This initializer is required by Realm and should not be used directly to create objects.")
//    override public init() {
//        super.init()
//        self.name = ""
//        self.docRef = nil
//        self.tasks = List<TodoLocalDAO>()
//        
//    }
//    
//    public init(from todo: Todo<Container.Model>) {
//        super.init()
//        self.id = todo.id
//        self.name = todo.name
//        self.tasks = List<TodoLocalDAO>()
//        
//        self.tasks.append(
//            objectsIn: todo.tasks.map {
//                TodoLocalDAO(from: $0)
//            }
//        )
//    }
//}
