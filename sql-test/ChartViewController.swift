//
//  ChartViewController.swift
//  sql-test
//
//  Created by Qing Ran on 4/5/18.
//  Copyright © 2018 Qing Ran. All rights reserved.
//

import UIKit
import Charts
//import MultiSelectSegmentedControl


protocol GetChartData {
    
    func getChartData(with datPoints: [String], values: [String])
    var workoutDuration: [String] {get set}
    var beatsPerMinute: [String] {get set}
    
    
}


class ChartViewController: UIViewController, GetChartData {
    
    
   
    @IBOutlet weak var statusBar: UINavigationBar!
  
    
    var workoutDuration = [String]()
    var beatsPerMinute = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusBar.barTintColor = UIColor.white // Set any colour
        statusBar.isTranslucent = false
        
        statusBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.black]
        
        let barView = UIView(frame: CGRect(x:10 , y:10, width:view.frame.width, height:UIApplication.shared.statusBarFrame.height))
        barView.backgroundColor = UIColor.white
        
        view.addSubview(barView)
        
        populateChartData()
        barChart()

        // Do any additional setup after loading the view.
    }
    
    func populateChartData() {
        workoutDuration = ["2018-04-20","2018-04-20","2018-04-20","2018-04-20","2018-04-20","2018-04-20","2018-04-20","2018-04-20","2018-04-20","2018-04-20","2018-04-20","2018-04-20","2018-04-20","2018-04-20","2018-04-20","2018-04-20","2018-04-20","2018-04-20","2018-04-20","2018-04-20","2018-04-20","2018-04-20","2018-04-20","2018-04-20","2018-04-20","2018-04-20","2018-04-20","2018-04-20",]
        
        beatsPerMinute=["76", "150", "195", "176", "200", "76","76", "190", "195", "100", "150", "195", "176", "200", "76","76", "190", "195", "100", "150", "195", "176", "200", "76","76", "190", "195", "100", "150", "195", "176", "200", "76","76", "190", "195", "100"]
        
        self.getChartData(with: workoutDuration, values: beatsPerMinute)
        
    }
    
    func getChartData(with dataPoints: [String], values: [String]) {
        self.workoutDuration = dataPoints
        self.beatsPerMinute = values
    }
    
    
    
    
    func barChart() {
        let barChart = BarChart(frame: CGRect(x: 0.0, y: self.view.frame.height * 0.1, width: self.view.frame.width, height: self.view.frame.height * 0.4))
        barChart.delegate = self
        self.view.addSubview(barChart)
    }
    
  /*  public class ChartFormatter: NSObject, IAxisValueFormatter {
        
        
        var workoutDuration = [String]()
        
        public func stringforValue(_ value: Double, axis: AxisBase?) -> String {
            return workoutDuration[Int(value)]
        }
        
        public func setValues(values: [String]) {
            self.workoutDuration = values
        }
    }*/
    
    
    
    
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
