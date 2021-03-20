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
    
    init(name: String, link: String?) {
        self.name = name
//        self.email = email
//        self.phone = phone
//        self.date = date
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
        callDelegates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
    }
    
    func callDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func getData() {
        clients = []
        clientsDetails = []
        
        let dbRef = db.collection("users").document(Auth.auth().currentUser!.uid).collection("clients")
        dbRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    
         let data = document.data()
                    
                    self.clients.append(document.documentID)
//
//                    let dateFormatter = DateFormatter()
//                    dateFormatter.dateFormat = "dd.MM.yy"
//                    guard let dateFromCloud = data["date"] else { return }
//                    guard let date = dateFormatter.date(from: dateFromCloud as! String) else { return }
//
                    self.clientsDetails.append(Client(name: (data["name"] as? String)!,
//                                                      email: (data["email"] as? String)!,
//                                                      phone: (data["phone"] as? String)!,
//                                                      date: date,
                                                      link: data["link"] as? String))
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let resultVC = storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as! ResultViewController
        resultVC.link = clientsDetails[indexPath.row].link ?? ""
        navigationController?.pushViewController(resultVC, animated: true)
    
    }
    
    
}
