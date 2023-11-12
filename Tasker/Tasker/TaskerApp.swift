//
//  TaskerApp.swift
//  Tasker
//
//  Created by MaTooSens on 25/10/2023.
//

import FirebaseSupport
import SwiftUI

@main
struct TaskerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate 
    
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
