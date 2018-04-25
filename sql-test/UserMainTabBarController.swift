//
//  ViewController.swift
//  sql-test
//
//  Created by Qing Ran on 3/27/18.
//  Copyright © 2018 Qing Ran. All rights reserved.
//

import UIKit

class UserMainTabBarController: UITabBarController {
    
  
    
   var stringPassed = "not working tab bar"
 //  print(stringPassed!)
   //   [[self UserDataTableViewController] stringPassed2 : stringPassed]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(stringPassed + " in tab bar")
        let UserDataTableViewController = storyboard?.instantiateViewController(withIdentifier: "UserDataTableViewController") as! UserDataTableViewController
        
       UserDataTableViewController.stringPassedEmail = stringPassed
 
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
