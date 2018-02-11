import UIKit

class DropViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Drops"
        
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.navigationBar.topItem?.title = title
        navigationController?.navigationBar.topItem?.leftBarButtonItem = nil
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAdd))
        navigationController?.navigationBar.topItem?.rightBarButtonItem = add
        tabBarController?.tabBar.isHidden = false
    }
    
    @objc func handleAdd() {
        let alert = UIAlertController(title: "Add Drop", message: "Please select the drop type", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Text", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Link", style: UIAlertActionStyle.default, handler: nil))
        // alert.addAction(UIAlertAction(title: "Image", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func setupView() {
        tableView.separatorStyle = .none
        
    }
}
