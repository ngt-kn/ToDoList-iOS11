//
//  ViewController.swift
//  ToDoList
//
//  Created by Kenneth Nagata on 5/9/18.
//  Copyright © 2018 Kenneth Nagata. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {

    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: - Tableview Data Source Methods
    
    // Declare the amount of rows in tableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    // Declare and populate cell in tableView
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            // Ternary place (true) or remove (false) a checkmark in cell
            cell.accessoryType = item.done ? .checkmark : .none
            
        } else {
            cell.textLabel?.text = "No data"
        }
        
        return cell
    }
    
    //Mark: - tableViewDelegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                    
                    //to delete an item
                    //realm.delete(item)
                }
            } catch {
                print("Error, \(error)")
            }
        }
        
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
           
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = newItemTextField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving to realm, \(error)")
                }
            }
            
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
    
    
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
    
}

//Mark: - Search bar methods
extension ToDoListViewController: UISearchBarDelegate {

    // searchBar delegate methods
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }

}
