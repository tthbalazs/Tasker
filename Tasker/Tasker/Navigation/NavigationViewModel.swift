//
//  NavigationViewModel.swift
//  Tasker
//
//  Created by MaTooSens on 07/11/2023.
//

import SwiftUI

final class NavigationStackViewModel: ObservableObject {
    @Published var paths = NavigationPath()
    
    func pushPaths(values: [any Hashable]) {
        for value in values {
            paths.append(value)
        }
    }
    
    func push(value: any Hashable) {
        paths.append(value)
    }
    
    func pop() {
        paths.removeLast()
    }
    
    func clearPathAndSetRoot(to root: any Hashable) {
        paths.removeLast(paths.count)
        paths.append(root)
    }
    
    func backToRoot() {
        paths.removeLast(paths.count)
    }
}

