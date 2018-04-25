//
//  SettingsVIewController.swift
//  sql-test
//
//  Created by Qing Ran on 3/27/18.
//  Copyright © 2018 Qing Ran. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    var email : String?
    var password : String?
    
    var totalData : NSInteger?
    var allowNotification : boolean_t?
    var threshold : NSInteger?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
