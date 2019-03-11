//
//  ViewController.swift
//  Todoey
//
//  Created by Eli gueta on 19/02/2019.
//  Copyright © 2019 Eli gueta. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet {
            loadData()
        }
    }
    
    //Context used for "CoreData"
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
                
    }
    
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added"
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Updating data useing "RealM"
        if let item = todoItems?[indexPath.row] {
            do{
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error UPDATING item useing RealM \(error)")
            }
        }
        
        tableView.reloadData()
        
        // Updating data useing "CoreDate"
//        todoItems[indexPath.row].done = !todoItems[indexPath.row].done
//
//        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add new item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            //Whats going to happen when the user press on "add item"
            
            //Adding and saving a new category useing realM
            if let currentCategory = self.selectedCategory {
                do{
                    try self.realm.write {
                        let myItem = Item()
                        myItem.title = textField.text!
                        myItem.dateCreated = Date()
                        currentCategory.items.append(myItem)
                    }
                } catch {
                    print("Error saving new item useing realm \(error)")
                }
            }
            
            self.tableView.reloadData()
            
            
//          creating a new category and calling "save" func to save useing "CoreData"
//            let myItem = Item(context: self.context)
//            myItem.title = textField.text!
//            myItem.done = false
//            myItem.parentCategory = self.selectedCategory
//            self.itemArray.append(myItem)
//            self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Creat new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert,animated: true,completion: nil)
    }
    
    //MARK: - Model Manupulation Methods
    
    
// Function used to save useing "CoreData" but not needed at "RealM"
//    func saveItems() {
//
//        do {
//            try context.save()
//        } catch {
//            print("Error saving new item: \(error)")
//        }
//        tableView.reloadData()
//    }
    
    func loadData() {
        
        //  Code used to load items from "RealM"
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
        
        
 //  Code used to load items from "CoreData"
//        let predicateParent = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//
//        if let searchPredicate = request.predicate {
//
//            let test = NSCompoundPredicate(type: .and, subpredicates: [searchPredicate, predicateParent])
//
//            request.predicate = test
//        } else {
//            request.predicate = predicateParent
//        }
//
//        do {
//            itemArray = try context.fetch(request)
//        } catch {
//            print("error fatching request \(error)")
//        }
        
    }
}

//MARK: - search bar methods

extension TodoListViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text! == "" {
            loadData()

        } else {
            
            todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
            tableView.reloadData()
            
//            let request : NSFetchRequest<Item> = Item.fetchRequest()
//            request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//            loadData(with: request)
        }

    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
}
