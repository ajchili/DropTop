import UIKit

class TabViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        
        loadTabs()
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true;
    }
    
    fileprivate func loadTabs() {
        let dropTab = DropViewController()
        dropTab.tabBarItem = UITabBarItem(title: "Drops", image: nil, selectedImage: nil)
        
        let settingsTab = SettingsViewController()
        settingsTab.tabBarItem = UITabBarItem(title: "Settings", image: nil, selectedImage: nil)
        
        let tabs = [ dropTab, settingsTab ]
        viewControllers = tabs
        selectedIndex = 0
    }
}
