//
//  SignInWithGoogleHelper.swift
//
//
//  Created by MaTooSens on 25/10/2023.
//

import FirebaseCore
import Foundation
import GoogleSignIn
import Utilities

struct SignInWithGoogleHelperResult {
    let idToken: String
    let accessToken: String
}

final class SignInWithGoogleHelper {
    
    @MainActor
    func signInWithGoogle() async throws -> SignInWithGoogleHelperResult {
        guard let id = FirebaseApp.app()?.options.clientID else {
            throw SignInWithGoogleError.invalidClientID
        }
        
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: id)
        
        guard let presentingViewController = UIApplication.rootViewController else {
            throw SignInWithGoogleError.viewControllerNotFound
        }
        
        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController)
        
        guard let idToken = gidSignInResult.user.idToken?.tokenString else {
            throw SignInWithGoogleError.unableToFetchToken
        }
        
        let accessToken = gidSignInResult.user.accessToken.tokenString
        
        return SignInWithGoogleHelperResult(idToken: idToken, accessToken: accessToken)
    }
}


// MARK: LocalizedError
extension SignInWithGoogleHelper {
    enum SignInWithGoogleError: LocalizedError {
        case viewControllerNotFound
        case invalidClientID
        case unableToFetchToken
        
        var errorDescription: String? {
            switch self {
            case .invalidClientID:
                return "Invalid clientID."
            case .viewControllerNotFound:
                return "Failed to find presenting view controller."
            case .unableToFetchToken:
                return "Unable to fetch identity token"
            }
        }
    }
}
