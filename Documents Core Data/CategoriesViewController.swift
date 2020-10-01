//
//  CategoriesViewController.swift
//  Documents Core Data
//
//  Created by cdrm9t on 9/30/20.
//  Copyright © 2020 Dale Musser. All rights reserved.
//

import UIKit
import CoreData


class CategoriesViewController: UIViewController {

    @IBOutlet weak var catTableView: UITableView!
    
    var categories: [Category] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Document Categories"

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            categories = try managedContext.fetch(fetchRequest)
            
            catTableView.reloadData()
            
        } catch {
            print("Fetch request failed")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? DocumentsViewController, let selectedRow = self.catTableView.indexPathForSelectedRow?.row else {
            return
        }
        
        destination.category = categories[selectedRow]
    }
    
    func deleteCat(at indexPath: IndexPath){
        let cat = categories[indexPath.row]
        
        guard let managedContext = cat.managedObjectContext else {
            return
        }
        managedContext.delete(cat)
        
        do {
            try managedContext.save()
            categories.remove(at: indexPath.row)
            
            catTableView.deleteRows(at: [indexPath], with: .automatic)
            
        } catch {
            print("cat could not delete")
            
            catTableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension CategoriesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = catTableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        let category = categories[indexPath.row]
        
        cell.textLabel?.text = category.title
        
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteCat(at: indexPath)
        }
    }
}
