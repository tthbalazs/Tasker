//
//  Providers+Extensions.swift
//
//
//  Created by MaTooSens on 25/10/2023.
//

import FirebaseAuth
import AuthenticationInterface

extension EmailAuthProvider {
    static func credential(withSignInResult result: SignInWithEmailHelperResult) -> AuthCredential {
        self.credential(
            withEmail: result.email,
            password: result.password
        )
    }
    
    static func changeUserDisplayName(user: User, result: SignInWithEmailHelperResult?) async throws {
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = result?.displayName
        try await changeRequest.commitChanges()
    }
}

extension OAuthProvider {
    static func appleCredential(withSignInResult result: SignInWithAppleHelperResult) -> OAuthCredential {
        self.appleCredential(
            withIDToken: result.idToken,
            rawNonce: result.nonce,
            fullName: result.fullName
        )
    }
}

extension GoogleAuthProvider {
    static func credential(withSignInResult result: SignInWithGoogleHelperResult) -> AuthCredential {
        self.credential(
            withIDToken: result.idToken,
            accessToken: result.accessToken
        )
    }
}
