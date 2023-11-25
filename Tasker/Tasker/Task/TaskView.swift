//
//  TaskVew.swift
//  Tasker
//
//  Created by MaTooSens on 27/10/2023.
//

import SwiftUI
import ProjectInterface


//struct TaskView: View {
//    @StateObject private var viewModel = TaskViewModel()
//    let task: Todo
//    
//    var body: some View {
//        VStack {
//            ForEach(viewModel.todos) { todo in
//                NavigationLink {
//                    TaskView(task: todo)
//                } label: {
//                    VStack {
//                        Text(todo.name)
//                        Text(todo.id)
//                            .font(.footnote)
//                            .foregroundStyle(.secondary)
//                    }
//                }
//            }
//            
//            Button("Add todo") {
//                viewModel.createTodo(todo: task)
//            }
//        }
//        .navigationTitle("Task")
//        .navigationBarTitleDisplayMode(.inline)
//        .onAppear {
//            print("\n")
//            print("TASK: ", task)
//            print("\n")
//            viewModel.getTodos(todo: task)
//        }
//    }
//}
//
//#Preview {
//    NavigationStack {
//    }
//}

