//
//  forgetPassword.swift
//  sql-test
//
//  Created by Qing Ran on 4/3/18.
//  Copyright © 2018 Qing Ran. All rights reserved.
//

import UIKit

class forgetPassword: UIViewController {
    
    var responseStatus: String = ""
    
    @IBOutlet weak var userEmailTExtField: UITextField!
    //    let userEmail = userENameTextField.text
    
    func displayMessage(userMessage:String) -> Void {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) {(action:UIAlertAction!) in
                print("OK button tapped")
                DispatchQueue.main.async {
                    //    self.dismiss(animated: true, completion: nil)
                }
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
    }
    
    
    
    @IBAction func resetButtonTapped(_ sender: Any) {
        
        let userEmail = userEmailTExtField.text
        
        if (userEmail!.isEmpty) {
          
            displayMessage(userMessage: "Please fill in Email")
            return
        } else {
            let url = URL(string: "https://www.gmcmap.com/mobileforget.asp?userid="+userEmail!)
            let urlRequest = URLRequest(url: url!)
            
            
            let session = URLSession.shared
            let task = session.dataTask(with: urlRequest, completionHandler: {
                (data, response, error) in
                guard error == nil else {
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments ) as? [String:Any] {
                        self.responseStatus = json["status"] as! String
                        //      print("responseStatus in do catch 121 is" + self.responseStatus)
                        if (self.responseStatus != ("success")){
                            if (self.responseStatus == ("noUserError")) {
                                self.displayMessage(userMessage: "The user does not exist.")
                            } else if (self.responseStatus == ("unknown")){
                                self.displayMessage(userMessage: "Unable to send email, please register")
                            }
                        }
                        
                    }
                    print("responseStatus in do catch is" + self.responseStatus)
                } catch let err{
                    print(err.localizedDescription)
                }
            })
            
            if ((responseStatus == ("success")) || (responseStatus == ("unknown"))){
                
               
                let SignInViewController   = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
                
            
                //    let GraphSubController = self.storyboard?.instantiateViewController(withIdentifier: "GraphSubController") as! GraphSubController
                //   GraphSubController.graphStringPassed = userEmail!
                
            //    UserDataTableViewController.stringPassed2 = userEmail!
            //    UserMainTabBarController.stringPassed = userEmail!
            //    print("sign up pressed passing userEmail " + userEmail!)
                self.present(SignInViewController, animated: true)
                self.navigationController?.pushViewController(SignInViewController, animated: true)
                
                
                /*direct to table ends*/
            }
            task.resume()
            
            
            
            
        }
        
        
        
    }
    
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
