//
//  Models.swift
//
//
//  Created by MaTooSens on 25/10/2023.
//

import Foundation
import FirebaseAuth

public struct AuthenticationDataResult {
    public let uid: String
    public let isAnonymous: Bool
    public let isEmailVerified: Bool
    public let providerId: String?
    
    // Profile
    public let email: String?
    public let displayName: String?
    public let photoUrl: String?
    
    
    // Mock
    public init(
        uid: String,
        isAnonymous: Bool,
        isEmailVerified: Bool,
        providerId: String?,
        email: String?,
        displayName: String?,
        photoUrl: String?
    ) {
        self.uid = uid
        self.isAnonymous = isAnonymous
        self.isEmailVerified = isEmailVerified
        self.providerId = providerId
        self.email = email
        self.displayName = displayName
        self.photoUrl = photoUrl
    }
    
    // From FirebaseAuth.User
    public init(
        user: User
    ) {
        self.uid = user.uid
        self.isAnonymous = user.isAnonymous
        self.isEmailVerified = user.isEmailVerified
        self.providerId = user.providerID
        self.email = user.email
        self.displayName = user.displayName
        self.photoUrl = user.photoURL?.absoluteString
    }
    
    public init(
        user: User,
        providerId: AuthenticationProviderOption?
    ) {
        self.uid = user.uid
        self.isAnonymous = user.isAnonymous
        self.isEmailVerified = user.isEmailVerified
        self.providerId = providerId?.rawValue
        self.email = user.email
        self.displayName = user.displayName
        self.photoUrl = user.photoURL?.absoluteString
    }
    
    
    public init(
        user: User,
        userInfo: UserInfo
    ) {
        self.uid = user.uid
        self.isAnonymous = user.isAnonymous
        self.isEmailVerified = user.isEmailVerified
        self.providerId = userInfo.providerID
        self.email = userInfo.email
        self.displayName = userInfo.displayName
        self.photoUrl = userInfo.photoURL?.absoluteString
    }
}

public struct SignInWithEmailHelperResult {
    public let email: String
    public let password: String
    public let name: String
    public let surname: String
    
    public var displayName: String {
        [name, surname].joined(separator: " ")
    }
    
    public init(
        email: String,
        password: String,
        name: String,
        surname: String
    ) {
        self.email = email
        self.password = password
        self.name = name
        self.surname = surname
    }
}
