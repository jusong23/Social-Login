//
//  LoginnedViewController.swift
//  SocialLogin
//
//  Created by mobile on 2023/02/22.
//

import UIKit

//MARK: Google
import GoogleSignIn

//MARK: Apple
import FirebaseAuth

//MARK: Kakao
import KakaoSDKUser

class LoginnedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = LoginType.name
    }
    
    @IBAction func tappedLogout(_ sender: Any) {
        if LoginType.name == "Google" {
            GIDSignIn.sharedInstance.signOut()
            self.navigationController?.popViewController(animated: true)
        } else if LoginType.name == "Apple" {
            try? Auth.auth().signOut()
            self.navigationController?.popViewController(animated: true)
        } else if LoginType.name == "Kakao" {
            // 로그아웃
//            UserApi.shared.logout {(error) in
//                if let error = error {
//                    print(error)
//                }
//                else {
//                    print("logout() success.")
//                    self.navigationController?.popViewController(animated: true)
//                }
//            }
            
            // 연결 끊기
            // ✅ 연결 끊기 : 연결이 끊어지면 기존의 토큰은 더 이상 사용할 수 없으므로, 연결 끊기 API 요청 성공 시 로그아웃 처리가 함께 이뤄져 토큰이 삭제됩니다.
            UserApi.shared.unlink {(error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("unlink() success.")

                    // ✅ 연결끊기 시 메인으로 보냄
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }

}
