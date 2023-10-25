//
//  AuthenticationInterface.swift
//
//
//  Created by MaTooSens on 25/10/2023.
//

import Foundation

public protocol AuthenticationManagerInterface {
    var userID: String { get }
    func signOut() throws
    
    // Manager user
    func signUp(withEmail email: String, password: String) async throws
    func signIn(withEmail email: String, password: String) async throws -> AuthenticationDataResult
    func updateEmail(email: String, password: String, newEmail: String) async throws
    func sendVerifactionEmail() async throws
    func updatePassword(withEmail email: String, password: String, newPassword: String) async throws
    func sendPasswordReset(withEmail email: String) async throws
    func deleteAccount(withEmail email: String, password: String) async throws
    
    // Sign in SSO
    func signInWithApple() async throws -> AuthenticationDataResult
    func signInWithGoogle() async throws -> AuthenticationDataResult
    func deleteAccountSSO() async throws
    
    // Sign in Anonymously
    func signInAnonymously() async throws -> AuthenticationDataResult
    func linkEmail(result: SignInWithEmailHelperResult) async throws -> AuthenticationDataResult
    func linkApple() async throws -> AuthenticationDataResult
    func linkGoogle() async throws -> AuthenticationDataResult
}

public enum AuthenticationProviderOption: String {
    case email      = "password"
    case google     = "google.com"
    case apple      = "apple.com"
    case facebook   = "facebook.com"
}

public enum AuthenticationError: LocalizedError {
    case unauthenticated
    
    // Manage user
    case unableToSignUp
    case unableToSignIn
    case unableToUpdateEmail
    case unableToSentVerificationEmail
    case unableToUpdatePassword
    case unableToSendPasswordReset
    
    // Anonymously
    case unableToSignInAnonymously
    case unableToLinkCredential
    
    // Shared
    case unableToReauthenticate
    case unableToSignOut
    case unableToDelete
    
    public var errorDescription: String? {
        switch self {
        case .unauthenticated:
            return "User authentication failed."
            
            // Manage user
        case .unableToSignUp:
            return "Registration failed. Unable to sign up."
        case .unableToSignIn:
            return "Sign-in failed. Unable to log in."
        case .unableToUpdateEmail:
            return "Unable to update email address."
        case .unableToSentVerificationEmail:
            return "Unable to send verification email."
        case .unableToUpdatePassword:
            return "Unable to update password."
        case .unableToSendPasswordReset:
            return "Unable to send password reset email."
   
            // Anonymously
        case .unableToSignInAnonymously:
            return "Unable to sign in anonymously."
        case .unableToLinkCredential:
            return "Unable to link credential."
            
            // Shared
        case .unableToReauthenticate:
            return "Unable to reauthenticate."
        case .unableToSignOut:
            return "Unable to sign the user out."
        case .unableToDelete:
            return "Unable to delete user account."
        }
    }
}
