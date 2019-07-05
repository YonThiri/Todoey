//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Yon Thiri Aung on 7/4/19.
//  Copyright © 2019 Yon Thiri Aung. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {

    let realm = try! Realm()
    
    var categories : Results<Category>?
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItem()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories?.count ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Here"
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListTableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.save(category: newCategory)
            
            
        }
        
        alert.addTextField { (alerttextField) in
            
            alerttextField.placeholder = "Create new Category"
            textField = alerttextField
        }
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
        
        
    }
    
    
    func save(category : Category){
        
        do{
            try realm.write {
                realm.add(category)
            }
        }
        catch{
            print(error)
        }
        tableView.reloadData()
    }
    
    func loadItem() {
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
}
