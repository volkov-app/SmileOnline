//
//  MenuViewController.swift
//  Pods
//
//  Created by Алексей Волков on 20.05.2021.
//

import UIKit

class MenuViewController: UIViewController {

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func historyButtonPressed(_ sender: Any) {
    }
    
    @IBAction func bookButtonPressed(_ sender: Any) {
        openUrl(urlStr: "https://smileonline.ru/vebinar2")
    }
    
    @IBAction func adminConcoleButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func logOutButtonPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "Подтверждение", message: "Вы действительно хотите выйти из учетной записи? При выходе потребуется через номер телефона снова входить в приложение", preferredStyle: .alert)
        let alertAction1 = UIAlertAction(title: "Да", style: .default) { (_) in
            
            FirebaseManager.instance.logOut(mainVC: self)
            
    }
    }
    
    @IBAction func callButton(_ sender: Any) { dialNumber(number: "+79313605280" )
    }
    @IBAction func telegramButton(_ sender: Any) { openUrl(urlStr: "https://t.me/eva_klinik")
    }
    @IBAction func instagramButton(_ sender: Any) { openUrl(urlStr: "https://www.instagram.com/doctor_antipova")
    }
    @IBAction func whatupButton(_ sender: Any) {openUrl(urlStr: "https://wa.me/+79313605280?text=urlencodedtext")
    }
    
    func openUrl(urlStr:String!) {
        
        if let url = URL(string:urlStr) {
            UIApplication.shared.openURL(url)
        }
        
        
    }
    func dialNumber(number : String) {

     if let url = URL(string: "tel://\(number)"),
       UIApplication.shared.canOpenURL(url) {
          if #available(iOS 10, *) {
            UIApplication.shared.open(url, options: [:], completionHandler:nil)
           } else {
               UIApplication.shared.openURL(url)
           }
       } else {
                // add error message here
       }
    }

}
