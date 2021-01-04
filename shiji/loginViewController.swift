//
//  loginViewController.swift
//  shiji
//
//  Created by 小仙女 on 2019/12/30.
//  Copyright © 2019 cyper tech. All rights reserved.
//

import UIKit

class loginViewController: UIViewController {
   
    @IBOutlet weak var usernametext: UITextField!
    @IBOutlet weak var passwordtext: UITextField!

    @IBOutlet weak var errorlabel: UILabel!
    
    
    func  validateTextField()->String{
        if usernametext.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" ||
            passwordtext.text?.trimmingCharacters(in: .whitespacesAndNewlines)==""{
            return  "请填写完整"
        }else if(passwordtext.text != "123" || usernametext.text != "admin"){
            return  "账号或密码错误"
        }
        return ""
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func logintapped(_ sender: Any) {
        
        let errormessage = self.validateTextField()
        if errormessage != ""{
            errorlabel.text=errormessage
            errorlabel.alpha = 1
        }else{
            let vc = storyboard?.instantiateViewController(withIdentifier: "mainVC") as! RestaurantTableViewController
            self.navigationController?.pushViewController(vc,animated: true)
        }
        
        

        }
   
        
        

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


