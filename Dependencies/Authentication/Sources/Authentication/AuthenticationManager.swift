//
//  AuthenticationManager.swift
//
//
//  Created by MaTooSens on 25/10/2023.
//

import AuthenticationInterface
import FirebaseAuth

final class AuthenticationManager: AuthenticationManagerInterface {
    var userID: String = ""
    
    private let auth = Auth.auth()
    private let signInWithAppleHelper   = SignInWithAppleHelper()
    private let signInWithGoogleHelper  = SignInWithGoogleHelper()
    
    init() {
        userStateListener()
    }
    
    func signOut() throws {
        do {
            try auth.signOut()
        } catch {
            throw AuthenticationError.unableToSignOut
        }
    }
    
    private func userStateListener() {
        auth.addStateDidChangeListener { [weak self] auth, user in
            guard let self = self else { return }
            
            if let user {
                self.userID = user.uid
            }
        }
    }
}

// MARK: Manage user
extension AuthenticationManager {
    func signUp(withEmail email: String, password: String) async throws {
        do {
            try await auth.createUser(withEmail: email, password: password)
        } catch {
            throw AuthenticationError.unableToSignUp
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws -> AuthenticationDataResult {
        do {
            let user = try await auth.signIn(withEmail: email, password: password).user
            
            // user.getUserInfo() -> to get the user's provider ID from UserInfo
            return AuthenticationDataResult(user: user, userInfo: user.getUserInfo())
        } catch {
            print("Error: ", error.localizedDescription)
            throw AuthenticationError.unableToSignIn
        }
    }
    
    func updateEmail(email: String, password: String, newEmail: String) async throws {
        let user = try await reauthenticateUser(withEmail: email, password: password)
        
        do {
            try await user.updateEmail(to: newEmail)
        } catch {
            throw AuthenticationError.unableToUpdateEmail
        }
    }
    
    func sendVerifactionEmail() async throws {
        let user = try getCurrentUser()
        
        do {
            try await user.sendEmailVerification()
        } catch {
            throw AuthenticationError.unableToSentVerificationEmail
        }
    }
    
    func updatePassword(withEmail email: String, password: String, newPassword: String) async throws {
        let user = try await reauthenticateUser(withEmail: email, password: password)
        
        do {
            try await user.updatePassword(to: newPassword)
        } catch {
            throw AuthenticationError.unableToUpdatePassword
        }
    }
    
    func sendPasswordReset(withEmail email: String) async throws {
        do {
            try await auth.sendPasswordReset(withEmail: email)
        } catch {
            throw AuthenticationError.unableToSendPasswordReset
        }
    }
    
    func deleteAccount(withEmail email: String, password: String) async throws {
        let user = try await reauthenticateUser(withEmail: email, password: password)
        
        do {
            try await user.delete()
        } catch {
            throw AuthenticationError.unableToDelete
        }
    }
    
    private func reauthenticateUser(withEmail email: String, password: String) async throws -> User {
        let user = try getCurrentUser()
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        do {
            try await user.reauthenticate(with: credential)
        } catch {
            throw AuthenticationError.unableToReauthenticate
        }
        
        return user
    }
    
    private func getCurrentUser() throws -> User {
        try auth.currentUser ?? { throw AuthenticationError.unauthenticated }()
    }
}


// MARK: Sign in SSO
extension AuthenticationManager {
    func signInWithApple() async throws -> AuthenticationDataResult {
        let credential = try await appleCredential()
        return try await signIn(credential: credential)
    }
    
    func signInWithGoogle() async throws -> AuthenticationDataResult {
        let credential = try await googleCredential()
        return try await signIn(credential: credential)
    }
    
    func deleteAccountSSO() async throws {
        let user = try await reauthenticateUserSSO()
        
        do {
            try await user.delete()
        } catch {
            throw AuthenticationError.unableToDelete
        }
    }
    
    private func signIn(credential: AuthCredential) async throws -> AuthenticationDataResult {
        do {
            let user = try await auth.signIn(with: credential).user
            return AuthenticationDataResult(user: user, userInfo: user.getUserInfo())
        } catch {
            throw AuthenticationError.unableToSignIn
        }
    }
    
    private func reauthenticateUserSSO() async throws -> User {
        let user = try getCurrentUser()
        var credential: AuthCredential?
        
        switch user.getProviderID() {
        case .apple:
            credential = try await appleCredential()
        case .google:
            credential = try await googleCredential()
        default:
            break
        }
  
        if let credential {
            do {
                try await user.reauthenticate(with: credential)
            } catch {
                throw AuthenticationError.unableToReauthenticate
            }
        }
        
        return user
    }
}

// MARK: Sign in Anonymously
extension AuthenticationManager {
    func signInAnonymously() async throws -> AuthenticationDataResult {
        do {
            let user = try await auth.signInAnonymously().user
            return AuthenticationDataResult(user: user)
        } catch {
            throw AuthenticationError.unableToSignInAnonymously
        }
    }
    
    func linkEmail(result: SignInWithEmailHelperResult) async throws -> AuthenticationDataResult {
        let credential = EmailAuthProvider.credential(withSignInResult: result)
        return try await linkCredential(credential: credential)
    }
    
    func linkApple() async throws -> AuthenticationDataResult {
        let credential = try await appleCredential()
        return try await linkCredential(credential: credential)
    }
    
    func linkGoogle() async throws -> AuthenticationDataResult {
        let credential = try await googleCredential()
        return try await linkCredential(credential: credential)
    }
    
    private func linkCredential(credential: AuthCredential, result: SignInWithEmailHelperResult? = nil) async throws -> AuthenticationDataResult {
        let currentUser = try getCurrentUser()
        
        do {
            let user = try await currentUser.link(with: credential).user
            
            // To get the profile information retrieved from the sign-in email linked to a user, use the providerId property
            // `DisplayName` does not appear in userInfo, so we must use the user's profile information.
            // But on the other hand, `providerId` doesn't appear in the user profile information - so we need to get the data from userInfo
            if user.getProviderID() == .email {
                try await EmailAuthProvider.changeUserDisplayName(user: user, result: result)
                return AuthenticationDataResult(user: user, providerId: user.getProviderID())
            }
            
            return AuthenticationDataResult(user: user, userInfo: user.getUserInfo())
        } catch {
            throw AuthenticationError.unableToLinkCredential
        }
    }
}

// MARK: Credential
extension AuthenticationManager {
    private func appleCredential() async throws -> OAuthCredential {
        let result = try await signInWithAppleHelper.signInWithApple()
        return OAuthProvider.appleCredential(withSignInResult: result)
    }
    
    private func googleCredential() async throws -> AuthCredential {
        let result = try await signInWithGoogleHelper.signInWithGoogle()
        return GoogleAuthProvider.credential(withSignInResult: result)
    }
}
