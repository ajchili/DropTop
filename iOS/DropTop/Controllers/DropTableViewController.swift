//
//  DropTableViewController.swift
//  DropTop
//
//  Created by Kirin Patel on 12/14/17.
//  Copyright © 2017 Kirin Patel. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class DropTableViewController: UITableViewController {

    var ref: DatabaseReference!
    
    var drops = [Drop]()
    
    override func viewDidLoad() {
        ref = Database.database().reference()
        
        loadDrops()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drops.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "dropTopCell", for: indexPath) as? DropTableViewCell else {
            fatalError("The dequeued cell is not an instance of DropTableViewCell")
        }
        
        var drop: Drop
        
        drop = self.drops[indexPath.row]
        
        cell.drop = drop
        cell.card.title = drop.title!
        switch (drop.type) {
            case .none:
                cell.card.itemTitle = "Unknown"
            case .link?:
                cell.card.itemTitle = "Link"
            case .file?:
                cell.card.itemTitle = "File"
        }
        cell.card.itemSubtitle = drop.key!
        
        return cell
    }
    
    private func loadDrops() {
        ref.child("users").child((Auth.auth().currentUser?.uid)!).child("drops").observe(DataEventType.value, with: { (snapshot) in
            self.drops = [Drop]()
            self.tableView.reloadData()
            
            for child in snapshot.children.allObjects {
                let childSnapshot = child as! DataSnapshot
                let key = childSnapshot.key
                let title: String = childSnapshot.childSnapshot(forPath: "title").value as! String
                var type = childSnapshot.childSnapshot(forPath: "type").value
                let typeLowerCased = (type as! String).lowercased()
                
                if typeLowerCased == "link" {
                    type = Drop.type.link
                } else if typeLowerCased == "file" {
                    type = Drop.type.file
                } else {
                    type = Drop.type.link
                }
                
                let drop: Drop = Drop(key: key, title: title, type: type! as! Drop.type)!
                self.drops.append(drop)
                
                self.tableView.reloadData()
            }
        })
    }
}
