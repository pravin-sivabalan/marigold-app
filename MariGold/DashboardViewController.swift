//
//  DashboardViewController.swift
//  MariGold
//
//  Created by Pravin Sivabalan on 3/24/18.
//  Copyright © 2018 MariGold. All rights reserved.
//

import UIKit
import Alamofire

class DashboardViewController: UIViewController {
    
    
    @IBOutlet weak var incrementButton: UIButton!
    @IBOutlet weak var decrementButton: UIButton!
    @IBOutlet weak var currentDateLabel: UILabel!
    let today = Date()
    let dateFormatter = DateFormatter()
    var currentDate = Date()
    var daysAdded = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        decrementButton.isEnabled = false
        currentDateLabel.text = dateFormatter.string(from: today)
        
        Alamofire.request(api.rootURL + "/notification/cal", method: .get, encoding: JSONEncoding.default, headers: User.header).responseJSON { response in
            if let JSON = response.result.value {
                let data = JSON as! NSDictionary
                print(data)
                if(data["error_code"] != nil) {
                    switch data["error_code"] as! Int {
                    default:
                        return self.createAlert(title: "Server Error", message: "There was an issue with the server. Please try again later.")
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }

//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath)
//
//        // Configure the cell...
////        let text = sections[indexPath.row]
////        cell.textLabel?.text = text
////        return cell
//
//    }
    
    @IBAction func incrementDateAction(_ sender: UIButton) {
        if(daysAdded < 6) {
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
            
            currentDateLabel.text = dateFormatter.string(from: currentDate)
            
            daysAdded += 1
        }
        if(daysAdded > 0) {
            decrementButton.isEnabled = true
        }
        if(daysAdded >= 6) {
            incrementButton.isEnabled = false
        }
    }
    
    @IBAction func decrementDateAction(_ sender: UIButton) {
        if(daysAdded > 0) {
            currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            
            currentDateLabel.text = dateFormatter.string(from: currentDate)
            
            daysAdded -= 1
        }
        if(daysAdded < 6) {
            incrementButton.isEnabled = true
        }
        if(daysAdded == 0) {
            decrementButton.isEnabled = false
        }
    }
    
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}
