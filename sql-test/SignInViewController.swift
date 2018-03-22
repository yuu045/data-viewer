//
//  SignInViewController.swift
//  sql-test
//
//  Created by Qing Ran on 3/15/18.
//  Copyright © 2018 Qing Ran. All rights reserved.
//

import UIKit






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
    
    
    var responseStatus: String = ""
    
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
        
        

        
        print("sign in button is tapped")
        let userEmail = userNameTextField.text
        let userPassword = userPasswordTextField.text
        
      
      //  instance.stringPassed = userEmail!
        let UserDataTableViewController = storyboard?.instantiateViewController(withIdentifier: "UserDataTableViewController") as! UserDataTableViewController
        UserDataTableViewController.stringPassed = userEmail!
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
                 //      print("responseStatus in do catch 121 is" + self.responseStatus)
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
            print("responseStatus out of do catch is " + self.responseStatus)
           if (responseStatus == ("Success")){
            
            let UserDataTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "UserDataTableViewController") as! UserDataTableViewController
            UserDataTableViewController.stringPassed = userEmail!
            self.present(UserDataTableViewController, animated: true)
            self.navigationController?.pushViewController(UserDataTableViewController, animated: true)
            
        
            /*direct to table ends*/
       }
            task.resume()
        
        
        
        
    
        
        
    }
    
    @IBAction func registerButton(_ sender: Any) {
        print("register button is tapped")
        let registerViewController = self.storyboard?.instantiateViewController(withIdentifier:"RegisterViewController") as! RegisterViewController
        
        self.present(registerViewController, animated: true)
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
