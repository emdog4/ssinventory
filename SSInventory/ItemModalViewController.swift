//
//  ItemModalViewController.swift
//  SSInventory
//
//  Created by Emery Clark on 5/3/15.
//  Copyright (c) 2015 Silicon Solutions. All rights reserved.
//

import UIKit
import CoreData

class ItemModalViewController: UIViewController {
    
    var category : String?
    var delegate : DetailViewController?
    
    @IBOutlet weak var make: UITextField!
    @IBOutlet weak var model: UITextField!
    @IBOutlet weak var notes: UITextField!
    @IBOutlet weak var price: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "dismiss:")
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "insertNewObject:")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func insertNewObject(sender: AnyObject) {
        if (self.delegate != nil) {
            var context = self.delegate?.managedObjectContext
            
            let newManagedObject = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: context!) as! Item
            
            newManagedObject.category   = self.category!
            newManagedObject.make       = self.make.text
            newManagedObject.model      = self.model.text
            newManagedObject.note       = self.notes.text
            newManagedObject.price      = Double(self.price.text.toInt()!)
            
            var error: NSError? = nil
            if !context!.save(&error) {
                println("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
        dismiss(sender)
    }
    
    func dismiss(sender: AnyObject) {
        
        if (self.delegate != nil) {
            self.delegate?.shouldDismissModalViewController(self)
        }
    }
}