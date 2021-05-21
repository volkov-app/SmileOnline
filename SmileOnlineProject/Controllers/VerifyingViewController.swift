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
    
    var phone = ""
    var isHistory = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Делаем красивый текст филд
        codeTF.layer.borderColor = UIColor.blue.cgColor
        codeTF.layer.cornerRadius = 5.0
        codeTF.layer.borderWidth = 1.0
        codeTF.layer.masksToBounds = true
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func nextTapped(_ sender: UIButton) {
        guard let verificationCode = codeTF.text else { return }
            FirebaseManager.instance.loginByVerificationCode(verificationCode: verificationCode, phone: phone, mainVC: self, isHistory: isHistory)
        
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
        
        
        
    }
    
    
    
}
