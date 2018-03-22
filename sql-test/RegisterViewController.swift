//
//  RegisterViewController.swift
//  sql-test
//
//  Created by Qing Ran on 3/15/18.
//  Copyright © 2018 Qing Ran. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    
 var redirectToSignUp = false
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var reenterPasswordTextField: UITextField!
   // @IBOutlet weak var deviceIDTextField: UITextField!
    
    @IBAction func regSignUpButton(_ sender: Any) {
       
        print("Sign Up button tapped")
        
        
        //validate fields not empty
        if(emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)!  || (reenterPasswordTextField.text?.isEmpty)!{
            displayMessage(userMessage: "Please fill in all fields")
            return
        }
        
        
        //validate pwd1 = pwd2
        if ((passwordTextField.text?.elementsEqual(reenterPasswordTextField.text!))! != true) {
            displayMessage(userMessage: "Please double check the passwords")
            return
        }
        
        let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        
        // Position Activity Indicator in the center of the main view
        myActivityIndicator.center = view.center
        
        // If needed, you can prevent Acivity Indicator from hiding when stopAnimating() is called
        myActivityIndicator.hidesWhenStopped = false
        
        // Start Activity Indicator
        myActivityIndicator.startAnimating()
        
        // Call stopAnimating() when need to stop activity indicator
        //myActivityIndicator.stopAnimating()
        
        
        // Added 03.20.2018 reference: grokswift "parse json swift 4"
        // Construct struct for registering
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
        
        let userPassword = passwordTextField.text
        
        
     //   func newUserReg (_ userPassword: String, completionHandler: @escaping(newUserInformation?, Error?) -> Void) {
      //  let endpoint = newUserInformation.endpointForPassword(userPassword!)
        let endpoint = "https://www.gmcmap.com/reg.asp?email="+emailTextField.text!+"&pwd="+passwordTextField.text!
       /*     guard let url = URL(string: endpoint) else {
                print("Can not find URL")
                displayMessage(userMessage:  "invalid URL")
               // completionHandler(nil, el)
                return
            }*/
        let url = URL(string: endpoint)
        let urlRequest = URLRequest(url: url!)
            
            
            let session = URLSession.shared
       /*     let task = session.dataTask(with: urlRequest, completionHandler: {
                (data, response, error) in
                // handle response to request
                // check for error
                guard error == nil else {
                  //  completionHandler(nil, error!)
                    self.displayMessage(userMessage: error as! String)
                    return
                }
                // make sure we got data in the response
                guard let responseData = data else {
                    print("Error: did not receive data")
                  // let error = BackendError.objectSerialization(reason: "No data in response")
                  //  completionHandler(nil, error)
                     self.displayMessage(userMessage:  "URL no response")
                    return
                }
                
                // parse the result as JSON
                // then create a Todo from the JSON
                do {
                    if let newUserJSON = try JSONSerialization.jsonObject(with: responseData, options:.allowFragments) as? [String: Any]{
                      
                        let responseEmail = newUserJSON["status"] as? String
                   
                        self.displayMessage(userMessage: responseEmail!)
               
                    } catch let err{
                        print(err.localizedDescription)
                    }
            })*/
        let task = session.dataTask(with: urlRequest, completionHandler: {
            (data, response, error) in
            guard error == nil else {
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments ) as? [String:Any] {
                    var status = json["status"] as! String
                    
               //     self.responseStatus = json["status"] as! String
                    //      print("responseStatus in do catch 121 is" + self.responseStatus)
                    if (status != ("success")){
                        self.displayMessage(userMessage: "User Exists")
                      /*  if (self.responseStatus == ("noUserError")) {
                            self.displayMessage(userMessage: "The user does not exist.")
                        } else if (self.responseStatus == ("incorrectPasswordError")){
                            self.displayMessage(userMessage: "You entered incorrect password.")
                        }*/
                        
                    } else {
                        self.displayMessage(userMessage:"User created, continue to log in.")
                        
                    }
                    self.redirectToSignUp = true
                    
                }
         //       print("responseStatus in do catch is" + self.responseStatus)
            } catch let err{
                print(err.localizedDescription)
            }
        })
        
        
        
        if (redirectToSignUp == true){
            
            let SignInViewController = self.storyboard?.instantiateViewController(withIdentifier:"SignInViewController") as! SignInViewController
            
            self.present(SignInViewController, animated: true)
            
            
            /*direct to table ends*/
        }
        
          task.resume()
            
      //  }
        
        
        
    /*    view.addSubview(myActivityIndicator)
        
        let regUrl = URL(string: "https://www.gmcmap.com/reg.asp")
        var request = URLRequest(url: regUrl!)
    //    self.dismiss(animated: true, completion: nil)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField:"content-type")
        request.addValue("application/json", forHTTPHeaderField:"Accept")
        
        let postString = ["email": emailTextField.text!,"password": passwordTextField.text!,"device": deviceIDTextField.text!
    ] as [String: String]*/
    /*
    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
    } catch let error {
        print(error.localizedDescription)
        displayMessage(userMessage:  "Please make sure that the passwords match")
            return
    }*/
    
    
    //    UserDefaults.standardUserDefaults.setObject(emailTextField, forKey: passwordTextField)
        
 /*  let task = URLSession.shared.dataTask(with: request) {(data: Data?, response:URLResponse?, error: Error? ) in
        
    self.removeActivityIndicator(activityIndicator: myActivityIndicator)
    
    if error != nil {
    //    self.displayMessage(userMessage:"Could not successfullt perform this request. Please try again later")
        self.displayMessage(userMessage: "error != nil")
        print("error=\(String(describing:error))")
        return
    }
    /*
        
        guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
            print("Not containing JSON")
            return
        }
        
        if var CPMarray = json["CPM"] as? [String] {
            self.tableArray = CPMarray
        }
        if var timeArray = json["time"] as? [String] {
            self.timeArray = timeArray
        }
        **/
  /*  do {
        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
        if let parseJSON = json {
            let userId = parseJSON["userId"] as? String
           // print("User id: \(String(describing: userId？))")
            if (userId?.isEmpty)! {
                // Display an Alert dialog with a friendly error message
             //   self.displayMessage(userMessage: "User ID is empty")
                return
            } else {
                self.displayMessage(userMessage: "Successfully Registered a New Account. Please proceed to Sign in")
            }
            
        } else {
            //Display an Alert dialog with a friendly error message
          //  self.displayMessage(userMessage: "Error 2")
        }
    } catch {
        
        self.removeActivityIndicator(activityIndicator: myActivityIndicator)
    
        // Display an Alert dialog with a friendly error message
     //   self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later")
       // self.displayMessage(userMessage:"Error\(error)")
     //   print(error)
    }*/

}*/
        
  //  task.resume()
        
    }
    



    func removeActivityIndicator(activityIndicator: UIActivityIndicatorView)
    {
        DispatchQueue.main.async
            {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
        }
    }
    
    // notif
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
        // Do any additional setup after loading the view.
    

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
