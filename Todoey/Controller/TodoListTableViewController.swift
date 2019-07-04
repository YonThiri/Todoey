//
//  TodoListTableViewController.swift
//  Todoey
//
//  Created by Yon Thiri Aung on 7/3/19.
//  Copyright © 2019 Yon Thiri Aung. All rights reserved.
//

import UIKit

class TodoListTableViewController: UITableViewController {
    
    var itemArray = [Item]()
    let defaults = UserDefaults.standard
    
    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        print(filePath)
        
        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        let newItem1 = Item()
        newItem1.title = "Find Eggs"
        itemArray.append(newItem1)
        
        let newItem2 = Item()
        newItem2.title = "Find Yon"
        itemArray.append(newItem2)
        
//        if let items = defaults.array(forKey: "TodoListKey") as? [Item]{
//            itemArray = items
//        }
        
        loadItems()
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
        tableView.deselectRow(at: indexPath, animated: true)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItem()
    }
    
    @IBAction func addbuttonPressed(_ sender: UIBarButtonItem) {
        
        var Textfield = UITextField()
        
        let alert = UIAlertController(title: "Add new todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
           
            let newItem = Item()
            newItem.title = Textfield.text!
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
        
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.filePath!)
        }
        catch{
            
        }
        
        self.tableView.reloadData()
        
    }
    
    func loadItems(){
        
        if let data = try? Data(contentsOf: filePath!){
            let decoder = PropertyListDecoder()
            
            do{
                itemArray = try decoder.decode([Item].self, from: data)
            }
            catch{
                print("error")
            }
        }
    }
}
