//
//  TodoListTableViewController.swift
//  Todoey
//
//  Created by Yon Thiri Aung on 7/3/19.
//  Copyright © 2019 Yon Thiri Aung. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListTableViewController: UITableViewController{
    
    var todoItems : Results<Item>?
    
    let realm = try! Realm()
    
    let defaults = UserDefaults.standard

    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
 
    override func viewDidLoad() {
        super.viewDidLoad()

        loadItems()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done == true ? .checkmark : .none
        }
        else{
            
            cell.textLabel?.text = "No Items Added yet"
        }
        
        
       
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write {
                    item.done = !item.done
                }
            }
            catch{
                print(error)
            }
        }
        tableView.reloadData()
        
    }
    
    @IBAction func addbuttonPressed(_ sender: UIBarButtonItem) {
        
        var Textfield = UITextField()
        
        let alert = UIAlertController(title: "Add new todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            
       
            if let currentCategory = self.selectedCategory {
                
                do{
                    try self.realm.write {
                        
                        let newItem = Item()
                        newItem.title = Textfield.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                    
                }
                catch{
                    print(error)
                }
            
            }
            self.tableView.reloadData()
           
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create new Item"
            Textfield = alertTextField
            
        }
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
    
    func loadItems(){

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        todoItems = realm.objects(Item.self)
        
        tableView.reloadData()

    }
}

extension TodoListTableViewController : UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@",searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        print("Search")
        
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
