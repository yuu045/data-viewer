//
//  SignInViewController.swift
//  sql-test
//
//  Created by Qing Ran on 3/15/18.
//  Copyright © 2018 Qing Ran. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


var generalEmail : String = ""

class UserInformation {
    
    var email: String
    var pwd: String
    
    init() {
        self.email = ""
        self.pwd = ""
        
    }
}


class loginStatus : NSObject {
    var status = "initial"
}

var global = loginStatus()


struct newUserInformation: Codable {
    var userEmail: String
    var userPassword: String
    
    
    init?(json: [String: Any]) {
        guard let userEmail = json["userEmail"] as? String,
            let userPassword = json["userPassword"] as? String else {
                return nil
        }
        
        self.userEmail = userEmail
        self.userPassword = userPassword
        
        
        // two functions to be added
        
        
    }
    
    static func endpointForPassword (_ userPassword: String) -> String {
        return "www.gmcmap.com/reg.asp"
    }
    
    enum BackendError: Error {
        case urlError(reason: String)
        case objectSerialization(reason: String)
    }
}





class SignInViewController: UIViewController {
    
    
    lazy var responseStatus: String = ""
   
    
    
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
    

    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    @IBAction func signInButton(_ sender: Any)  {
        
        

         UIApplication.shared.isNetworkActivityIndicatorVisible = true
        print("sign in button is tapped")
        generalEmail = userNameTextField.text!
        let userEmail = userNameTextField.text
        let userPassword = userPasswordTextField.text
        
        
        
      //  instance.stringPassed = userEmail!
        let UserMainTabBarController = storyboard?.instantiateViewController(withIdentifier: "UserMainTabBarController") as! UserMainTabBarController
        
        let UserDataTableViewController = storyboard?.instantiateViewController(withIdentifier: "UserDataTableViewController") as! UserDataTableViewController
    
   
       UserMainTabBarController.stringPassed = userEmail!
     //  UserDataTableViewController.stringPassedEmail = userEmail!
    //   UserDataTableViewController.stringPassed2 = userEmail!

       // navigationController?.pushViewController( UserDataTableViewController, animated: true)
      
        
        if (userEmail!.isEmpty || userPassword!.isEmpty) {
            //   displayAlert("All fields are required.")
            
            displayMessage(userMessage: "Please fill in all fields")
            return
        }
            
            /*JSON parse data starts*/
          //  let url =
            
            
          //  let endpoint = "https://www.gmcmap.com/reg.asp"
            /*     guard let url = URL(string: endpoint) else {
             print("Can not find URL")
             displayMessage(userMessage:  "invalid URL")
             // completionHandler(nil, el)
             return
             }*/
            let url = URL(string: "https://www.gmcmap.com/mobilelogin.asp?name="+userEmail!+"&pwd="+userPassword!)
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
 
                    global.status = self.responseStatus
                    if self.responseStatus == ("Success") {
                        let username:String = userEmail!
                        let password:String = userPassword!
                        
                        let defaults = UserDefaults.standard
                        
                        defaults.set(username, forKey: "userEmail")
                        defaults.set(password, forKey: "userPassword")
                        
                        self.saveLoggedState()
                        self.successLogin()
                    }
                    if (self.responseStatus != ("Success")){
                            if (self.responseStatus == ("noUserError")) {
                                self.displayMessage(userMessage: "The user does not exist.")
                            } else if (self.responseStatus == ("incorrectPasswordError")){
                                self.displayMessage(userMessage: "You entered incorrect password.")
                            }
                        }
                    
                    }
                    print("responseStatus in do catch is" + self.responseStatus)
                } catch let err{
                    print(err.localizedDescription)
                }
            })
            
            
            
            /*JSON parse data ends*/
            print("responseStatus out of do catch is " + global.status)
           if (responseStatus == ("Success") || global.status == ("Success")){
         //   @IBAction func SaveAll(sender: AnyObject) {
            
        //    }
            
            
            let UserDataTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "UserDataTableViewController") as! UserDataTableViewController
            let UserMainTabBarController   = self.storyboard?.instantiateViewController(withIdentifier: "UserMainTabBarController") as! UserMainTabBarController
            let testTableVC = self.storyboard?.instantiateViewController(withIdentifier: "testTableVC") as! testTableVC
        //    let GraphSubController = self.storyboard?.instantiateViewController(withIdentifier: "GraphSubController") as! GraphSubController
         //   GraphSubController.graphStringPassed = userEmail!
            
            UserDataTableViewController.stringPassedEmail = userEmail!
           UserMainTabBarController.stringPassed = userEmail!
            testTableVC.stringPassedEmail = userEmail!
            print("sign up pressed passing userEmail " + userEmail!)
            
          //  self.performSegue(withIdentifier: "UserDataTableViewController", sender: nil)
            
  
            self.present(UserMainTabBarController, animated: true)
          //  self.navigationController?.pushViewController(UserMainTabBarController, animated: true)
            
        
            /*direct to table ends*/
       }
            task.resume()
        
        
        
    
        
    
        
        
    }

    
    
    
    func successLogin() {
        
            OperationQueue.main.addOperation {
               /* self.performSegue(withIdentifier: "UserMainTabBarController", sender: self)*/
                 let UserMainTabBarController   = self.storyboard?.instantiateViewController(withIdentifier: "UserMainTabBarController") as! UserMainTabBarController
                self.present(UserMainTabBarController, animated: true)
            }
        
    }
    
    
    @IBAction func registerButton(_ sender: Any) {
        print("register button is tapped")
        let registerViewController = self.storyboard?.instantiateViewController(withIdentifier:"RegisterViewController") as! RegisterViewController
        
        self.present(registerViewController, animated: true)
    }
    
    func saveLoggedState() {
        let def = UserDefaults.standard
        def.set(true, forKey: "is_authenticated") // save true flag to UserDefaults
        def.synchronize()
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
