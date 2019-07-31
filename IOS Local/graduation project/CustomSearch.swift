

import UIKit

extension UISearchBar {
  
  func didPresentSearchController(searchController: UISearchController) {
    searchController.searchBar.showsCancelButton = false
  }
  
  public func setSerchTextcolor(color: UIColor) {
    let clrChange = subviews.flatMap { $0.subviews }
    guard let sc = (clrChange.filter { $0 is UITextField }).first as? UITextField else { return }
    sc.textColor = color
  }
}


