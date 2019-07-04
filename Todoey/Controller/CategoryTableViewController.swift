//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Yon Thiri Aung on 7/4/19.
//  Copyright © 2019 Yon Thiri Aung. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

    
    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItem()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListTableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            
            
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text
            self.categoryArray.append(newCategory)
            
            self.saveItems()
            
            
        }
        
        alert.addTextField { (alerttextField) in
            
            alerttextField.placeholder = "Create new Category"
            textField = alerttextField
        }
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
        
        
    }
    
    
    func saveItems(){
        
        do{
           try context.save()
        }
        catch{
            print(error)
        }
        tableView.reloadData()
    }
    
    func loadItem(with request : NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do{
            categoryArray = try context.fetch(request)
        }
        catch{
            print(error)
        }
        tableView.reloadData()
    }
}
