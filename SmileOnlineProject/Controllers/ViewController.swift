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
    
    var labelArray = ["Сделайте фотографию зубов", "Специалисты изучат ваши фотографии и составят предварительный план лечения", "Затем мы проведем онлайн консультацию с врачем ортодонтом"]
    var imageArray = [UIImage(named: "onboarding1"), UIImage(named: "onboarding2"), UIImage(named: "onboarding3")]
    var buttonArray = ["Далее", "Далее", "Войти"]
    
    var indexOnboarding = 0
    
    override func viewDidLoad() {
        
        
        
        onboadingLabel.text = labelArray.first
        onboardingImage.image = imageArray.first!
        onboardingButton.setTitle(buttonArray.first!, for: .normal)
        indexOnboarding += 1
//        
//        if UserDefaults.standard.string(forKey: "authID") != nil {
//        
//            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "QuestionsViewController") as! QuestionsViewController
//            vc.modalPresentationStyle = .fullScreen
//            self.present(vc, animated: true)
//        }
        
    }
    @IBAction func onboardingTapped(_ sender: Any) {
        
        if indexOnboarding == labelArray.count {
            let vc = storyboard!.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
            present(vc, animated: true, completion: nil)
        } else {
            onboadingLabel.text = labelArray[indexOnboarding]
            onboardingImage.image = imageArray[indexOnboarding]
            onboardingButton.setTitle(buttonArray[indexOnboarding], for: .normal)
            indexOnboarding += 1
        }
    }
    
    
    
    
}
