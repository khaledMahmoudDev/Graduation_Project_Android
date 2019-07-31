

import UIKit

extension UIColor {
  
  convenience init?(hexCode: String) {
    
    guard hexCode.count == 7 else {
      return nil
    }
    
    guard hexCode.first! == "#" else {
      return nil
    }
    
    guard let value = Int(String(hexCode.dropFirst()), radix: 16) else {
      return nil
    }
    
    let red = value >> 16 & 0xff
    let green = value >> 8 & 0xff
    let blue = value & 0xff
    
    self.init(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: 1)
  }
}
