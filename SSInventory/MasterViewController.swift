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
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        reloadDatasourceFromFile()
    }
    
    func reloadDatasourceFromFile() {
        let path = NSBundle.mainBundle().pathForResource("Categories", ofType: "plist")
        
        self.categoryDatasource = NSArray(contentsOfFile: path!) as? Array<String>
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
            case CategorySections.Categories.rawValue:  return 6
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

