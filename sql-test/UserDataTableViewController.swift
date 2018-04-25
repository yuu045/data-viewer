//
//  ViewController.swift
//  sql-test
//
//  Created by Qing Ran on 3/12/18.
//  Copyright © 2018 Qing Ran. All rights reserved.
//

import UIKit


//var refreshControl: UIRefreshControl!
let defaults = UserDefaults.standard
let username = defaults.string(forKey: "userEmail")

var url = URL(string:"http://www.gmcmap.com/mobilehis.asp?email=" + username!)

class UserDataTableViewController: UITableViewController {
    var stringPassedEmail = ""
    @IBOutlet weak var statusBar: UINavigationBar!
    
    @IBOutlet weak var segmentControlTab: UISegmentedControl!
    
    @IBAction func segmentController(_ sender: Any) {
       
        switch segmentControlTab.selectedSegmentIndex
        {
        case 0:
           // textLabel.text = "First Segment Selected";
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
             url = URL(string:"http://www.gmcmap.com/mobilehis.asp?email=" + username!)
            
            parseJSON()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
        case 1:
          //  textLabel.text = "Second Segment Selected";
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            url = URL(string:"http://www.gmcmap.com/mobilehisthreshold.asp?email=" + username!)
            parseJSON()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
           
        default:
            break
        }
    }
    
    
   // @IBOutlet weak var statusBar: UINavigationBar!
    
   
  
    
   
  
   // var stringPassed = "sda"
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
         UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
      //  UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.setNavBarToTheView()
        
    //    print(stringPassed2)
     
        
         let SignInViewController = storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
      //  print("stringpassedEmail is " + username!)
       statusBar.barTintColor = UIColor.white // Set any colour
        
        statusBar.isTranslucent = false
        
        statusBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.black]
        
      /*  let barView = UIView(frame: CGRect(x:0, y:0, width:view.frame.width, height:UIApplication.shared.statusBarFrame.height - 10))
        barView.backgroundColor = UIColor.white
         
        
        view.addSubview(barView)*/
       
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        
        
        //hiding back button
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
      
        // Do any additional setup after loading the view, typically from a nib.
        
        parseJSON()
     //   UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

  /*  override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.contentInset = UIEdgeInsets(top: 108, left: 0, bottom: 0, right: 0)
    }*/
    func setNavBarToTheView() {
        self.statusBar.frame = CGRect(x: 0, y: 0, width: 320, height: 50)  // Here you can set you Width and Height for your navBar
        self.statusBar.backgroundColor = (UIColor.white)
        self.view.addSubview(statusBar)
    }
    
    func parseJSON() {
     //   var ID = "64609518812"
      
        
       //  let username = defaults.string(forKey: "userEmail")
       //  print("the passed email is " + username!)
      
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
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
            
            if let CPMarray = json["CPM"] as? [String] {
                self.tableArray = CPMarray
            }
            if let timeArray = json["time"] as? [String] {
                self.timeArray = timeArray
            }
         //   UIApplication.shared.isNetworkActivityIndicatorVisible = false
         //  print(self.timeArray)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        
        
        task.resume()
        
    }

       

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


extension UserDataTableViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        
        cell.textLabel?.text = self.tableArray[indexPath.row + 1]
        cell.detailTextLabel?.text = self.timeArray[indexPath.row + 1]
        //  cell.tintColor = UIColor.red
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableArray.count
    }
}

