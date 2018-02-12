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
        cell.type.text = String(describing: drop.type?.rawValue)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
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
        
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellIdentifier)
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
                    self.ref.child("users").child(self.user.uid).child("drops").child(key).setValue([ "type": type.rawValue, "data": message ])
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
                    self.ref.child("users").child(self.user.uid).child("drops").child(key).setValue([ "type": type.rawValue, "data": link ])
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
                let title = childSnapshot.childSnapshot(forPath: "data").value as! String
                let type = Drop.type(rawValue: childSnapshot.childSnapshot(forPath: "type").value as! Int)!
                
                let drop = Drop(key: key, title: title, type: type)
                
                self.drops.append(drop!)
            }
            
            self.tableView.reloadData()
        })
    }
}
