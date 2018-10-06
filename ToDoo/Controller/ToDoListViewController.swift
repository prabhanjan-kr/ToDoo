//
//  ToDoListViewController.swift
//  ToDoo
//
//  Created by prabhanjan on 25/09/18.
//  Copyright © 2018 manorishi. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class ToDoListViewController : UITableViewController {
    
    // let defaults = UserDefaults.standard
    var itemList : Results<Task>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchListFromRealm()
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
            
            if alertController.textFields?[0].text != nil || alertController.textFields?[0].text != "" {
                
                let title = alertController.textFields?[0].text
                let newTask = Task()
                newTask.taskTitle = title!
                self.saveToRealm()
                self.tableView.reloadData()
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
    //MARK: - tableview methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        noTasksLabel.isHidden = itemList.count == 0 ? false : true
        return itemList.count.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoListCell")
        let currentItem = itemList[indexPath.row]
        cell?.textLabel?.text = currentItem.taskTitle
        cell?.textLabel?.textAlignment = .justified
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 18)
        
        //task status
        cell?.accessoryType = currentItem.isTaskCompleted ? .checkmark : .none
        
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
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            itemList[indexPath.row].isTaskCompleted = false
        }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            itemList[indexPath.row].isTaskCompleted = true
        }
        
        self.saveToRealm()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } 
    }
    
    func configureTableViewForAutodimension() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.separatorStyle = .none

        tableView.reloadData()
    }
    
    //MARK: - Realm methods
    func fetchListFromRealm() {
        DispatchQueue(label: "background").async {
            autoreleasepool {
                let realm = try! Realm()
                self.itemList = realm.objects(Task.self)
                
            }
    }
    }
    func saveToRealm() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(itemList)
            }
        }
        catch {
            print(error)
        }
    }
    
}

