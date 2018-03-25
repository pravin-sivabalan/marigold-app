//
//  AddNotificationTableViewController.swift
//  MariGold
//
//  Created by Pravin Sivabalan on 3/25/18.
//  Copyright © 2018 MariGold. All rights reserved.
//

import UIKit
import PopupDialog
import Alamofire

class AddNotificationTableViewController: UITableViewController {
    var data: [String] = []
    var med: [String: Any] = [:]
    var notifications: [[String:String] ] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(med)
        if((med["phoneNotification"] as! Bool) == false && (med["emailNotification"] as! Bool) == false) {
            print("skip")
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneAction(_ sender: UIButton) {
        //Make API Call
        if(!Connectivity.isConnectedToInternet) {
            return self.createAlert(title: "Connection Error", message: "There is a connection error. Please check your internet connection or try again later.")
        }

//        let body: [String: Any] = [
//            "name" : Name.text!,
//            "cui" : "1",
//            "quantity" : Quantity.text!,
//            "per_week" : TimesPerWeek.text!,
//            "temporary" : Temporary.isOn
//        ]
        var body = med
        
        let emailNotification = med["emailNotification"] as! Bool
        if(emailNotification == true) {
            body["alert_user"] = "1"
        } else {
            body["alert_user"] = "0"
        }
        body["notifications"] = notifications
        body.removeValue(forKey: "phoneNotification")
        body.removeValue(forKey: "emailNotification")

        Alamofire.request(api.rootURL + "/meds/add", method: .post, parameters: body, encoding: JSONEncoding.default, headers: User.header).responseJSON { response in
            if let JSON = response.result.value {
                let data = JSON as! NSDictionary
                print(data)
                if(data["error_code"] != nil) {
                    switch data["error_code"] as! Int {
                    //Room for adding more detailed error messages
                    default:
                        return self.createAlert(title: "Server Error", message: "There was an issue with the server. Please try again later.")
                    }
                }
            }
        }
    


//        If Successful Pop View Controller
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    @IBAction func addNotificationAction(_ sender: UIBarButtonItem) {
        createPopup()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath)

        // Configure the cell...
        let text = data[indexPath.row]
        cell.textLabel?.text = text
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            data.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    func createPopup() {
        let notifVC = AddNotificationViewController(nibName: "AddNotificationViewController", bundle: nil)
        let popup = PopupDialog(viewController: notifVC, buttonAlignment: .horizontal, transitionStyle: .bounceDown, gestureDismissal: true)
        
        let cancelButton = CancelButton(title: "CANCEL") {
            print("cancelled")
        }
        
        let buttonTwo = DefaultButton(title: "ADD", height: 60) {
            let weekday = notifVC.weekdays[notifVC.weekdayPicker.selectedRow(inComponent: 0)]
            let hour = notifVC.hours[notifVC.weekdayPicker.selectedRow(inComponent: 1)]
            let minute = notifVC.minutes[notifVC.weekdayPicker.selectedRow(inComponent: 2)]
            let meridiem = notifVC.meridiem[notifVC.weekdayPicker.selectedRow(inComponent: 3)]
            let displayNotification = weekday + " " + hour + ":" + minute + " " + meridiem
            let notificationTime = hour + ":" + minute + " " + meridiem
            let today = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let newNotification = [
                "day": String(notifVC.weekdayPicker.selectedRow(inComponent: 1)),
                "time": dateFormatter.string(from: today) + ":" + self.localToUTC(date: notificationTime)
            ]
  
            self.data.append(displayNotification)
            self.notifications.append(newNotification)
            self.tableView.reloadData()
        }
        
        // Add buttons to dialog
        popup.addButtons([cancelButton, buttonTwo])
        
        // Present dialog
        present(popup, animated: true, completion: nil)
        
    }
    
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func localToUTC(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "H:mm:ss"
        
        return dateFormatter.string(from: dt!)
    }

}
