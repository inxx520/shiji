//
//  CoreDataUtil.swift
//  FoodPinDemo
//
//  Created by 小仙女 on 21/12/2019.
//  Copyright © 2019 cyper tech. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CD {
    
    class var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    class var ctx: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
    
    class func delete<T: NSManagedObject>(_ o: T) {
        ctx.delete(o)
        save(o)
    }
    
    class func save(_ _: NSManagedObject) {
        appDelegate.saveContext()
    }
    
    class func image2Data(image: UIImage?) -> NSData? {
        if let image = image {
            if let imageData = UIImagePNGRepresentation(image) {
                return NSData(data: imageData)
            }
        }
        
        return nil
    }
    
    class func x<T: NSManagedObject>(_ object: T) -> T {
        return T(context: ctx)
    }


}

