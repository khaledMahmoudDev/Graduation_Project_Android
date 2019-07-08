
import UIKit

class WireButton: UIButton {
  
  var mainUIColor = UIColor(hexCode: "#B75AFE")!
  
  override func draw(_ rect: CGRect) {
    self.layer.cornerRadius = 8
    self.setTitleColor(mainUIColor, for: .normal)
    self.layer.borderWidth = 1
    self.layer.borderColor = mainUIColor.cgColor
    self.contentEdgeInsets = UIEdgeInsets(top: 10,left: 40,bottom: 10,right: 40)
    
  }
  
}


