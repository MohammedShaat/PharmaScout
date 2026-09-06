//
//  DefaultAppleAuthService.swift
//  PharmaScout
//
//  Created by Mohammed on 9/3/26.
//

import Foundation
import AuthenticationServices
import CryptoKit

class DefaultAppleAuthService: NSObject, OAuthService {
    
    private var currentNonce: String?
    private var onCompletion: ((Result<AppleAuthResult, Error>) -> Void)?
    
    func signIn(viewController vc: UIViewController) async throws -> OAuthCredential {
        do {
            
            let result = try await startSignInFlowWithCheckedContinuation(viewController: vc)
            
            guard let appleIDCredential = result.appleIdCredential else {
                throw OAuthError.noExistingCredentials(.apple)
            }
            
            guard let idToken = appleIDCredential.identityToken
                .flatMap({ String(data: $0, encoding: .utf8) })
            else {
                throw OAuthError.idTokenUnavailable(.apple)
            }

            guard let nonce = result.nonce else {
                print("No nonce")
                throw OAuthError.failed(.apple)
            }
            
            return OAuthCredential(provider: .apple, idToken: idToken, nonce: nonce)
            
        }
        catch let error as ASAuthorizationError {
            throw mapASAuthorizationError(error)

        }
        catch let urlError as URLError {
            throw NetworkError(from: urlError)
            
        }
    }
    
    private func startSignInFlowWithCheckedContinuation(viewController vc: UIViewController) async throws -> AppleAuthResult {
        try await withCheckedThrowingContinuation { continuation in
            
            startSignInFlow(viewController: vc) { result in
                
                switch result {
                case .success(let credential):
                    continuation.resume(returning: credential)
                    
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
                
            }
            
        }
    }
    
    private func startSignInFlow(viewController vc: UIViewController, onCompletion: @escaping (Result<AppleAuthResult, Error>) -> Void) {
        self.onCompletion = onCompletion
        let nonce = randomNonceString()
        currentNonce = nonce

        let provider = ASAuthorizationAppleIDProvider()
        
        let request = provider.createRequest()
        request.requestedScopes = [.email, .fullName]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = vc
        authorizationController.performRequests()
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)

        let charset = Array(
            "0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._"
        )

        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
            var randomBytes = [UInt8](repeating: 0, count: 16)

            let error = SecRandomCopyBytes(
                kSecRandomDefault,
                randomBytes.count,
                &randomBytes
            )

            guard error == errSecSuccess else {
                fatalError("Unable to generate nonce")
            }

            for randomByte in randomBytes {
                if remainingLength == 0 {
                    break
                }

                if randomByte < charset.count {
                    result.append(charset[Int(randomByte)])
                    remainingLength -= 1
                }
            }
        }

        return result
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)

        return hashedData
            .map { String(format: "%02x", $0) }
            .joined()
    }
}

extension DefaultAppleAuthService: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        let appleIdCredential = authorization.credential as? ASAuthorizationAppleIDCredential
        
        let result = AppleAuthResult(appleIdCredential: appleIdCredential, nonce: currentNonce)
        onCompletion?(.success(result))
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: any Error) {
        onCompletion?(.failure(error))
    }
}

private struct AppleAuthResult {
    let appleIdCredential: ASAuthorizationAppleIDCredential?
    let nonce: String?
}

extension DefaultAppleAuthService {
    private func mapASAuthorizationError(_ error: ASAuthorizationError) -> OAuthError {
        switch error.code {
        case .canceled: .canceled(.apple)
        case .failed: .failed(.apple)
        case .invalidResponse: .invalidResponse(.apple)
        default: .unknow(error)
        }
    }
}


