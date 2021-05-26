//
//  GoogleSignInViewController.swift
//  SmileOnlineProject
//
//  Created by Алексей Волков on 25.05.2021.
//

import UIKit
import GoogleSignIn

class GoogleSignInViewController: UIViewController {

    @IBOutlet var signInButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
}
