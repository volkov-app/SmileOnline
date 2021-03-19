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
    
    
    @IBAction func enterTapped(_ sender: UIButton) {
        if photos.count == 5 || nameTF.text == ""{
            
            
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "ClientInfoViewController") as! ClientInfoViewController
            nextVC.photos = photos
            navigationController?.pushViewController(nextVC, animated: true)
        
        
            
        } else {
            let alert = UIAlertController(title: "Вы не загрузили нужное количество фотографий или не ввели имя", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Хорошо", style: .default))
            present(alert, animated: true)
        }
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

override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
}


func sendPhotos() {
    
    //Отправка фотографий на сервер
    let storageRef = self.storage.reference()
    
    let date = DateFormatter()
    date.dateFormat = "dd.MM.yy"
    
    
    let metaData = StorageMetadata()
    metaData.contentType = "image/jpg"
    
    var i = 1
    for photo in photos {
        
        let filePath = "users/\(Auth.auth().currentUser!.uid)/\(nameTF.text!) \(date.string(from: Date(timeIntervalSinceNow: 0)))/photo\(i)"
        let photosRef = storageRef.child(filePath)
        
        var data = Data()
        data = photo.jpegData(compressionQuality: 0.8)!
        i += 1
        
        photosRef.putData(data, metadata: metaData) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                print(error!.localizedDescription)
                return
            }
            // Metadata contains file metadata such as size, content-type.
            let size = metadata.size
            print("photo size: \(size)")
            
            // You can also access to download URL after upload.
            photosRef.downloadURL { (url, error) in
                guard url != nil else {
                    // Uh-oh, an error occurred!
                    print(error!.localizedDescription)
                    return
                }
            }
        }
    }
    
    //Запись клиента в удаленную базу данных
    db.collection("users")
        .document("\(Auth.auth().currentUser!.uid)")
        .collection("clients")
        .document("\(nameTF.text!) \(date.string(from: Date(timeIntervalSinceNow: 0)))")
        .setData([
        "name": nameTF.text!
    ]) { err in
        if let err = err {
            print("Error writing document: \(err.localizedDescription)")
        } else {
            print("Document successfully written!")
            
            let waitingVC = self.storyboard?.instantiateViewController(withIdentifier: "WaitingViewController")
            self.navigationController?.pushViewController(waitingVC!, animated: true)
        }
    }
}
}
