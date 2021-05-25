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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
