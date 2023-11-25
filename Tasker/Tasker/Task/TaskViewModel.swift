//
//  TaskViewModel.swift
//  Tasker
//
//  Created by MaTooSens on 27/10/2023.
//

import DependencyInjection
import Foundation
import ProjectInterface

//@MainActor
//final class TaskViewModel: ObservableObject {
//    @Inject private var projectManager: ProjectManagerInterface
//    
//    @Published private(set) var todos: [Todo] = []
//    
//    func createTodo(todo: Todo) {
//        let newTodo = Todo(parentId: todo.id, name: "Todo - \(todos.count)")
//        
//        Task {
//            do {
//                print("NewTodo: ", newTodo)
//                print("\n")
//                
//                try await projectManager.save(parentObject: todo, object: newTodo)
//                getTodos(todo: todo)
//            } catch {
//                print(error)
//            }
//        }
//    }
//    
//    func getTodos(todo: Todo) {
//        Task {
//            do {
//                let firebaseTodos = try await projectManager.getAll(parentObject: todo, objectsOfType: Todo.self)
//                self.todos = firebaseTodos
//                
//                print("\n")
//                print("self.todos: ", todos)
//            }
//        }
//    }
//}
