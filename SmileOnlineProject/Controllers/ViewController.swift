

import UIKit
class ViewController: UIViewController{
    
    @IBOutlet weak var onboadingLabel: UILabel!
    @IBOutlet weak var onboardingImage: UIImageView!
    @IBOutlet weak var onboardingButton: UIButton!
    
    //Данные для онбордига
    var labelArray = ["Привет, меня зовут Смарти! Я помогу тебе с улыбкой.", "Улыбнись! Мне нужно фото твоей улыбки.", "Анализируем твои фото, расписываем твой план лечения.", "Теперь давай запишемся на консультацию."]
    var imageArray = [UIImage(named: "onboarding1"), UIImage(named: "onboarding2"), UIImage(named: "onboarding3"), UIImage(named: "onboarding4")]
    var buttonArray = ["Далее", "Далее","Далее", "Начнём!"]
    
    var indexOnboarding = 0 //стартовая страница онбординга
    
    override func viewDidLoad() {
        
        //создаем онбординг
        onboadingLabel.text = labelArray.first
        onboardingImage.image = imageArray.first!
        onboardingButton.setTitle(buttonArray.first!, for: .normal)
        indexOnboarding += 1
        
        onboardingButton.dropShadow() //Тень для кнопки
    }
    @IBAction func onboardingTapped(_ sender: Any) {
        //прописываем механику онбординга
        if indexOnboarding == labelArray.count {
            let vc = storyboard!.instantiateViewController(withIdentifier: "QuestionsViewController") as! QuestionsViewController
            present(vc, animated: true, completion: nil)
        } else {
            onboadingLabel.text = labelArray[indexOnboarding]
            onboardingImage.image = imageArray[indexOnboarding]
            onboardingButton.setTitle(buttonArray[indexOnboarding], for: .normal)
            indexOnboarding += 1
        }
    }
    
    
    
    
}
