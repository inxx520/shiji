//
//  RestaurantTableViewController.swift
//  shiji
//
//  Created by 小仙女 on 30/12/2019.
//  Copyright © 2019 cyper tech. All rights reserved.
//

import UIKit
import CoreData

class RestaurantTableViewController: UITableViewController, UISearchResultsUpdating {
    var searchController: UISearchController!
    var restaurants:[RestaurantMO] = []
    var searchResults: [RestaurantMO] = []
        /*
        [
        Restaurant(name: "Cafe Deadend", type: "Coffee & Tea Shop", location: "G/F, 72 Po Hing Fong, Sheung Wan, Hong Kong", phone: "232-923423", image: "cafedeadend.jpg", isVisited: false),
        Restaurant(name: "Homei", type: "Cafe", location: "Shop B, G/F, 22-24A Tai Ping San Street SOHO, Sheung Wan, Hong Kong", phone: "348-233423", image: "homei.jpg", isVisited: false),
        Restaurant(name: "Teakha", type: "Tea House", location: "Shop B, 18 Tai Ping Shan Road SOHO, Sheung Wan, Hong Kong", phone: "354-243523", image: "teakha.jpg", isVisited: false),
        Restaurant(name: "Cafe loisl", type: "Austrian / Causual Drink", location: "Shop B, 20 Tai Ping Shan Road SOHO, Sheung Wan, Hong Kong", phone: "453-333423", image: "cafeloisl.jpg", isVisited: false),
        Restaurant(name: "Petite Oyster", type: "French", location: "24 Tai Ping Shan Road SOHO, Sheung Wan, Hong Kong", phone: "983-284334", image: "petiteoyster.jpg", isVisited: false),
        Restaurant(name: "For Kee Restaurant", type: "Bakery", location: "Shop J-K., 200 Hollywood Road, SOHO, Sheung Wan, Hong Kong", phone: "232-434222", image: "forkeerestaurant.jpg", isVisited: false),
        Restaurant(name: "Po's Atelier", type: "Bakery", location: "G/F, 62 Po Hing Fong, Sheung Wan, Hong Kong", phone: "234-834322", image: "posatelier.jpg", isVisited: false),
        Restaurant(name: "Bourke Street Backery", type: "Chocolate", location: "633 Bourke St Sydney New South Wales 2010 Surry Hills", phone: "982-434343", image: "bourkestreetbakery.jpg", isVisited: false),
        Restaurant(name: "Haigh's Chocolate", type: "Cafe", location: "412-414 George St Sydney New South Wales", phone: "734-232323", image: "haighschocolate.jpg", isVisited: false),
        Restaurant(name: "Palomino Espresso", type: "American / Seafood", location: "Shop 1 61 York St Sydney New South Wales", phone: "872-734343", image: "palominoespresso.jpg", isVisited: false),
        Restaurant(name: "Upstate", type: "American", location: "95 1st Ave New York, NY 10003", phone: "343-233221", image: "upstate.jpg", isVisited: false),
        Restaurant(name: "Traif", type: "American", location: "229 S 4th St Brooklyn, NY 11211", phone: "985-723623", image: "traif.jpg", isVisited: false),
        Restaurant(name: "Graham Avenue Meats", type: "Breakfast & Brunch", location: "445 Graham Ave Brooklyn, NY 11211", phone: "455-232345", image: "grahamavenuemeats.jpg", isVisited: false),
        Restaurant(name: "Waffle & Wolf", type: "Coffee & Tea", location: "413 Graham Ave Brooklyn, NY 11211", phone: "434-232322", image: "wafflewolf.jpg", isVisited: false),
        Restaurant(name: "Five Leaves", type: "Coffee & Tea", location: "18 Bedford Ave Brooklyn, NY 11222", phone: "343-234553", image: "fiveleaves.jpg", isVisited: false),
        Restaurant(name: "Cafe Lore", type: "Latin American", location: "Sunset Park 4601 4th Ave Brooklyn, NY 11220", phone: "342-455433", image: "cafelore.jpg", isVisited: false),
        Restaurant(name: "Confessional", type: "Spanish", location: "308 E 6th St New York, NY 10003", phone: "643-332323", image: "confessional.jpg", isVisited: false),
        Restaurant(name: "Barrafina", type: "Spanish", location: "54 Frith Street London W1D 4SL United Kingdom", phone: "542-343434", image: "barrafina.jpg", isVisited: false),
        Restaurant(name: "Donostia", type: "Spanish", location: "10 Seymour Place London W1H 7ND United Kingdom", phone: "722-232323", image: "donostia.jpg", isVisited: false),
        Restaurant(name: "Royal Oak", type: "British", location: "2 Regency Street London SW1P 4BZ United Kingdom", phone: "343-988834", image: "royaloak.jpg", isVisited: false),
        Restaurant(name: "CASK Pub and Kitchen", type: "Thai", location: "22 Charlwood Street London SW1V 2DY Pimlico", phone: "432-344050", image: "caskpubkitchen.jpg", isVisited: false)
    ]
    */
    //override var preferredStatusBarStyle: UIStatusBarStyle {
    //    return .lightContent
    //}
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self

        searchController.dimsBackgroundDuringPresentation = false
        
        let searchBar = searchController.searchBar
        searchBar.placeholder = "搜索餐厅..."
        searchBar.tintColor = UIColor.white
        
        searchBar.barTintColor = UIColor(white: 236.0/255, alpha: 1.0)
        searchBar.searchBarStyle = .prominent
        
        tableView.tableHeaderView = searchBar
        
        
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // TODO bad performance, use NSFetchedResultsController instead.
        let request: NSFetchRequest<RestaurantMO> = RestaurantMO.fetchRequest()
        restaurants = try! CD.ctx.fetch(request)
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "hasViewedWalkthrough") {
            return
        }
        
        if let pageContainer = storyboard?.instantiateViewController(withIdentifier: "PageContainer") as? PageContainer {
            present(pageContainer, animated: true, completion: nil)
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text {
            print(text)
            searchResults = restaurants.filter { restaurant -> Bool in
                guard let name = restaurant.name,
                    let location = restaurant.location else {
                        return false
                }
                
                let isMatch = name.localizedCaseInsensitiveContains(text) || location.localizedCaseInsensitiveContains(text)
                return isMatch
                
            }
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if searchController.isActive {
            return false
        }
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }



    override func numberOfSections(in tableView: UITableView) -> Int {
     
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive {
            return searchResults.count
        } else {
            return restaurants.count

        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RestaurantTableViewCell

    
        let r = searchController.isActive ? searchResults[indexPath.row] : restaurants[indexPath.row]
        cell.nameLabel.text = r.name
        cell.locationLabel.text = r.location
        cell.typeLabel.text = r.type
        cell.thumbnailImageView.image = UIImage(data: r.image as! Data)
       
        cell.accessoryType = r.isVisited ? .checkmark : .none
        
        
        return cell
    }
    

    
    func deleteRow(at indexPath: IndexPath) {
 
        let restaurant = restaurants.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)

        CD.delete(restaurant)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
  
        let shareAction = UITableViewRowAction(style: .default, title: "分享", handler: {
            (action, indexPath) -> Void in
            
            let r = self.restaurants[indexPath.row]
            if let imageToShare = UIImage(data: r.image as! Data) {
                let activityController = UIActivityViewController(activityItems: ["Just checking in at " + r.name!, imageToShare], applicationActivities: nil)
                self.present(activityController, animated: true, completion: nil)
            }
            
        })
        shareAction.backgroundColor = UIColor(red: 48.0/255, green: 173.0/255, blue: 99.0/255, alpha: 1.0)
        
        
 
        let deleteAction = UITableViewRowAction(style: .destructive, title: "删除", handler: {
            (action, indexPath) in
            self.deleteRow(at: indexPath)
        })
        deleteAction.backgroundColor = UIColor(red: 218.0/255, green: 100.0/255, blue: 70.0/255, alpha: 1.0)
        
        return [deleteAction, shareAction]
    }
    

    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "showRestaurantDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let controller = segue.destination as! RestaurantDetailViewController
                
                controller.restaurant = searchController.isActive ? searchResults[indexPath.row] : restaurants[indexPath.row]
            }

        }
        
    }
    
    @IBAction func unwindToHomeScreen(segue: UIStoryboardSegue) {
    
    }
    

}
