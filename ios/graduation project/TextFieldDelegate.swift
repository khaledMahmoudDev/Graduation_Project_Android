

import UIKit

extension NewApptTableViewController: UITextFieldDelegate {
  
  func setTextFieldDelegates(){
    self.titleTextField.delegate = self
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    self.view.endEditing(true)
    return false
  }
}


extension UpdateApptTVC: UITextFieldDelegate {
  func setTextFieldDelegates(){
    self.titleTextField.delegate = self
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    self.view.endEditing(true)
    return false
  }
}



  
  
