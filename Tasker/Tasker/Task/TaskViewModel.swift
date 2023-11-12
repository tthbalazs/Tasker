//
//  TaskViewModel.swift
//  Tasker
//
//  Created by MaTooSens on 27/10/2023.
//

import DependencyInjection
import Foundation
import ProjectInterface

@MainActor
final class TaskViewModel<Container: RemoteStorable>: ObservableObject {
    @Inject private var projectManager: ProjectManagerInterface
    
    @Published private(set) var todos: [Todo<Container>] = []
    
    func createTodo(todo: Todo<Container>) {
        let newTodo = Todo(container: todo, name: "Todo - \(todos.count)")
        
        Task {
            do {
                print("NewTodo: ", newTodo)
                print("\n")
                try projectManager.save(newTodo)
                getTodos(todo: todo)
            } catch {
                print(error)
            }
        }
    }
    
    func getTodos(todo: Todo<Container>) {
        Task {
            do {
                let firebaseTodos = try await projectManager
                    .getAll(parentObject: todo, objectsOfType: Todo<Container>.self)
                
                self.todos = firebaseTodos
                
                print("\n")
                print("container: ", todo as Any )
                print("\n")
                print("self.todos: ", todos)
                
            }
        }
    }
    
    private func getContainer<T: RemoteStorable>(_ containter: T) -> T {
        containter
    }
}
