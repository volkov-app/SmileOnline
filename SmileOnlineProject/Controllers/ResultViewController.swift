//
//  ResultViewController.swift
//  SmileOnlineProject
//
//  Created by Alex Rudoi on 6/3/21.
//

import UIKit

class ResultViewController: UIViewController {
    
    var link = ""
    var hard = ""
    var isHistory = false
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var getPlan: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var hardLabel: UILabel!
    @IBOutlet weak var textDescription: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Делаем красивый текст филд
        timerLabel.layer.borderColor = UIColor.blue.cgColor
        timerLabel.layer.cornerRadius = 5.0
        timerLabel.layer.borderWidth = 1.0
        timerLabel.layer.masksToBounds = true
        
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "Назад", style: .plain, target: nil, action: nil)
        
        startTimer()
        
        if isHistory {
            closeButton.isHidden = true
            timerLabel.isHidden = true
        }
        
        if link == "" {
            getPlan.isHidden = true
            hardLabel.isHidden = true
            
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

    func startTimer(){
        var runCount = 300

        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            runCount -= 1
            //чтобы показать время
            self.timerLabel.text = self.updateTime(count: runCount)
            if runCount == 0 {
                timer.invalidate()
                self.timerLabel.isHidden = true
                print("timer stoped")
                
                if self.link != "" {
                    self.getPlan.isHidden = false
                }
            }
        }
        
        
    }
    
    func updateTime(count: Int) -> String {
        
          let time = count
          
          let hours = time / 3600
          let minutes = time / 60 % 60
          let seconds = time % 60
          
          var times: [String] = []
          if hours > 0 {
            times.append("\(hours)h")
        
          }
        
          if minutes > 0 {
            times.append("\(minutes):")
          }
        if seconds >= 10 {
            times.append("\(seconds)")
        } else {
        times.append("0\(seconds)")
        }
          return times.joined(separator: "")
        }
    
    


}
