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
        
        guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else { return }

        let credential = PhoneAuthProvider.provider().credential(
        withVerificationID: verificationID,
        verificationCode: verificationCode)

        Auth.auth().signIn(with: credential) { (authResult, error) in
          if let error = error {
            let authError = error as NSError
            if (authError.code == AuthErrorCode.secondFactorRequired.rawValue) {
              // The user is a multi-factor user. Second factor challenge is required.
              let resolver = authError.userInfo[AuthErrorUserInfoMultiFactorResolverKey] as! MultiFactorResolver
              var displayNameString = ""
              for tmpFactorInfo in (resolver.hints) {
                displayNameString += tmpFactorInfo.displayName ?? ""
                displayNameString += " "
              }
              
            } else {
                let alert = UIAlertController(title: "Неверный код", message: "Проверьте правильность или запросите новый", preferredStyle: .alert)
                let alertAction1 = UIAlertAction(title: "ОК", style: .default)
                let alertAction2 = UIAlertAction(title: "Отправить повторно", style: .default) { (_) in
                    self.sendOTP()
                }
                alert.addAction(alertAction1)
                alert.addAction(alertAction2)
                
                self.present(alert, animated: true)
                
              print(error.localizedDescription)
              return
            }
            // ...
            return
          }
          // User is signed in
          // ...
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "QuestionsViewController")
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
            
            print(authResult!.user.uid)
        }
    }
    

}
