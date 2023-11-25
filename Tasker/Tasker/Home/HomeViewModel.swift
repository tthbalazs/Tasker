//
//  HomeViewModel.swift
//  Tasker
//
//  Created by MaTooSens on 27/10/2023.
//

import Foundation
import Project
import ProjectInterface

@MainActor
final class HomeViewModel: ObservableObject {
    private var projectManager: ProjectManagerInterface
    
    @Published private(set) var projects: [Project] = []
    @Published var project: Project?
    
    @Published private(set) var todos: [Todo<Project>] = []
    
    init(projectManager: ProjectManagerInterface) {
        self.projectManager = projectManager
        getProjects()
    }
    
    func createProject() {
        let newProject = Project(name: "Project - \(projects.count)", contents: [])
        
        Task {
            do {
                try await projectManager.save(newProject)
                getProjects()
            } catch {
                print(error.localizedDescription)
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
    
    func createTask(project: Project) {
        print("\nself.project: ", self.project)
        print("\nProject from view: ", project)
        
        var projectOne = project
        print("\nProjectOne: ", projectOne)
        
        if projectOne.contents == nil {
            projectOne.contents = []
            print("Init array")
        }
        
        let newTask = Todo<Project>(name: "Todo - \(todos.count)")
        print("\nNewTask: ", newTask)
        
        projectOne.contents = [newTask]
        projectOne.contents?.append(newTask)
        print("\nProjectOne: ", projectOne.contents ?? "nil")
        
        Task {
            do {
                try await projectManager.save(projectOne)
                getTasks()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    
    func getTasks() {
        Task {
            do {
                self.todos = try await projectManager.getAll(parentObject: project, objectsOfType: Todo<Project>.self)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
