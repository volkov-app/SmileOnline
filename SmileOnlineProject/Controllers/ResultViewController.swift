//
//  ResultViewController.swift
//  SmileOnlineProject
//
//  Created by Alex Rudoi on 6/3/21.
//

import UIKit

class ResultViewController: UIViewController {
    
    var link = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if link == "" {
            //Кнопки нет. Надпись что план лечения еще не готов
        }
    }
    @IBAction func getPlanTapped(_ sender: UIButton) {
        if let url = URL(string: link){
            UIApplication.shared.openURL(url)
        }
    }

    @IBAction func callButton(_ sender: Any) { dialNumber(number: "+921111111222" )
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




// Create a value for chosed view
private var nextViewNumber = Int()


override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "tabBar" {

        let nextView = segue.destination as! UITabBarController

        switch (nextViewNumber) {
        case 1:
            nextView.selectedIndex = 0

        case 2:
            nextView.selectedIndex = 1
        
        case 3:
            nextView.selectedIndex = 2
            
        default:
            break
        }
    }
}


@IBAction func FistView(_ sender: UIButton) {
    self.nextViewNumber = 3
    self.performSegue(withIdentifier: "tabBar", sender: self)
}


}
