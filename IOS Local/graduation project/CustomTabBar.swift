

import UIKit

class CustomTabBar: UITabBarController {
  
  override func viewWillLayoutSubviews() {
    var newTabBarFrame = tabBar.frame

    let newTabBarHeight: CGFloat = 50
    newTabBarFrame.size.height = newTabBarHeight
    newTabBarFrame.origin.y = self.view.frame.size.height - newTabBarHeight
    
    

    tabBar.frame = newTabBarFrame
    tabBar.isTranslucent = false
    
    tabBar.barTintColor = .init(red: 71/255, green: 130/255, blue: 143/255, alpha: 1.00)
    self.tabBar.tintColor = .white
  }
  
}
