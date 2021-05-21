//
//  imDoctorViewController.swift
//  SmileOnlineProject
//
//  Created by Алексей Волков on 23.03.2021.
//

import UIKit
import Firebase

class DoctorViewController: UIViewController {
    
    
    @IBOutlet weak var loginOutButton: UIButton!
    @IBOutlet weak var adminButton: UIButton!
    var isDoctor = true
    
    private var nextViewNumber = Int()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if UserDefaults.standard.string(forKey: "authID") == nil {
            loginOutButton.isHidden = true
            adminButton.isHidden = true
        } else { loginOutButton.isHidden = false
            
            if UserDefaults.standard.string(forKey: "authID") == "pym8q5kuZjVaIan3QHs0A4EIzhg1" {
                adminButton.isHidden = false
            } else { adminButton.isHidden = true }
        }
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let vc = segue.destination as? TutorialViewController else { return }
        vc.isDoctor = isDoctor
        
        
    }
    
    
    
    @IBAction func takePhoto(_ sender: UIButton) {
        
        
    }
    
    
    
    @IBAction func videoKurs(_ sender: UIButton) {  openUrl(urlStr: "https://smileonline.ru/library")
    }
    
    
    @IBAction func lower(_ sender: UIButton) { openUrl(urlStr: "https://t.me/eva_klinik")
    }
    
    
    func openUrl(urlStr:String!) {
        
        if let url = URL(string:urlStr) {
            UIApplication.shared.openURL(url)
        }
        
        
    }
}
