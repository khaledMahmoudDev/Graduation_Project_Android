//
//  CategoryPopUp.swift
//  graduation project
//
//  Created by farah on 3/4/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit

class CategoryPopUp: UIViewController ,UITextFieldDelegate , UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var newCategory: UITextField!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    var colorArray = [UIColor.red, UIColor.green, UIColor.blue]
    
    var colorToPass : UIColor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newCategory.delegate = self
        self.collectionView.isHidden = true
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.colorArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath)
        
        cell.backgroundColor = self.colorArray[indexPath.item]
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let SelectedItem = indexPath.row + 1
        print(SelectedItem)
        self.colorToPass = self.colorArray[indexPath.item]
    }
    
    
    @IBAction func toggleCollectionViewHideShow(sender: UIButton) {
        self.collectionView.isHidden = !self.collectionView.isHidden
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destvc = segue.destination as! ToDoDetails
        destvc.showData = newCategory.text!
        destvc.showColor = colorToPass
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        newCategory.resignFirstResponder()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}
