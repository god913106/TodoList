//
//  ViewController.swift
//  TodoList
//
//  Created by 洋蔥胖 on 2018/5/16.
//  Copyright © 2018年 ChrisYoung. All rights reserved.
//

import UIKit
import CoreData

class TodoListTableViewController: UITableViewController{
    
    //var itemArray :Array = ["play wow", "dead Pool"]
    var itemArray = [Item]()
    
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadItem()
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
        
//        context.delete(itemArray[indexPath.row]) //先context去抓住你要刪除的row
//        itemArray.remove(at: indexPath.row)      //再從view上remove掉那row 這兩個方法順序不可以互換 會bug
        
        let item = itemArray[indexPath.row]
        item.done = !item.done
        
        //        if itemArray[indexPath.row].done == false  {
        //            itemArray[indexPath.row].done = true
        //        }else {
        //            itemArray[indexPath.row].done = false
        //        }
        
        saveItems()
        tableView.reloadData()
        
    }
    
    //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "新增待辦事項", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "新增", style: .default) { (action) in
            //what willl happen once the user clicks the Add Item button on our UIAlert
            
            if (textField.text) != ""{
                
                let newItem = Item(context: self.context)
                /*
                 data: {
                 done = nil; 所以done 要預設為false
                 title = loveu;
                 */
                
                newItem.title = textField.text!
                newItem.done = false
                
                self.itemArray.append(newItem)
                
                self.saveItems()
                
                
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
    //編碼 把view新增在textfield的字串 轉成 plist格式
    func saveItems(){
        
        do{
            try context.save()
        }catch{
            print("無法存進context, \(error)")
        }
    }
    //解碼 plist表格 解析出來 放在view上
    func loadItem(){
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do{
            itemArray = try context.fetch(request)
        } catch{
            print("無法叫出資料, \(error)")
        }
        
    }
    
}
