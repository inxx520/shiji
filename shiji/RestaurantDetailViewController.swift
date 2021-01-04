//
//  RestaurantDetailViewController.swift
//  shiji
//
//  Created by 小仙女 on 30/12/2019.
//  Copyright © 2019 cyper tech. All rights reserved.
//

import UIKit
import MapKit

class RestaurantDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    //@IBOutlet weak var nameLabel: UILabel!
    //@IBOutlet weak var locationLabel: UILabel!
    //@IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    
    var restaurant: RestaurantMO!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

     
        restaurantImageView.image = UIImage(data: restaurant.image as! Data)
        
        
        tableView.backgroundColor = UIColor(white: 240.0/255, alpha: 0.2)
      
        tableView.separatorColor = UIColor(white: 240.0/255, alpha: 0.8)
        
        title = restaurant.name
       
        tableView.estimatedRowHeight = 36
        tableView.rowHeight = UITableViewAutomaticDimension
        
    
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showMap))
        mapView.addGestureRecognizer(tapGestureRecognizer)
        
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(restaurant.location!, completionHandler: {
            placemarks, error in
            if error != nil {
                print(error!)
                return
            }
            
            if let coordinate = placemarks?[0].location?.coordinate {
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                self.mapView.addAnnotation(annotation)
                
   
                let region = MKCoordinateRegionMakeWithDistance(coordinate, 250, 250)
                self.mapView.setRegion(region, animated: true)
            }
            
        })
    }
    
    func showMap(){
        performSegue(withIdentifier: "showMap", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
 
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RestaurantDetailTableViewCell
        
        cell.backgroundColor = UIColor.clear
        
        switch indexPath.row {
        case 0:
            cell.fieldLabel.text = "店名"
            cell.valueLabel.text = restaurant.name
        case 1:
            cell.fieldLabel.text = "类型"
            cell.valueLabel.text = restaurant.type
        case 2:
            cell.fieldLabel.text = "地址"
            cell.valueLabel.text = restaurant.location
        case 3:
            cell.fieldLabel.text = "联系方式"
            cell.valueLabel.text = restaurant.phone
        case 4:
            cell.fieldLabel.text = "你是否去过"
            cell.valueLabel.text = restaurant.isVisited ? "我已经去过！ \(restaurant.rating ?? "")" : "我还没去过！"
        default:
            cell.fieldLabel.text = ""
            cell.valueLabel.text = ""
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showReview" {
            let controller = segue.destination as! ReviewViewController
            controller.restaurant = self.restaurant
        } else if segue.identifier == "showMap" {
            let controller = segue.destination as! MapViewController
            controller.restaurant = self.restaurant
        }
    }
    
    @IBAction func close(segue: UIStoryboardSegue) {
        
    }

    @IBAction func ratingButtonTapped(segue: UIStoryboardSegue) {
        if let rating = segue.identifier {
            restaurant.isVisited = true
            
            switch rating {
            case "great":
                restaurant.rating = "超级美味！"
            case "good":
                restaurant.rating = "还不错~"
            case "dislike":
                restaurant.rating = "我不喜欢"
            default:
                break
            }
        }
        
        CD.save(restaurant)
        
        tableView.reloadData()
    }
    
    

}
