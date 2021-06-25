//
//  SendPhotoController.swift
//  SmileOnlineProject
//
//  Created by Алексей Волков on 06.04.2021.
//

import UIKit
import SVProgressHUD

class SendPhotoController: UIViewController {
    
    @IBOutlet weak var nextButton: UIButton!
    
    
    //фото загруженное через камеру или галерею
    var photos: [UIImage] = []
    
    var cashClientName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.dropShadow()
        
        cashClientName = UserDefaults.standard.string(forKey: "cashClientName")!
        
        for i in 1...5 {
            let photo = UIImage(data: UserDefaults.standard.data(forKey: "photo\(i)" )!)
            photos.append(photo!)
        }
        
    }
    
    
    @IBAction func sendPhotoPressed(_ sender: Any) {
        
        SVProgressHUD.show()
        var isTransitioned = false
        FirebaseManager.instance.sendPhotos(photos: photos, cashClientName: cashClientName) { _ in
            if isTransitioned == false {
                isTransitioned = true
                let vc = self.storyboard!.instantiateViewController(withIdentifier: "ResultViewController") as! ResultViewController
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        
        
    }
    

    
    
}
