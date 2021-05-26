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
    @IBOutlet weak var nextButton: UIButton!
    
    var phone = ""
    var isHistory = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.dropShadow()
        codeTF.textFieldUI()
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
        guard UserDefaults.standard.string(forKey: "phoneNumber") != nil else { return }
    }
}
