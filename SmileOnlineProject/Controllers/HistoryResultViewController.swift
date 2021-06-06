//
//  ResultViewController.swift
//  SmileOnlineProject
//
//  Created by Alex Rudoi on 6/3/21.
//

import UIKit

class HistoryResultViewController: UIViewController {
    
    var link = ""
    var hard = ""
    var isHistory = false
    @IBOutlet weak var getPlan: UIButton!
    @IBOutlet weak var hardLabel: UILabel!
    @IBOutlet weak var textDescription: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "Назад", style: .plain, target: nil, action: nil)
        
        if link == "" {
            getPlan.isHidden = true
            hardLabel.isHidden = true
            textDescription.text = "План лечения еще не готов. Необходимо немного подождать"
            
        } else {
            hardLabel.text = "Сложность личения: \(hard)"
        }
    }
    
    @IBAction func getPlanTapped(_ sender: UIButton) {
        if let url = URL(string: link){
            UIApplication.shared.openURL(url)
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
       }
    }

// Create a value for chosed view
private var nextViewNumber = Int()

}
