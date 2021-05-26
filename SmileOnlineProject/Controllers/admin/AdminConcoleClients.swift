//
//  AdminConcoleClients.swift
//  SmileOnlineProject
//
//  Created by Алексей Волков on 16.04.2021.
//

import UIKit
import Firebase

class AdminConcoleClients: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    
    var clients: [String] = []
    var clientsDetails = [Client]()
    var user: String = ""
    var photo: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        callDelegates()
    }
    
    func callDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func getData() {
        clients = []
        clientsDetails = []
        photo = []
        
        let dbRef = (db.collection("users").document(user).collection("clients")).order(by: "date", descending: true)
        dbRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    
                    let data = document.data()
                    
                    self.clients.append(document.documentID)
                    
                    self.clientsDetails.append(Client(name: (data["name"] as? String)!,
                                                      
                                                      link: data["link"] as? String,
                                                      hard: data["hard"] as? String))
                }
                self.tableView.reloadData()
            }
        }
    }
}
extension AdminConcoleClients: UITableViewDelegate, UITableViewDataSource {
    
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
        
        let resultVC = storyboard?.instantiateViewController(withIdentifier: "AdminConcoleDetail") as! AdminConcoleDetail
        resultVC.user = self.user
        resultVC.client = clients[indexPath.row]
        
        navigationController?.pushViewController(resultVC, animated: true)
    } 
}
