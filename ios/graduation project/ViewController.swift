//
//  ViewController.swift
//  graduation project
//
//  Created by ahmed on 5/10/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//



import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    //MARK:- Properties
    @IBOutlet var txtSearch: UITextField!
    @IBOutlet var dropDowwnTable: UITableView!
    
    
    //MARK:- Variables
    var arrPlaces = [Place]()
    var string2 = String ()
    override func viewDidLoad() {
        super.viewDidLoad()
        txtSearch.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        dropDowwnTable.layer.borderColor = UIColor.black.cgColor
        dropDowwnTable.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
     {
     if segue.identifier == "segue" {
     let secondController = segue.destination as! NewApptTableViewController
     secondController.myString = txtSearch.text!
     }
     }*/
    @IBAction func enterLocation(_ sender: Any) {
        if txtSearch.text != ""
        {
            if let destinationVC = self.navigationController?.viewControllers[0] as? NewApptTableViewController {
                
                destinationVC.myString = txtSearch.text!
                self.navigationController?.popViewController(animated: true)
                
            }
            else if  let destinationVC = self.navigationController?.viewControllers[0] as? UpdateApptTVC {
                destinationVC.myString = txtSearch.text!
                self.navigationController?.popViewController(animated: true)
                
                
                
            }
            //  self.navigationController?.pushViewController( self, animated: true)
            //   self.performSegue(withIdentifier: "segue", sender: self)
            //dismiss(animated: true, completion: nil)
            /*    let displayVC : NewApptTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewApptTableViewController") as! NewApptTableViewController
             displayVC.myString = txtSearch.text!
             
             self.present(displayVC, animated: true, completion: nil)
             */
            /*let sb = UIStoryboard.init(name: "Main", bundle: Bundle.main)
             let secondView = sb.instantiateViewController(withIdentifier: "NewApptTableViewController") as! NewApptTableViewController
             secondView.myString = txtSearch.text!
             self.present(secondView, animated: true, completion: nil)*/
            //self.navigationController?.pushViewController(displayVC, animated: true)
            //dismiss(animated: true, completion: nil)
        }
    }
    //MARK:- TextField Delegate
    @objc func textFieldDidChange(_ textField: UITextField)
    {
        if textField.text != ""
        {
            callAPIToGetPlaces(searchText: textField.text!)
        }
        else
        {
            dropDowwnTable.isHidden = true
        }
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK:- Get Places API
    func callAPIToGetPlaces(searchText : String)
    {
        let objPlace = Place()
        objPlace.searchPlace(searchString: searchText,delegate: self,selector: #selector(serverResponseSearchPlace))
    }
    
    @objc func serverResponseSearchPlace(arrObjPlace : [Place])
    {
        if arrObjPlace.count > 0
        {
            dropDowwnTable.isHidden = false
        }
        else
        {
            dropDowwnTable.isHidden = true
        }
        arrPlaces = arrObjPlace
        dropDowwnTable.reloadData()
    }
    
    //MARK:- TableV iew Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrPlaces.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell = dropDowwnTable.dequeueReusableCell(withIdentifier: "cell" , for: indexPath)
        
        let objPlace : Place = arrPlaces[indexPath.row]
        
        cell.textLabel!.text = objPlace.placeDescription
        //  txtSearch.text = objPlace.placeDescription
        cell.textLabel!.numberOfLines = 0
        //  txtSearch.text = objPlace.placeDescription
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = dropDowwnTable.cellForRow(at: indexPath)
        do {
            if let selectedText = cell?.textLabel!.text {
                txtSearch.text = selectedText
                //dropDowwnTable.isHidden = true
                self.resignFirstResponder()
                DispatchQueue.main.async(execute: { () -> Void in
                    self.dropDowwnTable.isHidden = true
                })
            }
        }catch{
            
            print("eroooor")
            
        }
    }
    
}
