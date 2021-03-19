//
//  ViewController.swift
//  SmileOnlineProject
//
//  Created by Алексей Волков on 17.02.2021.
//

import UIKit
class ViewController: UIViewController{
    
    @IBOutlet weak var onboadingLabel: UILabel!
    @IBOutlet weak var onboardingImage: UIImageView!
    @IBOutlet weak var onboardingButton: UIButton!
    
    var labelArray = ["test1", "test2", "test3", "test4"]
    var imageArray = [UIImage(named: "intro1"), UIImage(named: "intro2"), UIImage(named: "intro3"), UIImage(named: "intro4")]
    var buttonArray = ["Далее", "Далее", "Далее", "Войти"]
    
    var indexOnboarding = 0
    
        override func viewDidLoad() {
            onboadingLabel.text = labelArray.first
            onboardingImage.image = imageArray.first!
            onboardingButton.setTitle(buttonArray.first!, for: .normal)
            indexOnboarding += 1
        }
    @IBAction func onboardingTapped(_ sender: Any) {
        
        if indexOnboarding == labelArray.count {
            let vc = storyboard!.instantiateViewController(withIdentifier: "SigningViewController") as! SigningViewController
            present(vc, animated: true, completion: nil)
        } else {
        onboadingLabel.text = labelArray[indexOnboarding]
        onboardingImage.image = imageArray[indexOnboarding]
        onboardingButton.setTitle(buttonArray[indexOnboarding], for: .normal)
        indexOnboarding += 1
        }
    }
    
    
    
    
}
