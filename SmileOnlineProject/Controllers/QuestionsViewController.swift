//
//  TestViewController.swift
//  SmileOnlineProject
//
//  Created by Алексей Волков on 20.03.2021.
//

import UIKit
import Firebase

class QuestionsViewController: UIViewController {

    
    
private var nextViewNumber = Int()

override func viewDidLoad() {
    super.viewDidLoad()
    Messaging.messaging().token { token, error in
      if let error = error {
        print("Error fetching FCM registration token: \(error)")
      } else if let token = token {
        print("FCM registration token: \(token)")
      }
    }
    
}
    
    
    @IBAction func imPacient(_ sender: Any) {
        UserDefaults.standard.set( false, forKey: "isDoctor")
    }
    @IBAction func imDoctor(_ sender: Any) {
        UserDefaults.standard.set( true, forKey: "isDoctor")
    }
    
}
