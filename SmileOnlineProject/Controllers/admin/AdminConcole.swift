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

