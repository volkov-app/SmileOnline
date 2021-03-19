//
//  PhotosViewController.swift
//  SmileOnlineProject
//
//  Created by Alex Rudoi on 25/2/21.
//

import UIKit
import Firebase

class PhotosViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var nameTF: UITextField!
    
    
    let storage = Storage.storage()
    let db = Firestore.firestore()
    
    let standartPhotos: [UIImage] = [#imageLiteral(resourceName: "1-removebg-preview"),#imageLiteral(resourceName: "3-removebg-preview"),#imageLiteral(resourceName: "2-removebg-preview"),#imageLiteral(resourceName: "4-removebg-preview"),#imageLiteral(resourceName: "5-removebg-preview")]
    var photos: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "collectionViewCell")
    }
    /*
    
    @IBAction func tutorialVideo(_ sender: Any) {
        
        guard let url = URL(string: "https://youtu.be/_kxgKzuD7Cg") else { return }
        UIApplication.shared.open(url)
    }
    */
    
    @IBAction func enterTapped(_ sender: UIButton) {
        if photos.count == 5 || nameTF.text == ""{
            
            
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "ClientInfoViewController") as! ClientInfoViewController
            nextVC.photos = photos
            navigationController?.pushViewController(nextVC, animated: true)
        
        
            
        } else {
            let alert = UIAlertController(title: "Вы не загрузили нужное количество фотографий", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Хорошо", style: .default))
            present(alert, animated: true)
        }
    }
    
    func sendPhoto(_ photos: [UIImage]) {
        // send photos to the next screen
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
     
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! CollectionViewCell
        
        cell.imageView.image = standartPhotos[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
        let filterView = UIImageView(image: standartPhotos[indexPath.row])
        filterView.center = view.center
       // filterView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        
        ImagePickerManager(image: filterView).pickImage(self) { (image) in
            self.photos.append(image)
            
            cell.imageView.image = image
        }
    }
    
    func dialNumber(number : String) {

     if let url = URL(string: "tel://\(number)"),
       UIApplication.shared.canOpenURL(url) {
          if #available(iOS 10, *) {
            UIApplication.shared.open(url, options: [:], completionHandler:nil)
           } else {
               UIApplication.shared.openURL(url)
           }
       } else {
                // add error message here
       }
    }
    
}

