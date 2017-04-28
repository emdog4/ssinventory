//
//  DetailViewController.swift
//  SSInventory
//
//  Created by Emery Clark on 5/2/15.
//  Copyright (c) 2015 Silicon Solutions. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var category : String?
    var managedObjectContext: NSManagedObjectContext? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if self.category == nil {
            self.category = "Inventory"
        }
        
        if self.managedObjectContext == nil {
            self.managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.category!
        
        self.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(DetailViewController.captureInputModally(_:)))
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func captureInputModally(_ sender: AnyObject) {
        
        let main : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let itemVC : ItemModalViewController = main.instantiateViewController(withIdentifier: "ItemModalViewController") as! ItemModalViewController
        itemVC.delegate = self
        itemVC.category = self.category!
        
        let navController : UINavigationController = UINavigationController(rootViewController: itemVC)
        navController.modalPresentationStyle = .formSheet
        navController.modalTransitionStyle = .coverVertical
        
        self.present(navController, animated: true, completion: nil)
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section] 
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) 
        self.configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = self.fetchedResultsController.managedObjectContext
            context.delete(self.fetchedResultsController.object(at: indexPath) as! Item)
            
            var error: NSError? = nil
            if !context.save(&error) {
                println("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }
    
    func configureCell(_ cell: UITableViewCell, atIndexPath indexPath: IndexPath) {
        let item = self.fetchedResultsController.object(at: indexPath) as! Item
        cell.textLabel!.text =  " ".join([item.make, item.model, item.note])
    }
    
    // MARK: - Fetched results controller
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let entity = NSEntityDescription.entity(forEntityName: "Item", in: self.managedObjectContext!)
        fetchRequest.entity = entity
        
        fetchRequest.fetchBatchSize = 50
        
        let predicate = NSPredicate(format: "category = %@", self.category!)
        
        fetchRequest.predicate = predicate
        
        let sortDescriptor = NSSortDescriptor(key: "make", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: self.category)
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        var error: NSError? = nil
        if !_fetchedResultsController!.performFetch(&error) {
            println("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return _fetchedResultsController!
    }
    
    var _fetchedResultsController: NSFetchedResultsController? = nil
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            self.tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            self.tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            self.configureCell(tableView.cellForRow(at: indexPath!)!, atIndexPath: indexPath!)
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        default:
            return
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    func shouldDismissModalViewController(_ controller: ItemModalViewController) {
        self.tableView.reloadData()
        controller.dismiss(animated: true, completion: nil)
    }

}

