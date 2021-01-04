//
//  WalkthroughContentViewController.swift
//  shiji
//
//  Created by 小仙女 on 30/12/2016.
//  Copyright © 2019 cyper tech. All rights reserved.
//

import UIKit

class SinglePage: UIViewController {
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var contentImageView: UIImageView!
    
    @IBOutlet weak var pageCtrl: UIPageControl!
    @IBOutlet weak var forwardButton: UIButton!
    
    var index = 0
    var heading = ""
    var imageFile = ""
    var content = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        headingLabel.text = heading
        contentLabel.text = content
        contentImageView.image = UIImage(named: imageFile)
        
        pageCtrl.currentPage = index
        
        switch index {
        case 0...1:
            forwardButton.setTitle("NEXT", for: .normal)
        case 2:
            forwardButton.setTitle("DONE", for: .normal)
        default:
            break
        }
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        switch index {
        case 0...1:
            let pageContainer = parent as! PageContainer
            pageContainer.forward(index: index)
        case 2:
            UserDefaults.standard.set(true, forKey: "hasViewedWalkthrough")
            dismiss(animated: true, completion: nil)
        default:
            break
        }

    }
}
