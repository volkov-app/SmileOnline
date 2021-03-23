//
//  VerifyingViewController.swift
//  SmileOnlineProject
//
//  Created by Alex Rudoi on 25/2/21.
//

import UIKit
import Firebase

class VerifyingViewController: UIViewController {

    @IBOutlet weak var codeTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func nextTapped(_ sender: UIButton) {
        loginByVerificationCode()
    }
    
    @IBAction func sendOTPagain(_ sender: Any) {
        sendOTP()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func sendOTP() {
        guard let phone = UserDefaults.standard.string(forKey: "phoneNumber") else {
            return
        }
        
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phone, uiDelegate: nil) { (verificationID, error) in
          if let error = error {
            print(error.localizedDescription)
            return
          }
         
          UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
          print("No error")
        }
    }
    
    
    func loginByVerificationCode() {

        guard let verificationCode = codeTF.text else { return }
        UserDefaults.standard.set(verificationCode, forKey: "authVerificationCode")
        
        guard UserDefaults.standard.string(forKey: "authVerificationID") != nil else { return }
 
//              return
//            }
//            // ...
//            return
//          }
          // User is signed in
          // ...
    
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "QuestionsViewController")
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
            
           // print(authResult!.user.uid)
                UserDefaults.standard.set( authResult!.user.uid, forKey: "authID")
            }
    }
    

//}
