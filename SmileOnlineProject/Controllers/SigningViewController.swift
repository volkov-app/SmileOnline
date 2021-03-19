//
//  SigningViewController.swift
//  SmileOnlineProject
//
//  Created by Алексей Волков on 19.02.2021.
//

import UIKit
import Firebase

class SigningViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var numberTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberTF.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        numberTF.text = "+7"
    }
    
    @IBAction func nextTapped(_ sender: UIButton) {
        signUpByPhone()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func signUpByPhone() {
        
        guard let phone = numberTF.text else { return }
        
        UserDefaults.standard.set(phone, forKey: "phoneNumber")
        
        
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phone, uiDelegate: nil) { (verificationID, error) in
          if let error = error {
            print(error.localizedDescription)
            return
          }
          // Sign in using the verificationID and the code sent to the user
          // ...
          UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
          print("No error")
        }
    }

}
