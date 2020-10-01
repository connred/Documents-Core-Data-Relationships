//
//  DocumentsViewController.swift
//  Documents Core Data
//
//  Created by Dale Musser on 7/9/18.
//  Copyright © 2018 Dale Musser. All rights reserved.
//

import UIKit
import CoreData

class DocumentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var documentsTableView: UITableView!
    let dateFormatter = DateFormatter()
    var documents = [Document]()
    var category: Category?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Documents"

        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Document> = Document.fetchRequest()
        
        do {
            documents = try managedContext.fetch(fetchRequest)
            
            documentsTableView.reloadData()
            
        } catch {
            print("Fetch request failed")
        }
        
        self.documentsTableView.reloadData()
    }
    
    @IBAction func addNewDoc(_ sender: Any) {
        performSegue(withIdentifier: "showDocument", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? DocumentViewController else {
            return
        }
        destination.category = category
         if let destination = segue.destination as? DocumentViewController,
                  let segueIdentifier = segue.identifier, segueIdentifier == "existingDocument",
                  let row = documentsTableView.indexPathForSelectedRow?.row {
            //destination.document = documents[row]
           /* guard (category?.documents?[row]) != nil else {
                return
            }*/
            destination.document = category?.documents?[row]
                    
        }
        
    }
    func deleteDocument(at indexPath: IndexPath) {
        if let document = category?.documents?[indexPath.row] {
            if let managedObjectContext = document.managedObjectContext {
                managedObjectContext.delete(document)
                
                do {
                    try managedObjectContext.save()
                    self.documents.remove(at: indexPath.row)
                    self.category?.removeFromRawDocuments(document)
                    documentsTableView.deleteRows(at: [indexPath], with: .automatic)
                } catch {
                    print("Delete failed.")
                    documentsTableView.reloadData()
                }
            }
        }
        
    }
    
   /* func deleteDocument(at indexPath: IndexPath) {
        let document = documents[indexPath.row]
        
        if let managedObjectContext = document.managedObjectContext {
            managedObjectContext.delete(document)
            
            do {
                try managedObjectContext.save()
                self.documents.remove(at: indexPath.row)
                documentsTableView.deleteRows(at: [indexPath], with: .automatic)
            } catch {
                alertNotifyUser(message: "Delete failed.")
                documentsTableView.reloadData()
            }
        }
    }*/
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category?.documents?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "documentCell", for: indexPath)
        
        
        if let cell = cell as? DocumentTableViewCell {
            let document = category?.documents?[indexPath.row]
            cell.nameLabel.text = document?.name
            if let size = document?.size {
                cell.sizeLabel.text = String(size) + " bytes"
            } else {
                cell.sizeLabel.text = "Unknown Size"
            }
            if let modifiedDate = document?.modifiedDate {
                cell.modifiedLabel.text = dateFormatter.string(from: modifiedDate)
            } else {
                cell.modifiedLabel.text = "unknown"
            }
        }
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    
    // There are two approaches to implementing deletion of table view cells.  Both are provided below.
    
    // Approach 1: using editing style
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteDocument(at: indexPath)
        }
    }
    
    /*
    // Approach 2: using editing actions
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") {
            action, index in
            self.deleteDocument(at: indexPath)  // self is required because inside of closure
        }
        
        return [delete]
    }
    */
 

}
