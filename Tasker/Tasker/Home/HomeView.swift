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
                
                Spacer()
                
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
