//
//  ItemModalViewController.swift
//  SSInventory
//
//  Created by Emery Clark on 5/3/15.
//  Copyright (c) 2015 Silicon Solutions. All rights reserved.
//

import UIKit
import CoreData

class ItemModalViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var category : String?
    var delegate : DetailViewController?
    
    var categoryDatasource : Array<String>?
    
    @IBOutlet weak var makeCell: UITableViewCell!
    @IBOutlet weak var modelCell: UITableViewCell!
    @IBOutlet weak var notesCell: UITableViewCell!
    @IBOutlet weak var pickerCell: UITableViewCell!
    
    @IBOutlet weak var make: UITextField!
    @IBOutlet weak var model: UITextField!
    @IBOutlet weak var notes: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var picker: UIPickerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(ItemModalViewController.dismiss(_:)))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(ItemModalViewController.insertNewObject(_:)))
        
        self.categoryDatasource = (UIApplication.shared.delegate as! AppDelegate).categories
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK - Tableview Datasource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:     return 3
        default:    return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0: return self.makeCell
        case 1: return self.modelCell
        case 2: return self.notesCell
        //case 3: return self.pickerCell
        default: return UITableViewCell()
        }
    }

    // Mark - Coredata
    
    func insertNewObject(_ sender: AnyObject) {
        if (self.delegate != nil) {
            var context = self.delegate?.managedObjectContext
            
            let newManagedObject = NSEntityDescription.insertNewObject(forEntityName: "Item", into: context!) as! Item
            
            //var picked : Int = self.picker.selectedRowInComponent(0)
            //let array : Array<String> = self.categoryDatasource!
            
            //newManagedObject.category   = array[picked]
            newManagedObject.category   = self.category!
            newManagedObject.make       = self.make.text!
            newManagedObject.model      = self.model.text!
            newManagedObject.note       = self.notes.text!
            
            var error: NSError? = nil
            if !context!.save(&error) {
                println("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
        dismiss(sender)
    }
    
    func dismiss(_ sender: AnyObject) {
        
        if (self.delegate != nil) {
            self.delegate?.shouldDismissModalViewController(self)
        }
    }
    
    // Mark - Picker
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 9
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        let array : Array<String> = self.categoryDatasource!
        
        return array[row]
    }
    
}
