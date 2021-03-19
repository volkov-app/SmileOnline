//
//  MyOnboardingViewController.swift
//  SmileOnlineProject
//
//  Created by Алексей Волков on 18.02.2021.
//

import UIKit

class MyOnboardingViewController: UIViewController {
    @IBOutlet weak var onboardingImage: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var closeBotton: UIButton!
    
    
    var imgs = ["intro1","intro4","intro5"]
    
    var onboardingImage
    
    @IBAction func nextButton(_ sender: Any) {
        
    }
    
    @IBAction func closeBotton(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}
