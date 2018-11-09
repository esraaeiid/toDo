//
//  ViewController.swift
//  ToDo
// save data using user defaults
// save data using Ns coder
// using core data 


import UIKit

class ToDoViewController: UITableViewController {
    
 var itemArray = [Item]()
 //let defaults = UserDefaults.standard
 let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("item.pList")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NsCoder
        loadData()
        
       /*
         // user defaults
        print(dataFilePath!)
        let newItem = Item()
        newItem.tilte = "Eat"
        itemArray.append(newItem)
        
        let newItem1 = Item()
        newItem1.tilte = "Drink"
        itemArray.append(newItem1)
        
        if let item = UserDefaults.standard.array(forKey: "arrayKey") as? [String]{
            itemArray = item
       }
       */
    }
    
    //MARK: - tableView Data source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.tilte
        
        //ternary operator
        cell.accessoryType = item.done ? .checkmark : .none
        //cell.accessoryType = item.done == True ? .checkmark : .none
        
        
    
        return cell
    }

    //MARK: - Tableview delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveData()
        
        //tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - add new item
    
    @IBAction func addBtn(_ sender: Any) {
        var textField = UITextField() // scope issues
    let alert = UIAlertController(title: "New Challenge!", message: "Add Your New ToDo", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Let's Add", style: .default) { (action) in
        // once user tap add open this meyhos triggered
            
          self.saveData()
            
        let newItem = Item()
        newItem.tilte = textField.text!
       self.itemArray.append(newItem)
            
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New ONE!"
            textField = alertTextField
        }
        //self.defaults.set(self.itemArray, forKey: "arrayKey")
        alert.addAction(action)
    present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - model manuplation methods
    
    func saveData()
    {
        let encoder = PropertyListEncoder()
        do {
            
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
            
        }
        catch{
            print("Something Went Wrong with encoding\(error)")
        }
        
        self.tableView.reloadData() // to add items in table as it's actually there in item array
    }

    func loadData() {
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([Item].self, from: data)
            }
            catch{
                print("Something Went Wrong with decoding\(error)")
            }
        }
    }

    

    

   

}

