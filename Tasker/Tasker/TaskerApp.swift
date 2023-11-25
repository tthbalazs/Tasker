//
//  TaskerApp.swift
//  Tasker
//
//  Created by MaTooSens on 25/10/2023.
//

import FirebaseSupport
import CloudDatabase
import Database
import Project
import Repository
import SwiftUI

@main
struct TaskerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate 
    
    private var projectManager = ProjectManager(
        repositoryManager: RepositoryManager(
            cloudDatabaseManager: CloudDatabaseManager(),
            databaseManager: DatabaseManager()
        )
    )

    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: HomeViewModel(projectManager: projectManager))
        }
    }
}
