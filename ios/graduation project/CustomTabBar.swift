

import UIKit

class CustomTabBar: UITabBarController {
  
  override func viewWillLayoutSubviews() {
    var newTabBarFrame = tabBar.frame

    let newTabBarHeight: CGFloat = 50
    newTabBarFrame.size.height = newTabBarHeight
    newTabBarFrame.origin.y = self.view.frame.size.height - newTabBarHeight
    
    

    tabBar.frame = newTabBarFrame
    tabBar.isTranslucent = true
  }
  
}
