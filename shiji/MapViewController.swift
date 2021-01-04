//
//  MapViewController.swift
//  shiji
//
//  Created by 小仙女 on 30/12/2019.
//  Copyright © 2019 cyper tech. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    var restaurant: RestaurantMO!
    
    override func viewDidLoad() {
        super.viewDidLoad()


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
                annotation.title = self.restaurant.name
                annotation.subtitle = self.restaurant.type
             
                self.mapView.showAnnotations([annotation], animated: true)
                self.mapView.selectAnnotation(annotation, animated: true)
            }
            
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    

  

}
