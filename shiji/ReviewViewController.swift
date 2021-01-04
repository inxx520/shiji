//
//  ReviewViewController.swift
//  shiji
//
//  Created by 小仙女 on 30/12/2019.
//  Copyright © 2019 cyper tech. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    
    var restaurant: RestaurantMO!

    override func viewDidLoad() {
        super.viewDidLoad()
        closeButton.layer.cornerRadius = 4.0;
     
        ratingImageView.image = UIImage(data: restaurant.image as! Data)
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
        
        let scaleTransform = CGAffineTransform(scaleX: 0, y: 0)
        let translateTransform = CGAffineTransform(translationX: 0, y: -1000)
        let combineTransform = scaleTransform.concatenating(translateTransform)
        containerView.transform = combineTransform
        
        closeButton.transform = CGAffineTransform(translationX: 100, y: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.2, options: .curveEaseOut, animations: {
            self.containerView.transform = CGAffineTransform.identity
        }, completion: nil)
        
      
        UIView.animate(withDuration: 0.5, animations: {
            self.closeButton.transform = CGAffineTransform.identity
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    

   

}
