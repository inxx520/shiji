//
//  AboutTableViewController.swift
//  shiji
//
//  Created by 小仙女 on 20/12/2019.
//  Copyright © 2019 cyper tech. All rights reserved.
//

import UIKit
import SafariServices

class AboutTableViewController: UITableViewController {
    var sectionTitles = ["关注我们", "关于我们"]
    var sectionContent = [["App Store", "BNUZ官网"],
                          ["百度", "谷歌", "搜狐"]]
    var links = ["https://www.baidu.com/", "http://google.com/", "http://www.sohu.com/"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }



    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return sectionContent[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = sectionContent[indexPath.section][indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (0,0):
            if let url = URL(string: "http://eol.bnuz.edu.cn/meol/index.do") {
                UIApplication.shared.open(url)
            }
        case (0,1):
            performSegue(withIdentifier: "showWebView", sender: self)
        case (1,_):
            if let url = URL(string: links[indexPath.row]) {
                let svc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
                present(svc, animated: true, completion: nil)
            }
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
