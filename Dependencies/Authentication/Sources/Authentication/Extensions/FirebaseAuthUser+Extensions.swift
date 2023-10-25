//
//  FirebaseAuthUser+Extensions.swift
//
//
//  Created by MaTooSens on 25/10/2023.
//

import AuthenticationInterface
import FirebaseAuth

extension FirebaseAuth.User {
    func getProviderID() -> AuthenticationProviderOption? {
        self
            .providerData
            .compactMap { AuthenticationProviderOption(rawValue: $0.providerID) }
            .first
    }
    
    func getUserInfo() -> UserInfo {
        self
            .providerData[0]
    }
}
