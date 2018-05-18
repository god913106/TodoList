//
//  ViewController.swift
//  TodoList
//
//  Created by 洋蔥胖 on 2018/5/16.
//  Copyright © 2018年 ChrisYoung. All rights reserved.
//

import UIKit

class TodoListTableViewController: UITableViewController{
    
    //var itemArray :Array = ["play wow", "dead Pool"]
    var itemArray = [Item]()
    let defaults = UserDefaults.standard
    let defaultsKey = "TodoListArray"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "wow"
        itemArray.append(newItem)
        
        
        if let items = defaults.array(forKey: defaultsKey) as? [Item]{
            itemArray = items
        }
    }
    
    //MARK - tableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itemArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = (item.done) ? .checkmark : .none
        
        //        if item.done == true {
        //            cell.accessoryType = .checkmark
        //        }else{
        //            cell.accessoryType = .none
        //        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK - TableView Delegate Methods
    //tells the delegate that the specified row is now selected.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = itemArray[indexPath.row]
        item.done != item.done
        
        //        if itemArray[indexPath.row].done == false  {
        //            itemArray[indexPath.row].done = true
        //        }else {
        //            itemArray[indexPath.row].done = false
        //        }
        tableView.reloadData()
        
    }
    
    //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "新增待辦事項", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "新增", style: .default) { (action) in
            //what willl happen once the user clicks the Add Item button on our UIAlert
            
            if (textField.text) != ""{
                
                    let newItem = Item()
                    newItem.title = textField.text!
                    
                    
                    self.itemArray.append(newItem)
                    
                    self.defaults.set(self.itemArray, forKey: self.defaultsKey)
                    
                    self.tableView.reloadData()
               
               
            }else{
                print("無法建立新事項")
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
}

