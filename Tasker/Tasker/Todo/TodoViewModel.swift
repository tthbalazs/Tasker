//
//  TodoViewModel.swift
//  Tasker
//
//  Created by MaTooSens on 27/10/2023.
//

import Foundation
import ProjectInterface

//@MainActor
//final class TodoViewModel: ObservableObject {
//    @Inject private var projectManager: ProjectManagerInterface
//    @Published private(set) var todos: [Todo] = []
//    
//    func createTodo(_ project: Project) async throws {
//        let newTodo = Todo(parentId: project.id, name: "Todo - \(todos.count)")
//        print("NewTodo: ", newTodo)
//        print("\n")
//        
//            try await projectManager.save(parentObject: project, object: newTodo)
//            try await getTodos(project)
//    }
//    
//    func getTodos(_ project: Project) async throws {
//            print("Project: ", project)
//            self.todos = try await projectManager.getAll(parentObject: project, objectsOfType: Todo.self)
//    }
//}

/*
 @MainActor
 final class TodoViewModel<Container: RemoteStorable>: ObservableObject {
     @Inject private var projectManager: ProjectManagerInterface
     @Published private(set) var todos: [Todo<Container>] = []
     
     func createTodo(_ container: Container?) {
         Task {
             try projectManager.save(
                 Todo(
                     container: container,
                     name: "Todo - \(todos.count)"
                 )
             )
             
             getTodos(container)
         }
     }
     
     func getTodos(_ container: Container?) {
         Task {
             self.todos = try await projectManager
                 .getAll(
                     parentObject: container,
                     objectsOfType: Todo<Container>.self
                 )
                 .map {
                     Todo(
                         container: container,
                         id: $0.id,
                         name: $0.name
                     )
                 }
         }
     }
 }
 */


/*
 @MainActor
 final class TodoViewModel: ObservableObject {
     @Inject private var projectManager: ProjectManagerInterface
     @Published private(set) var todos: [Todo<Project>] = []
     
     func createTodo(project: Project) {
         let newTodo = Todo(container: project, name: "Todo - \(todos.count)")
         
         Task {
             do {
                 try projectManager.save(newTodo)
                 getTodos(project: project)
             }
         }
     }
     
     func getTodos(project: Project) {
         Task {
             do {
                 let todosFromFirestore = try await projectManager.getAll(parentObject: project, objectsOfType: Todo<Project>.self)
                 
                 let some1 = todosFromFirestore.compactMap { todo in
                     let some = Todo(container: project, id: todo.id, name: todo.name)
                     return some
                 }
                 
                 self.todos = some1
             }
         }
     }
 }
 */
