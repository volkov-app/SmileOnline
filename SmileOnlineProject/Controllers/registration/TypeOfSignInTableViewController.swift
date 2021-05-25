//
//  TypeOfSignInTableViewController.swift
//  SmileOnlineProject
//
//  Created by Алексей Волков on 23.05.2021.
//

import UIKit
import FirebaseUI

class TypeOfSignInTableViewController: UITableViewController, FUIAuthDelegate {

    var isHistory = false
    
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var AppleButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    
    //скокращение
    let storage = Storage.storage()
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        phoneButton.dropShadow()
        googleButton.dropShadow()
        AppleButton.dropShadow()
        facebookButton.dropShadow()
        
    
    }

    
    @IBAction func phoneButton(_ sender: Any) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "SigningViewController") as! SigningViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func appleIDLoginButtonTapped(_ sender: Any) {
        
        if let authUI = FUIAuth.defaultAuthUI() {
            authUI.providers = [FUIOAuth.appleAuthProvider()]
        authUI.delegate = self
        
        let authViewController = authUI.authViewController()
        self.present(authViewController, animated: true)
            
            
            
    }
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if let user = authDataResult?.user {
            print("nice! \(user.uid) и емей \(user.email ?? "") ")
            UserDefaults.standard.set( authDataResult?.user.uid, forKey: "authID")
            
            db.collection("users")
                .document("\(Auth.auth().currentUser!.uid)")
                .setData([
                    "number": "\(user.email ?? user.uid)"
                ]) { err in
                    if let err = err {
                        print("Error writing document: \(err.localizedDescription)")
                    } else {
                        print("Document successfully written!")
                        
                    }
                }
            
            if isHistory {
                
                let vc = self.storyboard!.instantiateViewController(withIdentifier: "statusNC") //as! ResultViewController
                self.present(vc, animated: true, completion: nil)
                
                
            } else {
            
                let vc = self.storyboard!.instantiateViewController(withIdentifier: "SendPhotoController") //as! ResultViewController
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
        
    }


}
