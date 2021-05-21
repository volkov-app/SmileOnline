//
//  AdminConcole.swift
//  SmileOnlineProject
//
//  Created by Алексей Волков on 13.04.2021.
//

import UIKit
import Firebase


class AdminConcole: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    
    var clients: [String] = []
    var clientsDetails = [Client]()
    var clientsID: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        
        
        
        callDelegates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
      /*  if UserDefaults.standard.string(forKey: "authID") == nil {
            
            let alert = UIAlertController(title: "Войдите в приложение", message: "Для просмотра своей истории, вам необходимо войти в приложение или зарегестрироваться", preferredStyle: .alert)
            let alertAction1 = UIAlertAction(title: "Войти/зарегестрироваться", style: .default) { (_) in
                
                
                let vc = self.storyboard!.instantiateViewController(withIdentifier: "SigningViewController") as! SigningViewController
            
                    self.navigationController?.present(vc, animated: true)
            }
                
            let alertAction2 = UIAlertAction(title: "Вернуться назад", style: .default) { (_) in
                
                self.tabBarController?.selectedViewController = self.tabBarController?.viewControllers?[0]
                
                
            }
            
            alert.addAction(alertAction1)
            alert.addAction(alertAction2)
            
            self.present(alert, animated: true)
        } else { getData() }
        
 */
       // guard UserDefaults.standard.string(forKey: "authID") != nil else { return }
            
        
    }
    
    func callDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func getData() {
        clients = []
        clientsDetails = []
        clientsID = []
        
        let dbRef = db.collection("users") //сокращение
        dbRef.getDocuments() { (querySnapshot, err) in //запрашиваем документы из коллекции user
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
               for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())") // принтим чтобы просто порверить
                    
         let data = document.data()
                    
                    self.clients.append(data["number"] as! String)
                self.clientsID.append(document.documentID)
//
            
//                    let dateFormatter = DateFormatter()
//                    dateFormatter.dateFormat = "dd.MM.yy"
//                    guard let dateFromCloud = data["date"] else { return }
//                    guard let date = dateFormatter.date(from: dateFromCloud as! String) else { return }
//
//                    self.clientsDetails.append(Client(name: (data["name"] as? String)!,
////                                                      email: (data["email"] as? String)!,
////                                                      phone: (data["phone"] as? String)!,
////                                                      date: date,
//                                                      link: data["link"] as? String))
                }
                self.tableView.reloadData()
            }
        }
    }
}

extension AdminConcole: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as UITableViewCell
        
        //Присваивание данных ячейке
        cell.textLabel?.text = clients[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "AdminConcoleClients") as! AdminConcoleClients
        nextVC.user = clientsID[indexPath.row]
        
        navigationController?.pushViewController(nextVC, animated: true)
    
    }
    
    
}

