//
//  LoginnedViewController.swift
//  SocialLogin
//
//  Created by mobile on 2023/02/22.
//

import UIKit
import GoogleSignIn

class LoginnedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = LoginType.name
    }
    
    @IBAction func tappedLogout(_ sender: Any) {
        if LoginType.name == "Google" {
            GIDSignIn.sharedInstance.signOut()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
