//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    
    let realm = try! Realm()
    var todoItems : Results<Item>?
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    var selectedCategoryColor: UIColor?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        
        tableView.separatorStyle = .none
               
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation Controller doesn't exist!")}
        //Code to fix title bar color issue
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = selectedCategoryColor
        navigationItem.title
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        searchBar.barTintColor = selectedCategoryColor
        
        if let navBarColor = selectedCategoryColor {
            navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
            
            appearance.largeTitleTextAttributes = [.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
            
            title = selectedCategory!.name
            
        }
    }
    


  
    
    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
    
        let rowPercentage = CGFloat(indexPath.row)/CGFloat(todoItems!.count)
        
        if let color = selectedCategoryColor?.darken(byPercentage: CGFloat(rowPercentage)) {
            
            cell.backgroundColor = color
            cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            
            
            
        }
        
        if    let item = todoItems?[indexPath.row] {
            
                
            
            cell.textLabel?.text = item.title
            
            //Ternary operator ==>
            // value = condition ? valueifTrue : valueifFalse
            
            
            cell.accessoryType = item.done ? .checkmark : .none
         
        }else {
            cell.textLabel?.text = "No Items Added"
        }
        return cell
        
        
    }
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if let item = todoItems?[indexPath.row] {
            
            do {
                try realm.write {
                    item.done = !item.done
                    
                }
            }catch {
                print("error saving done status, \(error)")
            }
        }
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { [self] (action) in
            //what will happen once user clicks the add item
            
            
            
            
            if let currentCategory = self.selectedCategory{
                
                do {
                    try realm.write{
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
              
                        currentCategory.items.append(newItem)
                        
                        
                    }
                }catch {
                    print("Error saving Categories, \(error)")
                }
                print("Data Saved")
                tableView.reloadData()
                
            }
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Model Manipulation Methods
    
    func loadItems () {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title")
        
        tableView.reloadData()
        
    }
    
    //MARK: - Delete data from Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = todoItems?[indexPath.row] {
            
            do{
                try realm.write{
                    realm.delete(itemForDeletion)
                }
            }catch {
                print("Error deleting category, \(error)")
            }
        }
    }
    
}



//MARK: - Search bar methods

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        print("Button Clicked")
        
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


