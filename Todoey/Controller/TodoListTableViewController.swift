//
//  TodoListTableViewController.swift
//  Todoey
//
//  Created by Yon Thiri Aung on 7/3/19.
//  Copyright © 2019 Yon Thiri Aung. All rights reserved.
//

import UIKit
import CoreData

class TodoListTableViewController: UITableViewController{
    
    var itemArray = [Item]()
    let defaults = UserDefaults.standard

    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        loadItems(with: request)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done == true ? .checkmark : .none
       
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        //print(itemArray[indexPath.row])
//        context.delete(itemArray[indexPath.row])
//
//        itemArray.remove(at: indexPath.row)
//
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        
        saveItem()
    }
    
    @IBAction func addbuttonPressed(_ sender: UIBarButtonItem) {
        
        var Textfield = UITextField()
        
        let alert = UIAlertController(title: "Add new todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            
           
           
            let newItem = Item(context: self.context)
            newItem.title = Textfield.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            self.saveItem()
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create new Item"
            Textfield = alertTextField
            
        }
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
    
    
    func saveItem(){

        do{
            
            try context.save()
        }
        catch{
            print(error)
        }
        
        self.tableView.reloadData()
        
    }
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(),predicate : NSPredicate? = nil){
        
        let categorypredicate = NSPredicate(format: "parentCategory.name MATCHES %@", (selectedCategory?.name!)!)
        
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categorypredicate,additionalPredicate])
        }
        else{
            request.predicate = categorypredicate
        }
        do{
            itemArray = try context.fetch(request)
        }
        catch{
            print(error)
        }
        tableView.reloadData()
        
    }
}

extension TodoListTableViewController : UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
         let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
        
        loadItems(with: request,predicate: predicate)
        
        

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
