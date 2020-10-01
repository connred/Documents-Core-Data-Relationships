//
//  Category+CoreDataClass.swift
//  Documents Core Data
//
//  Created by cdrm9t on 9/30/20.
//  Copyright © 2020 Dale Musser. All rights reserved.
//
//

import UIKit
import CoreData

@objc(Category)
public class Category: NSManagedObject {
    var documents: [Document]? {
        return self.rawDocuments?.array as? [Document]
    }
    
    convenience init?(title: String) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        guard let context = appDelegate?.persistentContainer.viewContext
            else {
                return nil
        }
        self.init(entity: Category.entity(), insertInto: context)
        
        self.title = title;
    }
    
}
