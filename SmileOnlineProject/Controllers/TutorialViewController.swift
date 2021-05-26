//
//  TutorialViewController.swift
//  SmileOnlineProject
//
//  Created by Алексей Волков on 15.03.2021.
//

import UIKit
import Firebase
import YoutubePlayer_in_WKWebView

class TutorialViewController: UIViewController {
    
    @IBOutlet weak var youTubePleyer: WKYTPlayerView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var descriptionArray = ["Специалисты изучат ваши фотографии и составят предварительный план лечения","Специалисты изучат фотографии улыбки вашего клиента и составят предварительный план лечения"]
    
    var isDoctor = false
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? PhotosViewController else { return }
        vc.isDoctor = isDoctor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isDoctor {
            descriptionLabel.text = descriptionArray[1]
        } else {
            descriptionLabel.text = descriptionArray[0]
        }
        
        youTubePleyer.load(withVideoId: "_kxgKzuD7Cg")
    }
}
