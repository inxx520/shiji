//
//  DiscoverTableViewController.swift
//  shiji
//
//  Created by 小仙女 on 20/12/2019.
//  Copyright © 2019 小仙女 tech. All rights reserved.
//

import UIKit
import CloudKit

class DiscoverTableViewController: UITableViewController {
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    var restaurants: [CKRecord] = []
    var imageCache = NSCache<CKRecordID, NSURL>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
 
        tableView.separatorColor = UIColor.white
        
     
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.white
        refreshControl?.tintColor = UIColor.gray
        refreshControl?.addTarget(self, action: #selector(fetchRecordsFromCloud), for: UIControlEvents.valueChanged)
        
        
        spinner.hidesWhenStopped = true
        spinner.center = view.center
        tableView.addSubview(spinner)
        spinner.startAnimating()
        
        fetchRecordsFromCloud()
    }

    func fetchRecordsFromCloud() {
   
        restaurants.removeAll()
        tableView.reloadData()
        
        //  using Convenience API
        //     let cloudContainer = CKContainer.default()
    //    let publicDb = cloudContainer.publicCloudDatabase
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Restaurant", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let queryOp = CKQueryOperation(query: query)
        queryOp.desiredKeys = ["name", "type", "location"]
        queryOp.queuePriority = .high
        queryOp.resultsLimit = 50
        queryOp.recordFetchedBlock = { record -> Void in
            self.restaurants.append(record)
        }
        queryOp.queryCompletionBlock = { cursor, error in
            if let error = error {
                print("failed to get data from iCould: \(error.localizedDescription)")
                return
            }
            
            print("Successfully retrieve data from iCould")
            OperationQueue.main.addOperation {
                self.spinner.stopAnimating()
                self.tableView.reloadData()
                if let refreshControl = self.refreshControl {
                    if refreshControl.isRefreshing {
                        refreshControl.endRefreshing()
                    }
                }

            }
        }
    //    publicDb.add(queryOp)
        /*
        publicDb.perform(query, inZoneWith: nil, completionHandler: {
            (results, error) -> Void in
            if error != nil {
                print(error!)
                return
            }
            
            if let results = results {
                print("completed the download of res data")
                self.restaurants = results
                OperationQueue.main.addOperation {
                    self.tableView.reloadData()
                }
            }
        })*/
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DiscoverCell
        
        let r = restaurants[indexPath.row]
        cell.nameLabel.text = r.object(forKey: "name") as? String
        cell.typeLabel.text = r.object(forKey: "type") as? String
        cell.locationLabel.text = r.object(forKey: "location") as? String
        cell.thumbnailImage.image = #imageLiteral(resourceName: "photoalbum")
        
      
        if let imageFileURL = imageCache.object(forKey: r.recordID) {
            // fetch image from cache
            print("get image from cache")
            if let imageData = try? Data.init(contentsOf: imageFileURL as URL) {
                cell.thumbnailImage.image = UIImage(data: imageData)
            }
        } else {
   
            

            let fetchOp = CKFetchRecordsOperation(recordIDs: [r.recordID])
            fetchOp.desiredKeys = ["image"]
            fetchOp.queuePriority = .veryHigh
            fetchOp.perRecordCompletionBlock = {record, recordID, error in
                if let error = error {
                    print("failed to get image from iCould: \(error.localizedDescription)")
                    return
                }
                
                if let rRecord = record {
                    OperationQueue.main.addOperation {
                        if let image = rRecord.object(forKey: "image") {
                            let imageAsset = image as! CKAsset
                            if let imageData = try? Data.init(contentsOf: imageAsset.fileURL) {
                                cell.thumbnailImage.image = UIImage(data: imageData)
                            }
       
                            self.imageCache.setObject(imageAsset.fileURL as NSURL, forKey: r.recordID)
                        }
                    }
                }
                
            }
      //      publicDb.add(fetchOp)
        }

        
        // fillCell(cell, with: r)
        
        return cell
    }
    
    func fillCell4Image(_ cell: DiscoverCell, with record: CKRecord) {
        if let image = record.object(forKey: "image") {
            let imageAsset = image as! CKAsset
            if let imageData = try? Data.init(contentsOf: imageAsset.fileURL) {
                cell.thumbnailImage.image = UIImage(data: imageData)
            }
        }
    }
}
