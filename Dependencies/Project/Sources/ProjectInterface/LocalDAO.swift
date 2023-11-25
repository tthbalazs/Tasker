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
    public typealias Container = ProjectLocalDAO
    public typealias Contents = TodoLocalDAO<ProjectLocalDAO.LocalModel>.LocalDAOContainer
    
    @Persisted(primaryKey: true) public var id: String
    @Persisted public var name: String
    @Persisted public var contents: List<Contents>
    
    override public init() {
        super.init()
        self.name = ""
        self.contents = List<Contents>()
    }
    
    public init(from model: Project) {
        super.init()
        self.id = model.id
        self.name = model.name
        self.contents = List<Contents>()
        
        self.contents.append(
            objectsIn: model.contents?.compactMap { some in
                print("Object in append: ", TodoLocalDAO<Container.LocalModel>.LocalDAOContainer(from: model))
                return TodoLocalDAO<Container.LocalModel>.LocalDAOContainer(from: model)
            } ?? []
        )
        print("Model conetnts: ", model.contents)
        print("Self.contents: ", self.contents)
    }
}


public final class TodoLocalDAO<Container: CombinedStorable> : Object, LocalDAO {
    public typealias Container = TodoLocalDAO<Container>
    public typealias Contents = TodoLocalDAO<Container>
    public typealias LocalDAOContainer = Container.LocalDAO
    
    @Persisted(primaryKey: true) public var id: String
    @Persisted public var name: String
    @Persisted(originProperty: "contents") public var container: LinkingObjects<LocalDAOContainer>
    @Persisted public var contents: List<Contents>
    
    override public init() {
        super.init()
        self.name = ""
        self.container = LinkingObjects(fromType: LocalDAOContainer.self, property: "contents")
        self.contents = List()
    }
    
    public init(from model: Todo<Container>) {
        super.init()
        self.id = model.id
        self.name = model.name
    }
}


// MARK: WORK
/*
 public final class ProjectLocalDAO: Object, LocalDAO {
     public typealias Container = ProjectLocalDAO
     public typealias Tasks = TodoLocalDAO<ProjectLocalDAO.LocalModel>.LocalDAOContainer
     
     @Persisted(primaryKey: true) public var id: String
     @Persisted public var name: String
     
     @Persisted public var contents: List<Tasks>
     
     override public init() {
         super.init()
         self.name = ""
         self.contents = List<Tasks>()
     }
     
     public init(from model: Project) {
         super.init()
         self.id = model.id
         self.name = model.name
         self.contents = List<Tasks>()
     }
 }


 public final class TodoLocalDAO<Container: CombinedStorable> : Object, LocalDAO {
     public typealias Container = TodoLocalDAO<Container>.LocalDAOContainer
     public typealias Contents = TodoLocalDAO<Container>.LocalDAOContainer
     
     public typealias LocalDAOContainer = Container.LocalDAO
     
     @Persisted(primaryKey: true) public var id: String
     @Persisted public var name: String
     
     @Persisted(originProperty: "contents") public var container: LinkingObjects<LocalDAOContainer>
 //    @Persisted public var contents: List<LocalDAOContainer>
     
     override public init() {
         super.init()
         self.name = ""
         self.container = LinkingObjects(fromType: LocalDAOContainer.self, property: "contents")
 //        self.contents = List()
     }
     
     public init(from model: Todo<Container>) {
         super.init()
         self.id = model.id
         self.name = model.name
     }
 }
 
 
*/
// MARK: Current
/*
 public final class ProjectLocalDAO: Object, LocalDAO {
     public typealias Tasks = TodoLocalDAO<ProjectLocalDAO.LocalModel>
     
     @Persisted(primaryKey: true) public var id: String
     @Persisted public var name: String
     
     @Persisted public var contents: List<Tasks>
     
     override public init() {
         super.init()
         self.name = ""
         self.contents = List<Tasks>()
     }
     
     public init(from model: Project) {
         super.init()
         self.id = model.id
         self.name = model.name
         self.contents = List<Tasks>()
     }
 }


 public final class TodoLocalDAO<Container: CombinedStorable> : Object, LocalDAO {
     public typealias LocalContainer = Container.LocalDAO
     public typealias Contents = TodoLocalDAO<Container>
     
     @Persisted(primaryKey: true) public var id: String
     @Persisted public var name: String
     
     @Persisted(originProperty: "contents") var container: LinkingObjects<LocalContainer>
     @Persisted public var contents: List<Contents>
     
     override public init() {
         super.init()
         self.name = ""
         self.container = LinkingObjects(fromType: LocalContainer.self, property: "contents")
         self.contents = List<TodoLocalDAO>()
     }
     
     public init(from model: Todo<Container>) {
         super.init()
         self.id = model.id
         self.name = model.name
     }
 }

 
 */

/*
 public final class ProjectLocalDAO<Container: LocalDAO>: Object, LocalDAO {
     @Persisted(primaryKey: true) public var id: String
     @Persisted public var docRef: String?
     @Persisted public var name: String
     @Persisted public var tasks: List< TodoLocalDAO<Container> >
     
     @available(*, deprecated, message: "This initializer is required by Realm and should not be used directly to create objects.")
     override public init() {
         super.init()
         self.name = ""
         self.docRef = nil
         self.tasks = List< TodoLocalDAO<Container> >()
     }
     
     public init(from project: Project) {
         super.init()
         self.id = project.id
         self.name = project.name
         self.tasks = List< TodoLocalDAO<Container> >()
         
         self.tasks.append(
             objectsIn: project.tasks.map {
                 TodoLocalDAO(from: $0)
             }
         )
     }
 }

 public final class TodoLocalDAO<Container: LocalDAO>: Object, LocalDAO {
     @Persisted(primaryKey: true) public var id: String
     @Persisted public var docRef: String?
     @Persisted public var name: String
     @Persisted public var tasks: List<TodoLocalDAO>
     
     @available(*, deprecated, message: "This initializer is required by Realm and should not be used directly to create objects.")
     override public init() {
         super.init()
         self.name = ""
         self.docRef = nil
         self.tasks = List<TodoLocalDAO>()
         
     }
     
     public init(from todo: Todo<Container.Model>) {
         super.init()
         self.id = todo.id
         self.name = todo.name
         self.tasks = List<TodoLocalDAO>()
         
         self.tasks.append(
             objectsIn: todo.tasks.map {
                 TodoLocalDAO(from: $0)
             }
         )
     }
 }
 */
