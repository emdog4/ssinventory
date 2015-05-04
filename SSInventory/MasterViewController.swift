//
//  MasterViewController.swift
//  SSInventory
//
//  Created by Emery Clark on 5/2/15.
//  Copyright (c) 2015 Silicon Solutions. All rights reserved.
//

import UIKit


class MasterViewController: UITableViewController {
    
    enum CategorySections: Int {
        case Categories = 0
        case Settings
    }
    
    var categoryDatasource : Array<String>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Categories"
        
        self.categoryDatasource = (UIApplication.sharedApplication().delegate as! AppDelegate).categories
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK - Tableview Datasource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case CategorySections.Categories.rawValue:  return 9
        case CategorySections.Settings.rawValue:    return 2
        default:                                    return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        let array : Array<String> = self.categoryDatasource!
        switch indexPath.section {
        case CategorySections.Categories.rawValue:  cell.textLabel?.text = array[indexPath.row]
        case CategorySections.Settings.rawValue:    cell.textLabel?.text = ["Settings", "Print"][indexPath.row]
        default: break
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        switch indexPath.section {
        case CategorySections.Categories.rawValue:  return true
        default:                                    return false
        }
    }
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        switch indexPath.section {
        case CategorySections.Categories.rawValue:  return true
        default:                                    return false
        }
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        switch indexPath.section {
        case CategorySections.Categories.rawValue:  return .Delete
        default:                                    return .None
        }
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                if indexPath.section == CategorySections.Categories.rawValue {
                    let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                    let array : Array<String> = self.categoryDatasource!
                    controller.category = array[indexPath.row]
                    controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                    controller.navigationItem.leftItemsSupplementBackButton = true
                }
            }
        }
    }
    
}

