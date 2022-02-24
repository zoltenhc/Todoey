//
//  ToDoListViewController.swift
//  Todoey
//
//  Created by Zoltán Gál
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController {
    
    var toDoItems : Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
        loadItems()
           
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let colorHex = selectedCategory?.color {
            
            guard let navBar = navigationController?.navigationBar else {
                fatalError("Does not exist")
            }
            
            if let navBarColour = UIColor(hexString: colorHex) {
                let bar = UINavigationBarAppearance()
                bar.backgroundColor = navBarColour
                bar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(UIColor(hexString: colorHex)!, returnFlat: true)]
                navBar.standardAppearance = bar
                navBar.compactAppearance = bar
                navBar.scrollEdgeAppearance = bar
                navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
                searchBar.backgroundColor = navBarColour
               
        
                searchBar.searchTextField.backgroundColor = FlatWhite()
                searchBar.searchBarStyle = .minimal
            }
            
            title = selectedCategory!.name
            
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            if let colour = UIColor(hexString: selectedCategory?.color ?? "1D98F6")!.darken(byPercentage:CGFloat(indexPath.row) / CGFloat(toDoItems!.count)) {
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
            
            cell.accessoryType = item.done ? .checkmark : .none
            
        }else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row] {
            do {
            try realm.write(){
                
                item.done = !item.done
            }
            }catch{
                print(error)
            }
        
        }
        tableView.reloadData()
       tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add new Items
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textfield = UITextField()
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textfield.text!
                       
                        currentCategory.items.append(newItem)
                        newItem.dateCreated = Date()
                    }
                } catch {
                    print("Error saving items \(error)")
                    
                }
            }
            self.tableView.reloadData()
            
            
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textfield = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
       
    }
    
    
   
    func loadItems() {

        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }

    override func updateModel(at indexPath: IndexPath) {
        if let itemForDelete = toDoItems?[indexPath.row] {
                       do {
                           try realm.write(){
       
                               realm.delete(itemForDelete)
                       }
                       }catch{
                           print(error)
                       }
                   }
    }

}
//MARK: - Searchbar methods

extension ToDoListViewController: UISearchBarDelegate {
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

