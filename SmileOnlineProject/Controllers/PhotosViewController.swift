//
//  PhotosViewController.swift
//  SmileOnlineProject
//
//  Created by Alex Rudoi on 25/2/21.
//

import UIKit
import Firebase
import SVProgressHUD

class PhotosViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var descriptionLable: UILabel!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var nextButtonPressed: UIButton!
    @IBOutlet weak var tutorialButtonPressed: UIButton!
    
    
    var isDoctor = false
    var descriptionArray = ["Отправьте фото улыбки и получите варианты исправления прикуса", "Отправьте фото улыбки вашего клиента и получите варианты исправления прикуса"]
    
    //скокращение
    let storage = Storage.storage()
    let db = Firestore.firestore()
    
    //фото для collectionView
    let standartPhotos: [UIImage] = [#imageLiteral(resourceName: "tutor1"),#imageLiteral(resourceName: "tutor2"),#imageLiteral(resourceName: "tutor3"),#imageLiteral(resourceName: "tutor5"),#imageLiteral(resourceName: "tutor4"),#imageLiteral(resourceName: "tutor6")]
   let placeholderPhotos: [UIImage] = [#imageLiteral(resourceName: "tutorPh1"),#imageLiteral(resourceName: "tutorPh2"),#imageLiteral(resourceName: "tutorPh3"),#imageLiteral(resourceName: "tutorPh4"),#imageLiteral(resourceName: "tutorPh5"),#imageLiteral(resourceName: "tutorPh6")]
    
    
    //фото загруженное через камеру или галерею
    var photos: [UIImage] = [#imageLiteral(resourceName: "tutorPh1"),#imageLiteral(resourceName: "tutorPh2"),#imageLiteral(resourceName: "tutorPh3"),#imageLiteral(resourceName: "tutorPh4"),#imageLiteral(resourceName: "tutorPh5"),#imageLiteral(resourceName: "tutorPh6")]
    
    override func viewDidLoad() {
        
        nextButtonPressed.dropShadow()
        tutorialButtonPressed.dropShadow()
        tutorialButtonPressed.layer.shadowColor = UIColor.yellow.cgColor
        nameTF.textFieldUI()
        
        super.viewDidLoad()
        UserDefaults.standard.set( false, forKey: "isBurger")
        
        //присваиваем делигаты
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //регистрируем ячейку
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "collectionViewCell")
        
    }
    
    @IBAction func bezopasnostButton(_ sender: Any) {
        openUrl(urlStr: "https://disk.yandex.ru/d/Vn_zsmabhwWQ1Q")
    }
    
    
    func isAllPhotos () -> Bool {
        var index = 0
        var bool = true
        
        for photo in photos {
            if photo == placeholderPhotos[index] {
                bool = false
            }
            index += 1
        }
        return bool
        
        
    }
    
    //при нажатии кнопки
    @IBAction func enterTapped(_ sender: UIButton) {
        
        
        //пишем условия
        if nameTF.text == ""{
            
            
            //выводим предупреждение в случае ошибки
            let alert = UIAlertController(title: "Вы не ввели имя", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Хорошо", style: .default))
            present(alert, animated: true)
            
            
            
        } else if isAllPhotos() {
            
            SVProgressHUD.show()
            savePhotos()
            
            
        } else {
            
            //выводим предупреждение в случае ошибки
            let alert = UIAlertController(title: "Вы не загрузили все нужные фотографии", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Хорошо", style: .default))
            present(alert, animated: true)
        }
    }
    
    //для создания ячеек
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
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
        
        
        ImagePickerManager(image: filterView).pickImage(self) { (image) in
            
            self.photos[indexPath.row] = image
            
            
            cell.imageView.image = image
            
        }
    }
    //для закрытия клавиатуры
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    


    func openUrl(urlStr:String!) {
        
        if let url = URL(string:urlStr) {
            UIApplication.shared.openURL(url)
        }
        
        
    }
    
    func savePhotos() {
        
        var i = 1
        for photo in photos {
            
            //конвертируем тип фотографии в тип Data
            var data = Data()
            data = photo.jpegData(compressionQuality: 0.8)!
            
            UserDefaults.standard.set(data, forKey: "photo\(i)")
            i += 1
        }
        UserDefaults.standard.set(nameTF.text, forKey: "cashClientName")
        
        var vc = UIViewController()
        
        if UserDefaults.standard.string(forKey: "authID") != nil {
            
            //Переход на экран результата
            var isTransitioned = false
            FirebaseManager.instance.sendPhotos(photos: photos, cashClientName: nameTF.text!) { result in
                if result == true {
                    vc = self.storyboard!.instantiateViewController(withIdentifier: "ResultViewController") as! ResultViewController
                    if isTransitioned == false {
                        isTransitioned = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                        
                    
                } else {
                    let alert = UIAlertController(title: "При загрузке произошла ошибка. Попробуйте позже", message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Хорошо", style: .default))
                    self.present(alert, animated: true)
                }
            }
        } else {
            //переход на регистрацию
            SVProgressHUD.dismiss()
            vc = self.storyboard!.instantiateViewController(withIdentifier: "SigningViewController")  as! SigningViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
