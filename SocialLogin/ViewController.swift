//
//  ViewController.swift
//  SocialLogin
//
//  Created by mobile on 2023/02/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func tappedGoogleLogin(_ sender: Any) {
        guard let loginnedViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginnedViewController") as? LoginnedViewController else { return }
        
        
        
        self.navigationController?.pushViewController(loginnedViewController, animated: true)
    }
    
    @IBAction func tappedKakaoLogin(_ sender: Any) {
        guard let loginnedViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginnedViewController") as? LoginnedViewController else { return }
        
        
        
        self.navigationController?.pushViewController(loginnedViewController, animated: true)
    }
    
    @IBAction func tappedAppleLogin(_ sender: Any) {
        guard let loginnedViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginnedViewController") as? LoginnedViewController else { return }
        
        
        
        self.navigationController?.pushViewController(loginnedViewController, animated: true)
    }
    
}

