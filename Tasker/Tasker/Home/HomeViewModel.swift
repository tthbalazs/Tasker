//
//  HomeViewModel.swift
//  Tasker
//
//  Created by MaTooSens on 27/10/2023.
//

import DependencyInjection
import Foundation
import ProjectInterface


@MainActor
final class HomeViewModel: ObservableObject {
    @Inject private var projectManager: ProjectManagerInterface
    
    @Published private(set) var projects: [Project] = []
    
    init() {
        getProjects()
    }
    
    func createProject() {
        let newProject = Project(name: "Project - \(projects.count)")
        
        Task {
            do {
                try projectManager.save(newProject)
                getProjects()
            } catch {
                print(error)
            }
        }
    }
    
    func getProjects() {
        Task {
            do {
                self.projects = try await projectManager.getAll(objectsOfType: Project.self)
            } catch {
                print(error)
            }
        }
    }
}
