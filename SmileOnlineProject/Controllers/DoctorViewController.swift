//
//  imDoctorViewController.swift
//  SmileOnlineProject
//
//  Created by Алексей Волков on 23.03.2021.
//

import UIKit
import Firebase

class DoctorViewController: UIViewController {
    
    private var nextViewNumber = Int()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        guard let vc = segue.destination as? TutorialViewController else { return }
//
//    }
    
    
    
    @IBAction func takePhoto(_ sender: UIButton) {
        
        
    }
    
    @IBAction func SmartCheck(_ sender: Any) {  openUrl(urlStr: "https://smileonline.ru/")
    }
    
    
    @IBAction func videoKurs(_ sender: UIButton) {  openUrl(urlStr: "https://evastom.ru/")
    }
    
    
    @IBAction func lower(_ sender: UIButton) { openUrl(urlStr: "https://smileonline.ru/library")
    }
    
    
    func openUrl(urlStr:String!) {
        
        if let url = URL(string:urlStr) {
            UIApplication.shared.openURL(url)
        }
        
        
    }
}
