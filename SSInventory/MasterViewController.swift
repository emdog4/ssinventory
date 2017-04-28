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
        case categories = 0
        case settings
    }
    
    var categoryDatasource : Array<String>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Categories"
        
        self.categoryDatasource = (UIApplication.shared.delegate as! AppDelegate).categories
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK - Tableview Datasource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case CategorySections.categories.rawValue:  return 9
        case CategorySections.settings.rawValue:    return 2
        default:                                    return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) 
        let array : Array<String> = self.categoryDatasource!
        switch indexPath.section {
        case CategorySections.categories.rawValue:  cell.textLabel?.text = array[indexPath.row]
        case CategorySections.settings.rawValue:    cell.textLabel?.text = ["Settings", "Print"][indexPath.row]
        default: break
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch indexPath.section {
        case CategorySections.categories.rawValue:  return true
        default:                                    return false
        }
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        switch indexPath.section {
        case CategorySections.categories.rawValue:  return true
        default:                                    return false
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        switch indexPath.section {
        case CategorySections.categories.rawValue:  return .delete
        default:                                    return .none
        }
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                if indexPath.section == CategorySections.Categories.rawValue {
                    let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                    let array : Array<String> = self.categoryDatasource!
                    controller.category = array[indexPath.row]
                    controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                    controller.navigationItem.leftItemsSupplementBackButton = true
                }
            }
        }
    }
    
}

