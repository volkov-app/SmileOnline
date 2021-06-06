//
//  AdminConcoleDetail.swift
//  SmileOnlineProject
//
//  Created by Алексей Волков on 16.04.2021.
//

import UIKit
import Firebase
import Alamofire

class AdminConcoleDetail: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    
    
    
    @IBOutlet weak var hardTF: UITextField!
    @IBOutlet weak var linkTF: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var sendButton: UIButton!
    
    
    //скокращение
    let storage = Storage.storage()
    let db = Firestore.firestore()
    let toolBar = UIToolbar()
    var user = ""
    var client = ""
    let tipeOfHard = ["Легко", "Просто", "Сложно"]
    
    //фото для collectionView
    var standartPhotos: [UIImage] = [#imageLiteral(resourceName: "tutor1"),#imageLiteral(resourceName: "tutor2"),#imageLiteral(resourceName: "tutor3"),#imageLiteral(resourceName: "tutor5"),#imageLiteral(resourceName: "tutor4")]
    
    //фото загруженное через камеру или галерею
    var photos: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // standartPhotos = FirebaseManager.instance.downloadPhotos(user: user, client: client)
        // var photos: [UIImage] = []
        //        downloadPhotos()
        picker.isHidden = true
        
        
        //присваиваем делигаты
        collectionView.delegate = self
        collectionView.dataSource = self
        picker.delegate = self
        picker.dataSource = self
        
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Готово", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        hardTF.inputView = picker
        hardTF.inputAccessoryView = toolBar
        
        
        
        
        //регистрируем ячейку
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "collectionViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        downloadPhotos()
    }
    
    //для создания ячеек
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! CollectionViewCell
        
        cell.imageView.image = photos[indexPath.row]
        
        return cell
    }
    
    //для закрытия клавиатуры
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return tipeOfHard.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return tipeOfHard[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        hardTF.text = tipeOfHard[row]
    }
    
    @objc func donePicker(){
        picker.resignFirstResponder()
        picker.isHidden = true
        hardTF.resignFirstResponder()
    }
    
    @IBAction func hardTFPressed(_ sender: Any) {
        picker.becomeFirstResponder()
        picker.isHidden = false
    }
    
    
    @IBAction func buttonTapped(_ sender: Any) {
        guard let link = linkTF.text else { return }
        guard let hard = hardTF.text else { return }
        //Запись клиента в удаленную базу данных
        db.collection("users")
            .document("\(user)")
            .collection("clients")
            .document("\(client)")
            .updateData([
                "link": link,
                "hard": hard
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err.localizedDescription)")
                } else {
                    print("Document successfully written!")
                    
                    self.sendNotification()
                    self.sendButton.isHidden = true
                }
            }
        
    }
    func sendNotification() {
        let docRef = db.collection("users").document("\(user)")
        var token = ""
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()!
                print("Document data: \(dataDescription)")
                token = dataDescription["token"] as! String
            } else {
                print("Document does not exist")
            }
        }
        //Отправляем сообщение
        
        guard let url = URL(string: "https://fcm.googleapis.com/fcm/send") else {
            fatalError("Pastebin URL not working")
        }
        
        let notification: [String: Any] = [
            "title": "your plan is done",
            "body": "go check your app"
        ]
        
        let params: [String: Any] = [
            "notification": notification,
            "to": token
        ]
        
        var headers = HTTPHeaders()
        headers.add(HTTPHeader(name: "Content-type", value: "application/json"))
        headers.add(HTTPHeader(name: "Authorization", value: "Key=AAAAH5KYAcs:APA91bFTQGKFO7pV8cxKSlpCyRxz46G64UNsm63uUBSccSBVFtySaNue-rf2GzZRsy8NZv56Q3lgdswbM3Y9LQtaawh2f33UQScTn2nfqkapvi4NqiVm_EHFnwLhdKx3UdWQIBC0DS5f"))
        
        
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            
            case .success(let data):
                
                print("data: \(data)")
                print("params: \(params)")
            case .failure(let error):
                
                print("Request failed with error: \(error)")
            }
        }
        
        
    }
    
    func downloadPhotos() {
        for fileNum in 0...4 {
            let islandRef = storage.reference(withPath: "users/\(user)/\(client)/photo\(fileNum)")
            //            islandRef.downloadURL { (url, error) in
            //                if let error = error {
            //                  print(error.localizedDescription)
            //
            //                } else {
            //                    let imageView = UIImageView()
            //
            //
            //                    imageView.downloaded(from: url!)
            //                    self.photos.append(imageView.image!)
            //                }
            //            }
            islandRef.getData(maxSize: 1 * 2048 * 2048) { data, error in
                if let error = error {
                    print(error.localizedDescription)
                    // Uh-oh, an error occurred!
                } else {
                    // Data for "images/island.jpg" is returned
                    let image = UIImage(data: data!)
                    self.photos.append(image!)
                    self.collectionView.reloadData()
                }
                
            }
            
        }
        
    }
}

