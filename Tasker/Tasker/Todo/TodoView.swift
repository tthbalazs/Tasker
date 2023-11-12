//
//  TodoView.swift
//  Tasker
//
//  Created by MaTooSens on 27/10/2023.
//

import SwiftUI
import ProjectInterface

struct TodoView : View {
    @StateObject private var viewModel = TodoViewModel<Project>()
    let project: Project?
    
    var body: some View {
        VStack {
            ForEach(viewModel.todos) { todo in
                NavigationLink {
                    TaskView(task: todo)
                } label: {
                    VStack {
                        Text(todo.name)
                        Text(todo.id)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            
            Spacer()
            
            Button("Add todo") {
                viewModel.createTodo(project)
            }
        }
        .navigationTitle("Todo")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.getTodos(project)
        }
    }
}

//#Preview {
//
//}


/*
 struct TodoView : View {
     @EnvironmentObject private var router: NavigationStackViewModel
     @StateObject private var viewModel = TodoViewModel()
     let project: Project
     
     var body: some View {
         VStack {
             
             Text("Hello")
             
             ForEach(viewModel.todos) { todo in
                 Button(todo.name) {
                     router.push(value: todo)
                 }
             }
             
             Button("Add todo") {
                 viewModel.createTodo(project: project)
             }
         }
         .navigationTitle("Task")
         .navigationBarTitleDisplayMode(.inline)
         .onAppear {
             viewModel.getTodos(project: project)
         }
     }
 }

 #Preview {
     NavigationStack {
         TodoView(project: Project(name: "Project - 1"))
     }
 }

 */
