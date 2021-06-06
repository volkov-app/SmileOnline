//
//  MenuTableViewController.swift
//  SmileOnlineProject
//
//  Created by Алексей Волков on 22.05.2021.
//

import UIKit

class MenuTableViewController: UITableViewController {
    
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    
    let heights: [CGFloat] = [209,108,56,41,41,41,41,155]
    var descriptionArray = ["Статус - Доктор", "Статус - Пациент"]
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        signInButton.dropShadow()
        
        
        if UserDefaults.standard.string(forKey: "isDoctor") == nil {
            statusButton.setTitle(descriptionArray[0], for: .normal)
                } else {
                    statusButton.setTitle(descriptionArray[1], for: .normal)
                }
        
    }
    
    
    @IBAction func signInButton(_ sender: Any) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "TypeOfSignInTableViewController") as! TypeOfSignInTableViewController
        vc.isHistory = true
        self.navigationController?.present(vc, animated: true)
        
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
    
    @IBAction func logOutPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "Подтверждение", message: "Вы действительно хотите выйти из учетной записи? При выходе потребуется через номер телефона снова входить в приложение", preferredStyle: .alert)
        let alertAction1 = UIAlertAction(title: "Да", style: .default) { (_) in
            
            FirebaseManager.instance.logOut(mainVC: self)
            
        }
            
        let alertAction2 = UIAlertAction(title: "Нет", style: .default) { (_) in
            
            self.tabBarController?.selectedViewController = self.tabBarController?.viewControllers?[0]
            
            
        }
        
        alert.addAction(alertAction1)
        alert.addAction(alertAction2)
        
        self.present(alert, animated: true)
        
        
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
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 8
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UserDefaults.standard.string(forKey: "authID") != nil {
            if indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 5 { return 0 } else { return heights[indexPath.row] }
        } else {if indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 6 { return 0 } else { return heights[indexPath.row] }}
    }
    
}
