//
//  AssemblyShared.swift
//  Tasker
//
//  Created by MaTooSens on 25/10/2023.
//

import DependencyInjection
import Foundation
import SwinjectStoryboard

extension SwinjectStoryboard {
    @objc class func setup() {
        Assemblies.setupDependencies()
    }
}

final class AssemblyShared {
    static func setupDependnecies() {
        
    }
}

