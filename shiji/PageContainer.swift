//
//  WalkthroughPageViewController.swift
//  shij
//
//  Created by 小仙女 on 30/12/2019.
//  Copyright © 2019 cyper tech. All rights reserved.
//

import UIKit

class PageContainer: UIPageViewController, UIPageViewControllerDataSource {

    var pageHeadings = ["食记", "记录", "发现"]
    var pageImages = ["foodpin-intro-1", "foodpin-intro-2", "foodpin-intro-3"]
    var pageContent = ["食记，记录下所有美好食物。",
                       "在这里，记录下你的美味瞬间",
                       "探索，不同的美味精彩"]
    
    override func viewDidLoad() {
        print("viewDidLoad")
        
        dataSource = self
        if let startingPage = page(at: 0) {
            setViewControllers([startingPage], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        print("viewControllerBefore")
        
        var index = (viewController as! SinglePage).index
        index -= 1
        
        return page(at: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter
        viewController: UIViewController) -> UIViewController? {
        print("viewControllerAfter")
        
        var index = (viewController as! SinglePage).index
        index += 1
        
        return page(at: index)
        
    }
    
    func page(at index: Int) -> SinglePage? {
        if index < 0 || index >= pageHeadings.count {
            return nil
        }
        
        if let page = storyboard?.instantiateViewController(withIdentifier: "SinglePage")  as? SinglePage {
            page.imageFile = pageImages[index]
            page.heading = pageHeadings[index]
            page.content = pageContent[index]
            page.index = index
            
            print("created page: \(index)")
            return page
        }
        
        return nil
    }
    
    
    func forward(index: Int) {
        if let nextPage = page(at: index + 1) {
            setViewControllers([nextPage], direction: .forward, animated: true, completion: nil)
        }
    }
}
