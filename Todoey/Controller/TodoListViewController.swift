//
//  ViewController.swift
//  Todoey
//
//  Created by David Dörflinger on 11.01.19.
//  Copyright © 2019 David Dörflinger. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    //MARK: - propertys
    
    var itemArray = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    //MARK: - view did load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath as Any)
        
        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        let newItem1 = Item()
        newItem1.title = "He ho he ho"
        itemArray.append(newItem1)
        
        let newItem2 = Item()
        newItem2.title = "Solööaö"
        itemArray.append(newItem2)
        
        loadItems()

    }
    
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        
        return cell
    }
    
    //MARK: - table view delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        itemArray[indexPath.row].done.toggle()
        
        saveItems()

    }
    
    
    //MARK: - IBActions
    
    // add button pressed
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            self.saveItems()
        }
        

        
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func loadItems() {
        // load data with dataFilePath
        
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
            itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("unable to load Items \(error)")
            }
        }   
    }
    
    
    
    func saveItems(){
        // save data with dataFilePath
        let encoder:PropertyListEncoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        } catch {
            print("Error encoding item array \(error)")
        }
        
        self.tableView.reloadData()
    }
}

