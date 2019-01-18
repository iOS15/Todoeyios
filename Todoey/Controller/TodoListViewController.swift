//
//  ViewController.swift
//  Todoey
//
//  Created by David Dörflinger on 11.01.19.
//  Copyright © 2019 David Dörflinger. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    //MARK: - propertys
    
    let realm = try! Realm()
    
    var toDoItems: Results<Item>?
    
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }

    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: - view did load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        
    }
    
    // view will appear
    override func viewWillAppear(_ animated: Bool) {
        
        title =  selectedCategory?.name
        
        guard let colorHex = selectedCategory?.bgColor else { fatalError() }
        
        updateNavBar(withHexCode: colorHex)
    }
    
    
    
    // view will disappear
    
    override func viewWillDisappear(_ animated: Bool) {
       updateNavBar(withHexCode: "1D9BF6")
    }
    
    
    //MARK: - Nav Bar Setup Method
    
    func updateNavBar(withHexCode: String){
        
        guard let navBar = navigationController?.navigationBar else { fatalError("navigation controller does not exist") }
        
        guard let navBarColor = UIColor(hexString: withHexCode) else { fatalError() }
        
        navBar.barTintColor = navBarColor
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
        
        searchBar.barTintColor = navBarColor
        
    }
    
    

    
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        if let item = toDoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            //FlatWhite()
            //let newBgColor =
            
            if let bgColor = HexColor((selectedCategory?.bgColor)!)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(toDoItems!.count))  {
                cell.backgroundColor = bgColor
                cell.textLabel?.textColor = ContrastColorOf(bgColor, returnFlat: true)
            }
            
            cell.accessoryType = item.done ? .checkmark : .none
            
        } else {
            cell.textLabel?.text = "No Items Added"
        }

        return cell
    }
    
    //MARK: - table view delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        if let item = toDoItems?[indexPath.row] {
            do {
                try self.realm.write{
                item.done.toggle()  // realm.delete(item)
                }
            } catch {
                    print("Error saving done status, \(error)")
                }
        }
        
        tableView.reloadData()
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
            
            if let currentCategory =  self.selectedCategory {
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("unable to safe Categories \(error)")
                }
            }
           
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    
    //MARK: - data manipulation
    
    func loadItems(){
        
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }


    override func updateModel(at indexPath: IndexPath){
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write{
                    realm.delete(item)
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        
    }
}

//MARK: - Search Bar Methods

extension TodoListViewController: UISearchBarDelegate {
    
   func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
    toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
    
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

