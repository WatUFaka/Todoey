//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Eli gueta on 03/03/2019.
//  Copyright © 2019 Eli gueta. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()

    }
    
    //MARK: - TableView Datasource Methoods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    func saveCategory() {
        
        do {
            try context.save()
          //  print("saved succsessfully")
        } catch  {
            print("Error saving new category \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategory() {
        
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error loading the categorys \(error)")
        }
        tableView.reloadData()
    }
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
    
        let  alert = UIAlertController(title: "Add new Todoey category", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Your Category Name"
            textField = alertTextField
        }
        
        alert.addAction(UIAlertAction(title: "Add Category", style: .default, handler: { action in
            //Whats going to happen when the user press on "add category"
            
            let myNewCategory = Category(context: self.context)
            
            myNewCategory.name = textField.text
            self.categoryArray.append(myNewCategory)
            
            self.saveCategory()
        }))
        
        present(alert, animated: true, completion: nil)
        
    }
    
}
