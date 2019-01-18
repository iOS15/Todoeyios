//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by David Dörflinger on 16.01.19.
//  Copyright © 2019 David Dörflinger. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: SwipeTableViewController{
    
    let realm = try! Realm()

    var categories: Results<Category>!
    
    
    //MARK: -  View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
      loadCategories()
    }

    
    //MARK: - Table View Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "no categories added"
        
        return cell
        
    }
    
    
    //MARK: - Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
        destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
    }
    
    
    //MARK: - Data Manipulation Methods

    func loadCategories(){

        categories = realm.objects(Category.self)

        tableView.reloadData()
    }
    
    
    func save(category: Category){
        
        do{
            try realm.write {
                realm.add(category)
            }
        } catch {
        print("unable to safe Categories \(error)")
        }
        
        tableView.reloadData()
    }
    
    
    override func updateModel(at indexPath: IndexPath){
        if let category = self.categories?[indexPath.row] {
            do {
                try self.realm.write{
                    self.realm.delete(category)
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        
    }
    

    
    
    //MARK: - IBActions
    
    // Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a new Category", message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            
            self.save(category: newCategory)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a new Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    } 
}

