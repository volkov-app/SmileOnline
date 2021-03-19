//
//  ClientInfoViewController.swift
//  SmileOnlineProject
//
//  Created by Alex Rudoi on 2/3/21.
//

import UIKit
import Firebase

class ClientInfoViewController: UIViewController {
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    
    let storage = Storage.storage()
    let db = Firestore.firestore()
    
    var photos: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func sendInfo(_ sender: UIButton) {
        if nameTF.text == "" || emailTF.text == "" || phoneTF.text == "" { showAlert() }
        sendPhotos()
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Вы не заполнили все поля", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Хорошо", style: .default))
        present(alert, animated: true)
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
            "name": nameTF.text!,
            "email": emailTF.text!,
            "date":
                date.string(from: Date(timeIntervalSinceNow: 0)),
            "phone": phoneTF.text!
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
/*

@IBAction func tutorialVideo(_ sender: Any) {
    
    guard let url = URL(string: "https://youtu.be/_kxgKzuD7Cg") else { return }
    UIApplication.shared.open(url)
}
*/
