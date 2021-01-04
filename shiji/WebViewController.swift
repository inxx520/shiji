//
//  WebViewController.swift
//  shiji
//
//  Created by 小仙女 on 30/12/2019.
//  Copyright © 2019 cyper tech. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let url = URL(string: "http://eol.bnuz.edu.cn/meol/index.do") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }

}
