import UIKit
import FirebaseAuth
import FirebaseDatabase

class DropViewController: UITableViewController {
    
    var ref: DatabaseReference!
    var user: User!
    var drops = [Drop]()
    
    let cellIdentifier = "DropTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        user = Auth.auth().currentUser
        
        setupView()
        setupDropListener()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.navigationBar.topItem?.title = title
        navigationController?.navigationBar.topItem?.leftBarButtonItem = nil
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAdd))
        navigationController?.navigationBar.topItem?.rightBarButtonItem = add
        tabBarController?.tabBar.isHidden = false
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drops.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? DropTableViewCell else {
            fatalError("The dequeued cell is not an instance of DropTableViewCell")
        }
        
        let index = indexPath.row
        let drop = drops[index]
        
        cell.drop = drop
        cell.title.text = drop.title
        var type: String = ""
        
        switch drop.type?.rawValue {
        case Drop.type.text.rawValue?:
            type = "Text"
            break;
        case Drop.type.link.rawValue?:
            type = "Link"
            break;
        case .none:
            break;
        case .some(_):
            type = "Other"
            break;
        }
        
        cell.type.text = type
        cell.data.text = drop.data
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let drop = drops[indexPath.row]
        
        let copy = UITableViewRowAction(style: .normal, title: "Copy") { action, index in
            
        }
        copy.backgroundColor = .blue
        
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            let alert = UIAlertController(title: "Delete Drop", message: "Are you sure you want to delete this drop?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.default, handler: {
                (_) in
                self.ref.child("users").child(self.user.uid).child("drops").child(drop.key!).removeValue()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        delete.backgroundColor = .red
        
        return [ delete, copy ]
    }
    
    @objc func handleAdd() {
        let alert = UIAlertController(title: "Add Drop", message: "Please select the drop type", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Text", style: UIAlertActionStyle.default, handler: {
            (_) in
            self.addDrop(type: Drop.type.text)
        }))
        alert.addAction(UIAlertAction(title: "Link", style: UIAlertActionStyle.default, handler: {
            (_) in
            self.addDrop(type: Drop.type.link)
        }))
        // alert.addAction(UIAlertAction(title: "Image", style: UIAlertActionStyle.default, handler: nil))
        // alert.addAction(UIAlertAction(title: "File", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func setupView() {
        title = "Drops"
        
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 140.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.register(DropTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    fileprivate func addDrop(type: Drop.type) {
        let key = ref.child("users").child(user.uid).child("drops").childByAutoId().key
        
        switch type.rawValue {
        case Drop.type.text.rawValue:
            let alert = UIAlertController(title: "Text", message: "Please enter your message", preferredStyle: .alert)
            alert.addTextField { (textField) -> Void in
                textField.placeholder = "Message"
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
            alert.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: {
                (_) in
                let message: String = alert.textFields?[0].text ?? ""
                
                if message.count > 0 {
                    let extraAlert = UIAlertController(title: "Title", message: "Please enter a title of your message", preferredStyle: .alert)
                    extraAlert.addTextField { (textField) -> Void in
                        textField.placeholder = "Title"
                    }
                    extraAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
                    extraAlert.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: {
                        (_) in
                        let title: String = extraAlert.textFields?[0].text ?? ""
                        
                        if title.count > 0 {
                            self.ref.child("users").child(self.user.uid).child("drops").child(key).setValue([ "data": message, "title": title, "type": type.rawValue ])
                        }
                    }))
                    self.present(extraAlert, animated: true, completion: nil)
                }
            }))
            self.present(alert, animated: true, completion: nil)
            break
        case Drop.type.link.rawValue:
            let alert = UIAlertController(title: "Link", message: "Please enter the link", preferredStyle: .alert)
            alert.addTextField { (textField) -> Void in
                textField.keyboardType = .URL
                textField.placeholder = "Link"
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
            alert.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: {
                (_) in
                let link: String = alert.textFields?[0].text ?? ""
                
                if link.count > 0 {
                    let extraAlert = UIAlertController(title: "Title", message: "Please enter a title of your link", preferredStyle: .alert)
                    extraAlert.addTextField { (textField) -> Void in
                        textField.placeholder = "Title"
                    }
                    extraAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
                    extraAlert.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: {
                        (_) in
                        let title: String = extraAlert.textFields?[0].text ?? ""
                        
                        if title.count > 0 {
                            self.ref.child("users").child(self.user.uid).child("drops").child(key).setValue([ "data": link, "title": title, "type": type.rawValue ])
                        }
                    }))
                    self.present(extraAlert, animated: true, completion: nil)
                }
            }))
            self.present(alert, animated: true, completion: nil)
            break
        case Drop.type.image.rawValue:
            break
        case Drop.type.file.rawValue:
            break
        default:
            break
        }
    }
    
    fileprivate func setupDropListener() {
        ref.child("users").child(user.uid).child("drops").observe(.value, with: { (snapshot) in
            self.drops = [Drop]()
            
            for child in snapshot.children.allObjects {
                let childSnapshot = child as! DataSnapshot
                
                let key = childSnapshot.key
                let title = childSnapshot.childSnapshot(forPath: "title").value as! String
                let data = childSnapshot.childSnapshot(forPath: "data").value as! String
                let type = Drop.type(rawValue: childSnapshot.childSnapshot(forPath: "type").value as! Int)!
                
                let drop = Drop(key: key, title: title, data: data, type: type)
                
                self.drops.append(drop!)
            }
            
            self.tableView.reloadData()
        })
    }
}
