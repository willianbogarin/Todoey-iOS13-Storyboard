//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Willian Bogarin Jr on 2023. 09. 05..
//  Copyright © 2023. App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    
    var categoryArray = [Category]()
    
    let defaults = UserDefaults.standard
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Category.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Code to fix title bar color issue
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.systemTeal
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        print (dataFilePath!)
        
        loadItems()
        
        
        
        
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            //what will happen once user clicks the add item
            
            
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            // newItem.done = false
            
            self.categoryArray.append(newCategory)
            self.saveItems()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCellID , for: indexPath)
        
        
        let category = categoryArray[indexPath.row]
        
        cell.textLabel?.text = category.name
        
        //Ternary operator ==>
        // value = condition ? valueifTrue : valueifFalse
        
        
       // cell.accessoryType = item.done ? .checkmark : .none
        
   
        
        return cell
        
        
    }
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

         saveItems()

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: - Data Manipulation Methods
    
    func saveItems() {
        
        do {
            try self.context.save()
        }catch {
            print("Error saving context, \(error)")
        }
        print("Data Saved")
        tableView.reloadData()
    }
    func loadItems (with request: NSFetchRequest<Category> = Category.fetchRequest() ) {
        
        
        do{
            categoryArray = try context.fetch(request)
        }catch{
            print("Error loading context, \(error)")
        }
        tableView.reloadData()
    }
    
}
