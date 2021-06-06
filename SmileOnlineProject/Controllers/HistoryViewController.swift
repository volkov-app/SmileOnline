//
//  HistoryViewController.swift
//  SmileOnlineProject
//
//  Created by Alex Rudoi on 6/3/21.
//

import UIKit
import Firebase

struct Client {
    var name: String
    //    var email: String
    //    var phone: String
    //    var date: Date
    var link: String?
    var hard: String?
    
    
    init(name: String, link: String?, hard: String?) {
        self.name = name
        //        self.email = email
        //        self.phone = phone
        //        self.date = date
        if let hard = hard {
            self.hard = hard
            
        }
        if let link = link {
            self.link = link
        
        }
    }
}

class HistoryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    
    var clients: [String] = []
    var clientsDetails = [Client]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "Назад", style: .plain, target: nil, action: nil)
        
        
        
        callDelegates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if UserDefaults.standard.string(forKey: "authID") == nil {
            
            let alert = UIAlertController(title: "Войдите в приложение", message: "Для просмотра своей истории, вам необходимо войти в приложение или зарегестрироваться", preferredStyle: .alert)
            let alertAction1 = UIAlertAction(title: "Войти/зарегестрироваться", style: .default) { (_) in
                
                
                let vc = self.storyboard!.instantiateViewController(withIdentifier: "SigningViewController") as! SigningViewController
                vc.isHistory = true
                self.navigationController?.present(vc, animated: true)
            }
            
            let alertAction2 = UIAlertAction(title: "Вернуться назад", style: .default) { (_) in
                
                self.tabBarController?.selectedViewController = self.tabBarController?.viewControllers?[0]
                
                
            }
            
            alert.addAction(alertAction1)
            alert.addAction(alertAction2)
            
            self.present(alert, animated: true)
        } else { getData() }
        
        
        
    }
    
    func callDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func getData() {
        clients = []
        clientsDetails = []
        
        let dbRef = db.collection("users").document(Auth.auth().currentUser!.uid).collection("clients").order(by: "date", descending: true)
        dbRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    
                    let data = document.data()
                    
                    self.clients.append(document.documentID)
                    self.clientsDetails.append(Client(name: (data["name"] as? String)!,
                                                      link: data["link"] as? String, hard: data["hard"] as? String))
                
                }
                self.tableView.reloadData()
            }
        }
    }
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as UITableViewCell
        
        //Присваивание данных ячейке
        cell.textLabel?.text = clients[indexPath.row]
        if clientsDetails[indexPath.row].link == nil {
            cell.backgroundColor = #colorLiteral(red: 0.8705882353, green: 0.9607843137, blue: 1, alpha: 1)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let resultVC = storyboard?.instantiateViewController(withIdentifier: "HistoryResultViewController") as! HistoryResultViewController
        resultVC.link = clientsDetails[indexPath.row].link ?? ""
        resultVC.hard = clientsDetails[indexPath.row].hard ?? ""
    
        resultVC.isHistory = true
        navigationController?.pushViewController(resultVC, animated: true)
        
    }
    
    
}
