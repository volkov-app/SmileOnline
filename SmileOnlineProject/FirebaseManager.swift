//
//  FirebaseManager.swift
//  SmileOnlineProject
//
//  Created by Алексей Волков on 08.04.2021.
//

import Foundation
import Firebase

class FirebaseManager {
    
    //скокращение
    let storage = Storage.storage()
    let db = Firestore.firestore()
    let firebaseAuth = Auth.auth()
    
    static var instance = FirebaseManager()

    func sendPhotos(photos: [UIImage], cashClientName: String) {
        
        //Отправка фотографий на сервер
        let storageRef = self.storage.reference()
        //запоминаем дату
        let date = DateFormatter()
        date.dateFormat = "dd.MM.yy"
        
        //записываем тип фотографии
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        var i = 0
        
        for photo in photos {
            
            
            //показываем путь куда сохранить
            let filePath = "users/\(Auth.auth().currentUser!.uid)/\(cashClientName) \(date.string(from: Date(timeIntervalSinceNow: 0)))/photo\(i)"
            let photosRef = storageRef.child(filePath)
            
            //конвертируем тип фотографии в тип Data
            var data = Data()
            data = photo.jpegData(compressionQuality: 0.8)!
            i += 1
            
            UserDefaults.standard.set(data, forKey: "photo\(i)")
            
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
            .document("\(cashClientName) \(date.string(from: Date(timeIntervalSinceNow: 0)))")
            .setData([
                "name": cashClientName,
                "date": date.string(from: Date(timeIntervalSinceNow: 0))
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err.localizedDescription)")
                } else {
                    print("Document successfully written!")
                    
                }
            }
    }

    func logOut(mainVC: UIViewController) {
        
        
        do {
          try firebaseAuth.signOut()
            
            UserDefaults.standard.setValue(nil, forKey: "authID")
            let vc = mainVC.storyboard!.instantiateViewController(withIdentifier: "statusNC")
            vc.modalPresentationStyle = .fullScreen
            mainVC.present(vc, animated: true, completion: nil)
            
            
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
    
    func signUpByPhone(phone: String){
        
        UserDefaults.standard.set(phone, forKey: "phoneNumber")
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phone, uiDelegate: nil) { (verificationID, error) in
          if let error = error {
            print(error.localizedDescription)
            
            return
          }
          // Sign in using the verificationID and the code sent to the user
          // ...
          UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
          print("No error")
        }
    }
 
    
    func loginByVerificationCode(verificationCode: String, phone: String, mainVC: UIViewController, isHistory: Bool) {
        
        UserDefaults.standard.set(verificationCode, forKey: "authVerificationCode")
        
        guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else { return }

        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: verificationCode)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                let authError = error as NSError
                if (authError.code == AuthErrorCode.secondFactorRequired.rawValue) {
                    // The user is a multi-factor user. Second factor challenge is required.
                    let resolver = authError.userInfo[AuthErrorUserInfoMultiFactorResolverKey] as! MultiFactorResolver
                    var displayNameString = ""
                    for tmpFactorInfo in (resolver.hints) {
                        displayNameString += tmpFactorInfo.displayName ?? ""
                        displayNameString += " "
                    }
                    
                } else {
                    let alert = UIAlertController(title: "Неверный код", message: "Проверьте правильность или запросите новый", preferredStyle: .alert)
                    let alertAction1 = UIAlertAction(title: "ОК", style: .default)
                    let alertAction2 = UIAlertAction(title: "Отправить повторно", style: .default) { (_) in
                        self.signUpByPhone(phone: phone)
                        
                    }
                    alert.addAction(alertAction1)
                    alert.addAction(alertAction2)
                    
                    mainVC.present(alert, animated: true)
                    
                    print(error.localizedDescription)
                    return
                }
                // ...
                return
            }
            
            
            
            
            
            print(authResult!.user.uid)
            UserDefaults.standard.set( authResult!.user.uid, forKey: "authID")
            
            if isHistory {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CustomTabBarViewController") as! UITabBarController
                vc.modalPresentationStyle = .fullScreen
                vc.selectedIndex = 2
                mainVC.present(vc, animated: true)
                
                
            } else {
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SendPhotoController") as! SendPhotoController
            vc.modalPresentationStyle = .fullScreen
            mainVC.present(vc, animated: true)
            }
            
        }
    }
    func downloadPhotos(user: String, client: String) -> [UIImage] {
        // Create a reference to the file you want to download
        var photos: [UIImage] = []
        for fileNum in 0...4 {
            let islandRef = storage.reference(withPath: "users/\(user)/\(client)/photo\(fileNum).jpg")
            // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
            islandRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
              if let error = error {
                print(error.localizedDescription)
                // Uh-oh, an error occurred!
              } else {
                // Data for "images/island.jpg" is returned
                let image = UIImage(data: data!)
                photos.append(image!)
              }
                
            }
        }
        return photos
        
    }
}
