//
//  HomeView.swift
//  Tasker
//
//  Created by MaTooSens on 27/10/2023.
//

import SwiftUI
import ProjectInterface

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        VStack {
            Text("Project: \(viewModel.project?.name ?? "")")
            
            ForEach(viewModel.projects) { project in
                VStack {
                    Text(project.name)
                        .onTapGesture {
                            viewModel.project = project
                        }
                    Text(project.id)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    
                    Button("Add task") {
                        viewModel.createTask(project: project)
                    }
                }
            }
            
            Button("Add project") {
                viewModel.createProject()
            }
            
            Spacer()
            
            ForEach(viewModel.todos) { todo in
                VStack {
                    Text(todo.name)
                    Text(todo.id)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            
          
            
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}

/*
 struct HomeView: View {
     @StateObject private var viewModel = HomeViewModel()
     
     var body: some View {
         NavigationStack {
             VStack {
                 ForEach(viewModel.projects) { project in
                     NavigationLink {
                         TodoView(project: project)
                     } label: {
                         VStack {
                             Text(project.name)
                             Text(project.id)
                                 .font(.footnote)
                                 .foregroundStyle(.secondary)
                         }
                     }
                 }
                 
                 Button("Add project") {
                     viewModel.createProject()
                 }
                 
             }
             .navigationTitle("Projects")
             .navigationBarTitleDisplayMode(.inline)
         }
     }
 }

 #Preview {
     NavigationStack {
         HomeView()
     }
 }
 */
