//
//  ViewController.swift
//  sql-test
//
//  Created by Qing Ran on 3/12/18.
//  Copyright © 2018 Qing Ran. All rights reserved.
//

import UIKit


class UserDataTableViewController: UITableViewController {
    var stringPassed : String?
    
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
    
    
    var tableArray = [String] ()
    var timeArray = [String] ()
    override func viewDidLoad() {
        

        
        super.viewDidLoad()
        parseJSON()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }

  /*  override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.contentInset = UIEdgeInsets(top: 108, left: 0, bottom: 0, right: 0)
    }*/
    
    func parseJSON() {
     //   var ID = "64609518812"
        print("the passed email is " + stringPassed!)
        let url = URL(string:"http://www.gmcmap.com/service4.asp?ID="+stringPassed!)

        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            
            guard error == nil else {
                print("returning error")
                return
            }
            
            guard let content = data else {
                print("not returning data")
                return
            }
            
            
            guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
                print("Not containing JSON")
                self.displayMessage(userMessage: "No data record.")
                return
            }
            
            if var CPMarray = json["CPM"] as? [String] {
                self.tableArray = CPMarray
            }
            if var timeArray = json["time"] as? [String] {
                self.timeArray = timeArray
            }
            
         //  print(self.timeArray)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
        
        task.resume()
        
    }
   
/** login starts
     //  ViewController.swift
     //  XcodeLoginExample
     //
     //  Created by Belal Khan on 29/05/17.
     //  Copyright © 2017 Belal Khan. All rights reserved.
     //
     
     import UIKit
     import Alamofire
     
     class ViewController: UIViewController {
     
     //The login script url make sure to write the ip instead of localhost
     //you can get the ip using ifconfig command in terminal
     let URL_USER_LOGIN = "http://192.168.1.105/SimplifiediOS/v1/login.php"
     
     //the defaultvalues to store user data
     let defaultValues = UserDefaults.standard
     
     //the connected views
     //don't copy instead connect the views using assistant editor
     @IBOutlet weak var labelMessage: UILabel!
     @IBOutlet weak var textFieldUserName: UITextField!
     @IBOutlet weak var textFieldPassword: UITextField!
     
     //the button action function
     @IBAction func buttonLogin(_ sender: UIButton) {
     
     //getting the username and password
     let parameters: Parameters=[
     "username":textFieldUserName.text!,
     "password":textFieldPassword.text!
     ]
     
     //making a post request
     Alamofire.request(URL_USER_LOGIN, method: .post, parameters: parameters).responseJSON
     {
     response in
     //printing response
     print(response)
     
     //getting the json value from the server
     if let result = response.result.value {
     let jsonData = result as! NSDictionary
     
     //if there is no error
     if(!(jsonData.value(forKey: "error") as! Bool)){
     
     //getting the user from response
     let user = jsonData.value(forKey: "user") as! NSDictionary
     
     //getting user values
     let userId = user.value(forKey: "id") as! Int
     let userName = user.value(forKey: "username") as! String
     let userEmail = user.value(forKey: "email") as! String
     let userPhone = user.value(forKey: "phone") as! String
     
     //saving user values to defaults
     self.defaultValues.set(userId, forKey: "userid")
     self.defaultValues.set(userName, forKey: "username")
     self.defaultValues.set(userEmail, forKey: "useremail")
     self.defaultValues.set(userPhone, forKey: "userphone")
     
     //switching the screen
     let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewcontroller") as! ProfileViewController
     self.navigationController?.pushViewController(profileViewController, animated: true)
     
     self.dismiss(animated: false, completion: nil)
     }else{
     //error message in case of invalid credential
     self.labelMessage.text = "Invalid username or password"
     }
     }
     }
     }
     
     override func viewDidLoad() {
     super.viewDidLoad()
     //hiding the navigation button
     let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
     navigationItem.leftBarButtonItem = backButton
     
     // Do any additional setup after loading the view, typically from a nib.
     
     //if user is already logged in switching to profile screen
     if defaultValues.string(forKey: "username") != nil{
     let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewcontroller") as! ProfileViewController
     self.navigationController?.pushViewController(profileViewController, animated: true)
     
     }
     }
     
     override func didReceiveMemoryWarning() {
     super.didReceiveMemoryWarning()
     // Dispose of any resources that can be recreated.
     }
     
     
     }
 **/ // login ends
       

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


extension UserDataTableViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        
        cell.textLabel?.text = self.tableArray[indexPath.row]
        cell.detailTextLabel?.text = self.timeArray[indexPath.row]
        //  cell.tintColor = UIColor.red
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableArray.count
    }
}

