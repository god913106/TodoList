//
//  CategoryTableViewController.swift
//  TodoList
//
//  Created by 洋蔥胖 on 2018/5/23.
//  Copyright © 2018年 ChrisYoung. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //找出資料庫的位子
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadCategories()
    }
    
    // MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) //點一下 灰一下 回白 使用者體驗
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(categoryArray[indexPath.row])
            categoryArray.remove(at: indexPath.row)
        }
        saveCategories()
        tableView.reloadData()
    }
    
    // MARK: - Data Manipulation Methods
    
    func saveCategories(){
        do{
             try context.save()
        }catch{
           print("無法存入context,\(error)")
        }
    }
    
    func loadCategories(){
        let request:NSFetchRequest = Category.fetchRequest()
        do{
            categoryArray = try context.fetch(request)
        }catch{
            print("無法叫出資料：\(error)")
        }
        tableView.reloadData()
    }
    
    
    // MARK: - Add New Categories Methods
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "新增事項分類", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "新增", style: .default) { (action) in
            if textField.text != ""{
                let newCategory = Category(context: self.context)
                newCategory.name = textField.text!
                self.categoryArray.append(newCategory)
                self.saveCategories()
                self.tableView.reloadData()
            }else{
                print("無法建立新分類")
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "建立新分類"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
