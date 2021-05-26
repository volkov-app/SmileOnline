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
    
    @IBAction func occupationTapped(_ sender: UIButton) {
        var option = false
        switch sender.tag {
        case 0:
            option = false
            break
        case 1:
            option = true
            break
        default:break
        }
        UserDefaults.standard.set(option, forKey: "isDoctor")
    }
    
}
