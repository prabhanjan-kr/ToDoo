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
    
    let defaults = UserDefaults.standard
    var itemList = ["Conquer the world","Meet Osho", "Retire in amalfi"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let items = defaults.array(forKey: "ToDoList") as? [String] {
            itemList = items
        }
        tableView.separatorStyle = .none
        configureTableViewForAutodimension()
        
    }
    @IBOutlet weak var noTasksLabel: UILabel!
    
    @IBAction func addItemButtonAction(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Add New Task", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter here"
            textField.autocorrectionType = .yes
        }
        
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: { alert -> Void in
            
            if let newTask = alertController.textFields?[0].text {
                if newTask != "" {
                    
                    self.itemList.append(newTask)
                    //write it into Userdefaults
                    self.defaults.set(self.itemList, forKey: "ToDoList")
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
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        
        self.present(alertController, animated: true, completion: nil)
    }
    //MARK - tableview methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if itemList.count == 0 {
            noTasksLabel.isHidden = false
        }
        else {
            noTasksLabel.isHidden = true
        }
        
            return itemList.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoListCell")
        cell?.textLabel?.text = itemList[indexPath.row]
        cell?.textLabel?.textAlignment = .justified
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 18)
        cell?.imageView?.image = #imageLiteral(resourceName: "pending")
        let bgView = UIView()
        bgView.backgroundColor = UIColor.clear
        cell?.selectedBackgroundView = bgView
        return cell!
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row) :is the row selected")
        tableView.cellForRow(at: indexPath)?.imageView?.image = #imageLiteral(resourceName: "done")
        tableView.cellForRow(at: indexPath)?.contentView.backgroundColor = UIColor.clear
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            itemList.remove(at: indexPath.row)
            self.defaults.set(self.itemList, forKey: "ToDoList")
            tableView.deleteRows(at: [indexPath], with: .fade)
        } 
    }
   
    func configureTableViewForAutodimension() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.reloadData()
    }
    
}
