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
    
    var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.bounds = CGRect(x: 0, y: 0, width: 45, height: 45)
        activity.isHidden = true
        return activity
    }()
    
    //скокращение
    let storage = Storage.storage()
    let db = Firestore.firestore()
    
    //фото для collectionView
    let standartPhotos: [UIImage] = [#imageLiteral(resourceName: "onboarding1"),#imageLiteral(resourceName: "onboarding1"),#imageLiteral(resourceName: "onboarding1"),#imageLiteral(resourceName: "4-removebg-preview"),#imageLiteral(resourceName: "5-removebg-preview")]
    let placeholderPhotos: [UIImage] = [#imageLiteral(resourceName: "1-removebg-preview"),#imageLiteral(resourceName: "3-removebg-preview"),#imageLiteral(resourceName: "2-removebg-preview"),#imageLiteral(resourceName: "4-removebg-preview"),#imageLiteral(resourceName: "5-removebg-preview")]
    //фото загруженное через камеру или галерею
    var photos: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        //присваиваем делигаты
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //регистрируем ячейку
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "collectionViewCell")
    }
    
    //при нажатии кнопки
    @IBAction func enterTapped(_ sender: UIButton) {
        
        //пишем условия
        if nameTF.text == ""{
            
            
            //выводим предупреждение в случае ошибки
            let alert = UIAlertController(title: "Вы не ввели имя", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Хорошо", style: .default))
            present(alert, animated: true)
        
        
            
        } else if photos.count == 5 {
            
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            sendPhotos()
            
        } else {
        
        //выводим предупреждение в случае ошибки
        let alert = UIAlertController(title: "Вы не загрузили все нужные фотографии", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Хорошо", style: .default))
        present(alert, animated: true)
        }
    }
    
    //для создания ячеек
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
        let filterView = UIImageView(image: placeholderPhotos[indexPath.row])
        filterView.center = view.center
       // filterView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        
        ImagePickerManager(image: filterView).pickImage(self) { (image) in
            self.photos.append(image)
            
            cell.imageView.image = image
        }
    }
//для закрытия клавиатуры
override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
}


func sendPhotos() {
    
    //Отправка фотографий на сервер
    let storageRef = self.storage.reference()
    //запоминаем дату
    let date = DateFormatter()
    date.dateFormat = "dd.MM.yy"
    
    //записываем тип фотографии
    let metaData = StorageMetadata()
    metaData.contentType = "image/jpg"
    
    
    var i = 1
    for photo in photos {
        
        
        //показываем путь куда сохранить
        let filePath = "users/\(Auth.auth().currentUser!.uid)/\(nameTF.text!) \(date.string(from: Date(timeIntervalSinceNow: 0)))/photo\(i)"
        let photosRef = storageRef.child(filePath)
        
        //конвертируем тип фотографии в тип Data
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
            
//            activityIndicator.isHidden = true
//            activityIndicator.stopAnimating()
            
            //делаем переход
            let waitingVC = self.storyboard?.instantiateViewController(withIdentifier: "ResultViewController")
            self.present(waitingVC!, animated: true)
        }
    }
}
}
