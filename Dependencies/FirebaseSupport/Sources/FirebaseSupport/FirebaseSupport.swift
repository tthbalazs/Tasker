//
//  FirebaseSupportMocks.swift
//
//
//  Created by MaTooSens on 16/10/2023.
//

import SwiftUI
import FirebaseCore

public final class AppDelegate: NSObject, UIApplicationDelegate {
    public func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
