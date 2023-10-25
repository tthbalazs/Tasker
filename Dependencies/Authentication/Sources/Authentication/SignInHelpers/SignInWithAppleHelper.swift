//
//  SignInWithAppleHelper.swift
//
//
//  Created by MaTooSens on 23/10/2023.
//

import AuthenticationServices
import CryptoKit
import Utilities

struct SignInWithAppleHelperResult {
    let idToken: String
    let nonce: String
    let fullName: PersonNameComponents?
}

final class SignInWithAppleHelper: NSObject {
    typealias SignInWithAppleHelperCompletion = (Result<SignInWithAppleHelperResult,Error>) -> Void
    
    private var completionHandler: SignInWithAppleHelperCompletion?
    private var currentNonce: String?
    
    @MainActor
    func signInWithApple() async throws -> SignInWithAppleHelperResult {
        try await withCheckedThrowingContinuation { continuation in
            self.startSignInWithAppleFlow { result in
                switch result {
                case .success(let signInAppleResult):
                    continuation.resume(returning: signInAppleResult)
                    return
                case .failure(let error):
                    continuation.resume(throwing: error)
                    return
                }
            }
        }
    }
    
    @MainActor
    private func startSignInWithAppleFlow(completion: @escaping SignInWithAppleHelperCompletion) {
        let nonce = randomNonceString()
        currentNonce = nonce
        completionHandler = completion
        showAppleLoginView(nonce: nonce)
    }
}


// MARK: Random Nonce String
private extension SignInWithAppleHelper {
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
}


// MARK: Show Apple Login View
private extension SignInWithAppleHelper {
    private func showAppleLoginView(nonce: String) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}


// MARK: Authorization Controller
extension SignInWithAppleHelper: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization ) {
        do {
            let idToken = try getTokenFromAuthorization(authorization: authorization)
            let nonce = try getCurrentNonce()
            let fullName = try getFullName(authorization: authorization)
            let result = SignInWithAppleHelperResult(idToken: idToken, nonce: nonce, fullName: fullName)
            completionHandler?(.success(result))
        } catch {
            completionHandler?(.failure(error))
        }
    }
    
    private func getTokenFromAuthorization(authorization: ASAuthorization) throws -> String {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential
        else { throw SignInWithAppleError.invalidCredential }
        
        guard let appleIDToken = appleIDCredential.identityToken
        else { throw SignInWithAppleError.unableToFetchToken }
        
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8)
        else { throw SignInWithAppleError.unableToSerializeToken }
        
        return idTokenString
    }
    
    private func getCurrentNonce() throws -> String {
        guard let currentNonce else { throw SignInWithAppleError.unableToFindNonce }
        return currentNonce
    }
    
    private func getFullName(authorization: ASAuthorization) throws -> PersonNameComponents? {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential
        else { throw SignInWithAppleError.invalidCredential }
        
        return appleIDCredential.fullName
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        completionHandler?(.failure(error))
    }
}


// MARK: View Controller
extension SignInWithAppleHelper: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard
            let presentingViewController = UIApplication.rootViewController,
            let window = presentingViewController.view.window
        else { fatalError() }
        
        return window
    }
}


// MARK: LocalizedError
extension SignInWithAppleHelper {
    enum SignInWithAppleError: LocalizedError {
        case invalidCredential
        case unableToFetchToken
        case unableToSerializeToken
        case unableToFindNonce
        
        var errorDescription: String? {
            switch self {
            case .invalidCredential:
                return "Invalid credential: ASAuthorization failure."
            case .unableToFetchToken:
                return "Unable to fetch identity token"
            case .unableToSerializeToken:
                return "Unable to serialize token string from data"
            case .unableToFindNonce:
                return "Unable to find current nonce."
            }
        }
    }
}
