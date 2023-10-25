//
//  AuthenticationManager.swift
//
//
//  Created by MaTooSens on 22/10/2023.
//

import Foundation
import AuthenticationInterface
import FirebaseAuth

final class AuthenticationManager: AuthenticationManagerInterface {
    var userID: String = ""
    
    private let emailUser = AuthenticationDataResult(
        uid: "1",
        isAnonymous: false,
        isEmailVerified: true,
        providerId: "password",
        email: "test@gmail.com",
        displayName: "Name Surname",
        photoUrl: "https://api.multiavatar.com/Binx.png"
    )
    
    private let appleUser = AuthenticationDataResult(
        uid: "2",
        isAnonymous: false,
        isEmailVerified: true,
        providerId: "apple.com",
        email: "test@icloud.com",
        displayName: "Apple Surname",
        photoUrl: "https://api.multiavatar.com/Binx.png"
    )
    
    private let googleUser = AuthenticationDataResult(
        uid: "3",
        isAnonymous: false,
        isEmailVerified: true,
        providerId: "google.com",
        email: "test@gmail.com",
        displayName: "Google Surname",
        photoUrl: "https://api.multiavatar.com/Binx.png"
    )
    
    private let anonimUser = AuthenticationDataResult(
        uid: "4",
        isAnonymous: true,
        isEmailVerified: false,
        providerId: nil,
        email: nil,
        displayName: nil,
        photoUrl: nil
    )
    
    func signOut() throws {
        // action
    }
}

// MARK: Manager user
extension AuthenticationManager {
    func signUp(withEmail email: String, password: String) async throws {
        // action
    }
    
    func signIn(withEmail email: String, password: String) async throws -> AuthenticationDataResult {
        emailUser
    }
    
    func updateEmail(email: String, password: String, newEmail: String) async throws {
        // action
    }
    
    func sendVerifactionEmail() async throws {
        // action
    }
    
    func updatePassword(withEmail email: String, password: String, newPassword: String) async throws {
        // action
    }
    
    func sendPasswordReset(withEmail email: String) async throws {
        // action
    }
    
    func deleteAccount(withEmail email: String, password: String) async throws {
        // action
    }
}


// MARK: Sign in SSO
extension AuthenticationManager {
    func signInWithApple() async throws -> AuthenticationDataResult {
        appleUser
    }
    
    func signInWithGoogle() async throws -> AuthenticationDataResult {
        googleUser
    }
    
    func deleteAccountSSO() async throws {
        // action
    }
}


// MARK: Sign in Anonymously
extension AuthenticationManager {
    func signInAnonymously() async throws -> AuthenticationDataResult {
        anonimUser
    }
    
    func linkEmail(result: SignInWithEmailHelperResult) async throws -> AuthenticationDataResult {
        emailUser
    }
    
    func linkApple() async throws -> AuthenticationDataResult {
        appleUser
    }
    
    func linkGoogle() async throws -> AuthenticationDataResult {
        googleUser
    }
}
