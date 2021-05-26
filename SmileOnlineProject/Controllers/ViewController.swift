

import UIKit

struct Onboard {
    var label: String
    var image: UIImage
    var buttonName: String
}

class ViewController: UIViewController{
    
    @IBOutlet weak var onboadingLabel: UILabel!
    @IBOutlet weak var onboardingImage: UIImageView!
    @IBOutlet weak var onboardingButton: UIButton!
    
    //Данные для онбордига
    var onboards: [Onboard] = [Onboard(label: "Привет, меня зовут Смарти! Я помогу тебе с улыбкой.", image: UIImage(named: "onboarding1")!, buttonName: "Далее"),
                               Onboard(label: "Улыбнись! Мне нужно фото твоей улыбки.", image: UIImage(named: "onboarding2")!, buttonName: "Далее"),
                               Onboard(label: "Анализируем твои фото, расписываем твой план лечения.", image: UIImage(named: "onboarding3")!, buttonName: "Далее"),
                               Onboard(label: "Теперь давай запишемся на консультацию.", image: UIImage(named: "onboarding4")!, buttonName: "Начнём!")]
    
    var indexOnboarding = 0 //стартовая страница онбординга
    
    override func viewDidLoad() {
        
        guard let firstOnboard = onboards.first else { return }
        
        //создаем онбординг
        onboadingLabel.text = firstOnboard.label
        onboardingImage.image = firstOnboard.image
        onboardingButton.setTitle(firstOnboard.buttonName, for: .normal)
        indexOnboarding += 1
        
        onboardingButton.dropShadow() //Тень для кнопки
    }
    @IBAction func onboardingTapped(_ sender: Any) {
        //прописываем механику онбординга
        if indexOnboarding == onboards.count {
            let vc = storyboard!.instantiateViewController(withIdentifier: "statusNC")
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
            
        } else {
            onboadingLabel.text = onboards[indexOnboarding].label
            onboardingImage.image = onboards[indexOnboarding].image
            onboardingButton.setTitle(onboards[indexOnboarding].buttonName, for: .normal)
            indexOnboarding += 1
        }
    }
    
    
    
    
}
