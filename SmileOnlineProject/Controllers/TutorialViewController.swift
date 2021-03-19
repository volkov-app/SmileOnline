//
//  TutorialViewController.swift
//  SmileOnlineProject
//
//  Created by Алексей Волков on 15.03.2021.
//

import UIKit
import YoutubePlayer_in_WKWebView

class TutorialViewController: UIViewController {
    
    @IBOutlet weak var youTubePleyer: WKYTPlayerView!
    
    
    
override func viewDidLoad() {
        super.viewDidLoad()
    youTubePleyer.load(withVideoId: "_kxgKzuD7Cg")
    }
    
    


}
