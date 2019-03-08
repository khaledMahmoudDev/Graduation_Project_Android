//
//  CategoryPopUp.swift
//  graduation project
//
//  Created by farah on 3/4/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit
import CoreData

class CategoryPopUp: UIViewController ,UITextFieldDelegate , UICollectionViewDataSource, UICollectionViewDelegate ,UIPickerViewDelegate , UIPickerViewDataSource{

    @IBOutlet weak var newCategory: UITextField!
    
    
    @IBOutlet weak var pickerview: UIPickerView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    var colorArray = [UIColor.red, UIColor.green, UIColor.blue, UIColor.cyan, UIColor.darkGray, UIColor.gray, UIColor.lightGray, UIColor.magenta, UIColor.orange, UIColor.purple, UIColor.yellow]
    
    var colorToPass : UIColor!
    var catFetchedForPopUp = [Categories]()
    var rowForCat = Int()
    //static variable to declare a variable is selected from picker view to handle deleting
    static var Selected = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadCatForPopUp()
        newCategory.delegate = self
        //hide the collection view of colors
        self.collectionView.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LoadCatForPopUp()
    }
    
    //function to fetch objects from coredata
    func LoadCatForPopUp(){
        let fetchReq : NSFetchRequest<Categories> = Categories.fetchRequest()
        do {
            catFetchedForPopUp = try context.fetch(fetchReq)
        } catch  {
            print(error.localizedDescription)
        }
        
    }
    
    //functions of picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return catFetchedForPopUp.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let category = catFetchedForPopUp[row]
        newCategory.text = category.categoryname
        newCategory.textColor = category.categorycolor as? UIColor
        
        //delet the selectd item, flag is set when delet buttion is clicked
        if CategoryPopUp.Selected == 1 {
            context.delete(category)
            appdelegate.saveContext()
            newCategory.text = ""
            print("deleted from picker")
            CategoryPopUp.Selected = 0
            
        }
        return category.categoryname
        
    }

    
    //action of delet button to select item
    @IBAction func deleteFromPicker(_ sender: Any) {
        CategoryPopUp.Selected = 1
        pickerview.reloadAllComponents()
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
        if collectionView.isHidden == true{
            collectionView.isHidden = false
        }else{
            collectionView.isHidden = true
        }
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destvc = segue.destination as! ToDoDetails
        destvc.showData = newCategory.text!
        destvc.showColor = colorToPass
        
        let newcat = Categories(context: context)
        newcat.categoryname = newCategory.text!
        newcat.categorycolor = colorToPass
        do{ appdelegate.saveContext()
            newCategory.text = ""
            print("saved")
 
        }catch{
            print(error.localizedDescription)
        }
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        newCategory.resignFirstResponder()
        self.collectionView.isHidden = true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.collectionView.isHidden = true
    }
    
    
}
