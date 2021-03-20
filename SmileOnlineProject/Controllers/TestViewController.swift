//
//  TestViewController.swift
//  SmileOnlineProject
//
//  Created by Алексей Волков on 20.03.2021.
//

import UIKit

class TestViewController: UIViewController {


    // Create a value for chosed view
    private var nextViewNumber = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tabBar" {

            let nextView = segue.destination as! UITabBarController

            switch (nextViewNumber) {
            case 1:
                nextView.selectedIndex = 0

            case 2:
                nextView.selectedIndex = 1
            
            case 3:
                nextView.selectedIndex = 2
                
            default:
                break
            }
        }
    }


    @IBAction func FistView(_ sender: UIButton) {
        self.nextViewNumber = 1
        self.performSegue(withIdentifier: "tabBar", sender: self)
    }

    @IBAction func SecontView(_ sender: UIButton) {
        self.nextViewNumber = 2
        self.performSegue(withIdentifier: "tabBar", sender: self)

    }
    }

