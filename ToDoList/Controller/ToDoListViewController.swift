//
//  ViewController.swift
//  ToDoList
//
//  Created by Kenneth Nagata on 5/9/18.
//  Copyright © 2018 Kenneth Nagata. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = [Items]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItems = Items()
        newItems.title = "First Item"
        itemArray.append(newItems)
        
    }

    //MARK: - Tableview Data Source Methods
    
    // Declare the amount of rows in tableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    // Declare and populate cell in tableView
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        // Ternary place (true) or remove (false) a checkmark in cell
        cell.accessoryType = item.done ? .checkmark : .none

        return cell
    }
    
    //Mark: - tableViewDelegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // toggles between true/false for .done property
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        // Reload the table
        tableView.reloadData()
    
        // After selection reset row color to default
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //Mark - Add New Items

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var newItemTextField = UITextField()
        
        // create new alert view
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        
        // specify action for alert
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            // what will happen once user clicks add item
            let newItem = Items()
            newItem.title = newItemTextField.text!
            
            self.itemArray.append(newItem)
            
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            // reload textFields with new item
            self.tableView.reloadData()
            
        }
        
        // add textField to alert,
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            newItemTextField = alertTextField
        }
        
        // add action to alert view
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
}
