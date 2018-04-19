//
//  DashboardViewController.swift
//  MariGold
//
//  Created by Pravin Sivabalan on 3/24/18.
//  Copyright © 2018 MariGold. All rights reserved.
//

import UIKit
import Alamofire

class DashboardViewController: UIViewController, UITableViewDataSource {
	
	@IBOutlet var nextMedicationLabel: UILabel!
	@IBOutlet weak var incrementButton: UIButton!
    @IBOutlet weak var decrementButton: UIButton!
    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    let today = Date()
    let dateFormatter = DateFormatter()
    var currentDate = Date()
    var daysAdded = 0
    var notifications = [String]()
    var notifMedObject = [Any]()
    var currentWeekday = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentWeekday = Calendar.current.component(.weekday, from: currentDate) - 2
        dateFormatter.dateFormat = "MMM dd, yyyy"
        decrementButton.isEnabled = false
        currentDateLabel.text = dateFormatter.string(from: today)
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshNotifications()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func refreshNotifications() {
        self.notifications = []
        self.notifMedObject = []
        let spinner = UIViewController.displaySpinner(onView: tableView)
        Alamofire.request(api.rootURL + "/notification/cal", method: .get, encoding: JSONEncoding.default, headers: User.header).responseJSON { response in
            UIViewController.removeSpinner(spinner: spinner)
            if let JSON = response.result.value {
                let data = JSON as! NSDictionary
                if(data["error_code"] != nil) {
                    switch data["error_code"] as! Int {
                    default:
                        return self.createAlert(title: "Server Error", message: "There was an issue with the server. Please try again later.")
                    }
                }
                let notifications = data["notifications"] as! [[String:Any]]
                let meds = CoreDataHelper.retrieveMeds()
                for notification in notifications {
                    let dayToTake = notification["day_to_take"] as! Int
                    if(dayToTake == self.currentWeekday) {
                        let timeToTake = notification["time_to_take"] as! String
                        var dateString = timeToTake.components(separatedBy: " ")
                        let time = dateString[4]
                        let medId = notification["medication_id"] as! Int
                        var medName = ""
                        var exists = false
                        for med in meds {

                            if(med.id == medId) {
                                medName = med.name!
                                self.notifMedObject.append(med)
                                exists = true
                                break
                            }
                        }
                        if(exists) {
                            self.notifications.append(medName + " " + self.UTCToLocal(date: time))
                        }
                    }
                }
				var nextMed: String
				if(!self.notifications.isEmpty) {
					nextMed = self.notifications[0]
				}
				else {
					nextMed = "None."
				}
				self.nextMedicationLabel.text = "Next Medication on this day: \(nextMed)"
                self.tableView.reloadData()
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DashNotificationCell", for: indexPath)
        
        // Configure the cell...
        let text = notifications[indexPath.row]
        cell.textLabel?.text = text
        return cell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        if identifier == "displayMedDetails" {
            guard let indexPath = tableView.indexPathForSelectedRow else { NSLog("Could not get index path of selected medication"); return }
            let nextVC = segue.destination as! MedicationDetailsViewController
            let medicationSelected = notifMedObject[indexPath.row] as! Medication
            nextVC.medication = medicationSelected
        }
    }
    
    @IBAction func incrementDateAction(_ sender: UIButton) {
        if(daysAdded < 6) {
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
            currentDateLabel.text = dateFormatter.string(from: currentDate)
            daysAdded += 1
            currentWeekday += 1
            if(currentWeekday > 6) {
                currentWeekday = 0
            }
        }
        if(daysAdded > 0) {
            decrementButton.isEnabled = true
        }
        if(daysAdded >= 6) {
            incrementButton.isEnabled = false
        }
        refreshNotifications()
    }
    
    @IBAction func decrementDateAction(_ sender: UIButton) {
        if(daysAdded > 0) {
            currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            currentDateLabel.text = dateFormatter.string(from: currentDate)
            daysAdded -= 1
            currentWeekday -= 1
            if(currentWeekday < 0) {
                currentWeekday = 6
            }

        }
        if(daysAdded < 6) {
            incrementButton.isEnabled = true
        }
        if(daysAdded == 0) {
            decrementButton.isEnabled = false
        }
        refreshNotifications()
    }
    
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func UTCToLocal(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "h:mm a"
        
        return dateFormatter.string(from: dt!)
    }
    
}

