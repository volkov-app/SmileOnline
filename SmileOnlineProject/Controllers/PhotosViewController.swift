//
//  PhotosViewController.swift
//  SmileOnlineProject
//
//  Created by Alex Rudoi on 25/2/21.
//

import UIKit
import Firebase

class PhotosViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    
    @IBOutlet weak var loginOut: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var descriptionLable: UILabel!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var nextButtonPressed: UIButton!
    @IBOutlet weak var tutorialButtonPressed: UIButton!
    
    
    var isDoctor = false
    var descriptionArray = ["Отправьте фото улыбки и получите варианты исправления прикуса", "Отправьте фото улыбки вашего клиента и получите варианты исправления прикуса"]
    
    
    
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
        
//        if UserDefaults.standard.string(forKey: "authID") == nil {
//            loginOut.isHidden = true
//        } else { loginOut.isHidden = false}
//        
//        if isDoctor {
//            descriptionLable.text = descriptionArray[1]
//        } else {
//            descriptionLable.text = descriptionArray[0]
//        }
        
        
        //activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        //присваиваем делигаты
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //регистрируем ячейку
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "collectionViewCell")
    }
    
    @IBAction func bezopasnostButton(_ sender: Any) {
        openUrl(urlStr: "https://disk.yandex.ru/d/Vn_zsmabhwWQ1Q")
    }
    
    
    
    @IBAction func logOutPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "Подтверждение", message: "Вы действительно хотите выйти из учетной записи? При выходе потребуется через номер телефона снова входить в приложение", preferredStyle: .alert)
        let alertAction1 = UIAlertAction(title: "Да", style: .default) { (_) in
            
            FirebaseManager.instance.logOut(mainVC: self)
            
        }
            
        let alertAction2 = UIAlertAction(title: "Нет", style: .default) { (_) in
            
            self.tabBarController?.selectedViewController = self.tabBarController?.viewControllers?[0]
            
            
        }
        
        alert.addAction(alertAction1)
        alert.addAction(alertAction2)
        
        self.present(alert, animated: true)
        
        
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
            
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
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
        // filterView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        
        ImagePickerManager(image: filterView).pickImage(self) { (image) in
            
            self.photos[indexPath.row] = image
            
            
            cell.imageView.image = image
            
        }
    }
    //для закрытия клавиатуры
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
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
            FirebaseManager.instance.sendPhotos(photos: photos, cashClientName: nameTF.text!)
            vc = self.storyboard!.instantiateViewController(withIdentifier: "ResultViewController") as! ResultViewController
            
            
        } else {
            //переход на регистрацию
            vc.modalPresentationStyle = .fullScreen
            vc = self.storyboard!.instantiateViewController(withIdentifier: "TypeOfSignInTableViewController")  as! TypeOfSignInTableViewController
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
