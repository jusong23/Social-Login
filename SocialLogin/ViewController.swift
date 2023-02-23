//
//  ViewController.swift
//  SocialLogin
//
//  Created by mobile on 2023/02/22.
//

import UIKit

//MARK: Google
import GoogleSignIn

//MARK: Apple
import FirebaseAuth
import AuthenticationServices
import CryptoKit

//MARK: Kakao
import KakaoSDKUser
import KakaoSDKAuth

struct LoginType {
    static var name: String = ""
}

class ViewController: UIViewController {

    fileprivate var currentNonce: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func tappedGoogleLogin(_ sender: Any) {
        guard let loginnedViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginnedViewController") as? LoginnedViewController else { return }
        let config = GIDConfiguration(clientID: "507215977108-t8kkjmc2odaupfli1jcre62ctci300bk.apps.googleusercontent.com")
        GIDSignIn.sharedInstance.configuration = config
        GIDSignIn.sharedInstance.signIn(withPresenting: self) {
            user, error in
            if let error = error { return }
            guard let user = user else { return }

            print(user.user.userID)
            print(user.user.accessToken)
            print(user.user.profile?.email)
            print(user.user.profile?.name)
            LoginType.name = "Google"
            self.navigationController?.pushViewController(loginnedViewController, animated: true)
        }
    }
    
//    func logInForWeb() {
//        AuthApi.shared.loginWithKakaoAccount {(oauthToken, error) in
//           if let error = error {
//             print(error)
//           }
//           else {
//            print("loginWithKakaoAccount() success.")
//            // AppDelegate에서 네이티브 앱 키가 아니라 웹 전용 키로 등록해줘야하는 거 같음(추측)
//
//            //do something
//            _ = oauthToken
//           }
//        }
//    }

    @IBAction func tappedKakaoLogin(_ sender: Any) {
        guard let loginnedViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginnedViewController") as? LoginnedViewController else { return }

        // 카카오톡 실행 가능 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                if let error = error {
                    print(error)
                    print("앱이 설치되지 않아 웹으로 연결합니다.")
//                    self.logInForWeb()
                }
                else {
                    print("loginWithKakaoTalk() success.")

                    //do something
                    _ = oauthToken
                    self.setUserInfo()
                    LoginType.name = "Kakao"
                    self.navigationController?.pushViewController(loginnedViewController, animated: true)
                }
            }
        }

    }
    
    func setUserInfo() {
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print(error)
            }
            else {
                print("me() success.")
                //do something
                _ = user
                print(user?.kakaoAccount?.profile?.nickname)
                
            }
        }
    }

    @IBAction func tappedAppleLogin(_ sender: Any) {
        startSignInWithAppleFlow()
    }

}

extension ViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }

            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)

            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print ("Error Apple sign in: %@", error)
                    return
                }
                // User is signed in to Firebase with Apple.
                // ...
                ///Main 화면으로 보내기
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let loginnedViewController = storyboard.instantiateViewController(identifier: "LoginnedViewController")
                LoginType.name = "Apple"
                self.navigationController?.pushViewController(loginnedViewController, animated: true)
            }
        }
    }
}

//Apple Sign in
extension ViewController {
    func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest() // 릴레이 공격방지
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
            return String(format: "%02x", $0)
        }.joined()

        return hashString
    }

    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }

            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }

                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }

        return result
    }
}

extension ViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
