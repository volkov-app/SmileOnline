//
//  SigningViewController.swift
//  SmileOnlineProject
//
//  Created by Алексей Волков on 19.02.2021.
//

import UIKit
import Firebase

class SigningViewController: UIViewController, UITextFieldDelegate{
    
    var isHistory = false
    
    @IBOutlet weak var numberTF: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberTF.delegate = self
        nextButton.dropShadow()
        numberTF.textFieldUI()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        numberTF.text = "+7"
    }
    
    @IBAction func nextTapped(_ sender: UIButton) {
        guard let phone = numberTF.text else { return }
        FirebaseManager.instance.signUpByPhone(phone: phone)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let phone = numberTF.text else { return }
        //if segue.identifier == "toCode" {
            let nextVC = segue.destination as! VerifyingViewController
            nextVC.phone = phone
            nextVC.isHistory = isHistory
            
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

}
