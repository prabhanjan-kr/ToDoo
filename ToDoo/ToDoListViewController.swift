//
//  ToDoListViewController.swift
//  ToDoo
//
//  Created by prabhanjan on 25/09/18.
//  Copyright © 2018 manorishi. All rights reserved.
//

import Foundation
import UIKit

class ToDoListViewController : UITableViewController {
    
    
    var itemList = ["Conquer the world","Meet Osho", "Retire in amalfi"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func addItemButtonAction(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Add New Task", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter here"
        }
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: { alert -> Void in
            if let newTask = alertController.textFields?[0].text {
                if newTask != "" {
            self.itemList.append(newTask)
            self.tableView.reloadData()
                }
            }
            else {
                self.dismiss(animated: false, completion: nil)
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in
            self.dismiss(animated: false, completion: nil)
        })
        
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    //MARK : tableview methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoListCell") 
        cell?.textLabel?.text = itemList[indexPath.row]
        return cell!
    }
    
}
