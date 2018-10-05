//
//  ToDoListViewController.swift
//  ToDoo
//
//  Created by prabhanjan on 25/09/18.
//  Copyright © 2018 manorishi. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ToDoListViewController : UITableViewController {
    
    
    
    @IBOutlet weak var noTasksLabel: UILabel!
    @IBOutlet weak var searchBarOutlet: UISearchBar!
    let taskContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var itemList : [Task] = []
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        loadTasks()
        configureTableViewForAutodimension()
        
        //tap outside to end search editing
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        tableView.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func endEditing()
    {
        searchBarOutlet.endEditing(true)
    }
    
    //MARK: - add Item Action and UIAlertcontroller
    @IBAction func addItemButtonAction(_ sender: UIBarButtonItem)
    {
        
        let alertController = UIAlertController(title: "Add New Task", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addTextField
            {
                (textField : UITextField!) -> Void in
                textField.placeholder = "Enter here"
                textField.autocorrectionType = .yes
                textField.autocapitalizationType = UITextAutocapitalizationType.sentences
        }
        
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: { alert -> Void in
            if (alertController.textFields?[0].text != nil || alertController.textFields?[0].text != "")
            {
                let title = alertController.textFields?[0].text
                let newTask = Task(context: self.taskContext)
                newTask.taskTitle = title!
                newTask.isTaskCompleted = false
                self.itemList.append(newTask)
                self.saveTaskContext()
                
                
            }
            else
            {
                
                self.dismiss(animated: false, completion: nil)
            }
        })
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler:
        {
            (action : UIAlertAction!) -> Void in
            self.dismiss(animated: false, completion: nil)
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Context save method
    func saveTaskContext()
    {
        do {
            try self.taskContext.save()
        }
        catch {
            print(error)
        }
        
        self.tableView.reloadData()
    }
    //MARK: - Context load method for reading from CoreData
    func loadTasks()
    {
        let readRequest : NSFetchRequest<Task> = Task.fetchRequest()
        do
        {
            itemList =  try taskContext.fetch(readRequest)
        }
        catch
        {
            print("error fetching from DB")
        }
    }
    
    //MARK: -  tableview methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        noTasksLabel.isHidden = itemList.count == 0 ? false : true
        searchBarOutlet.isUserInteractionEnabled = itemList.count == 0 ? false : true
        searchBarOutlet.alpha = itemList.count == 0 ? 0.5 : 1
        return itemList.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoListCell")
        let currentItem = itemList[indexPath.row]
        cell?.textLabel?.text = currentItem.taskTitle
        cell?.textLabel?.textAlignment = .justified
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 18)
        
        //task status
        cell?.accessoryType = currentItem.isTaskCompleted ? .checkmark : .none
        
        return cell!
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //negate the completion status of the selected task
        itemList[indexPath.row].isTaskCompleted = !(itemList[indexPath.row].isTaskCompleted)
        
        tableView.deselectRow(at: indexPath, animated: true)
        saveTaskContext()
        
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            self.taskContext.delete(itemList[indexPath.row])
            itemList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveTaskContext()
            
        } 
    }
    
    func configureTableViewForAutodimension()
    {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.separatorStyle = .none
        tableView.reloadData()
    }
    
}

extension ToDoListViewController : UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0
        {
            loadTasks()
            searchBar.resignFirstResponder()
        }
        else
        {
            let searchRequest : NSFetchRequest<Task> = Task.fetchRequest()
            let searchPredicate = NSPredicate(format: "taskTitle CONTAINS[cd] %@", searchBar.text!)
            searchRequest.predicate = searchPredicate
            do
            {
                itemList =  try taskContext.fetch(searchRequest)
            }
            catch
            {
                print("Search error")
            }
            
        }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        
        searchBar.endEditing(true)
    }
    
    
}
