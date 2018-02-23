//
//  MedicationViewController.swift
//  MariGold
//
//  Created by Devin Sova on 2/21/18.
//  Copyright © 2018 MariGold. All rights reserved.
//

import UIKit
import Alamofire

class MedicationViewController: UIViewController {
	@IBOutlet var medicationTableView: UITableView!
	var medicationArray: [[String: Any]] = [[String: Any]]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		getMedicationList()
	}
	
	//Refresh Button (Might remove later)
	@IBAction func refreshButton(_ sender: Any) {
		getMedicationList()
	}
	
	//Helper createAlert function
	func createAlert(title: String, message: String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
		self.present(alert, animated: true)
	}

	////////////////////////////////////////
	// API Calls
	///////////////////////////////////////
	
	//Medication Add Navigation Menu Item
	@IBAction func medicationAdd(_ sender: Any) {
		let alert = UIAlertController(title: "Add Medication", message: "Enter the name of the Medication:", preferredStyle: .alert)
		alert.addTextField { (inputTextField) in
			inputTextField.placeholder = "Medication Name";
		}
		alert.addAction(UIAlertAction(title: NSLocalizedString("Add", comment: "Default action"), style: .default, handler: { _ in
			guard let inputTextField = alert.textFields?.first else {
				NSLog("Could not find inputTextField in alert")
				return
			}
			self.addMedicationAction(input: inputTextField);
		})
		)
		alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel Action"), style: .cancel, handler: { _ in
			NSLog("The \"Cancel\" action occured.")
		}))
		self.present(alert, animated: true, completion: nil)
	}
	
	func addMedicationAction(input: UITextField) {
		if(!Connectivity.isConnectedToInternet) {
			return self.createAlert(title: "Connection Error", message: "There is a connection error. Please check your internet connection or try again later.")
		}
		else if(input.text == "") {
			return self.createAlert(title: "Try Again", message: "Please enter the name of the medication you wish to add.")
		}
			
		//Valid Input
		else {
			let body: [String: Any] = [
				"name" : input.text!,
				"dose" : "30",
				"expir_date" : "04 09 2018"
			]
			
			Alamofire.request(api.rootURL + "/meds/add", method: .post, parameters: body, encoding: JSONEncoding.default, headers: User.header).responseJSON { response in
				if let JSON = response.result.value {
					let data = JSON as! NSDictionary
					if(data["error_code"] != nil) {
						switch data["error_code"] as! Int {
						//Not sure what other errors there are.
							default:
								return self.createAlert(title: "Server Error", message: "There is a connection error. Please check your internet connection or try again later.")
						}
					}
					else {
						self.getMedicationList()
					}
				}
			}
		}
	}
	func getMedicationList() {
		if(!Connectivity.isConnectedToInternet) {
			return self.createAlert(title: "Connection Error", message: "There is a connection error. Please check your internet connection or try again later.")
		}
		Alamofire.request(api.rootURL + "/meds/for-user", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: User.header).responseJSON { response in
			if let JSON = response.result.value {
				let data = JSON as! NSDictionary
				let meds = data["meds"] as! [[String: Any]]
				self.medicationArray = meds
				self.medicationTableView.reloadData()
			}
		}
	}
}

////////////////////////////////////////
// Table View Cell Class and Methods
///////////////////////////////////////

class medicaitonTableViewCell: UITableViewCell {
	@IBOutlet var label: UILabel!
	@IBOutlet var ID: UILabel!
}

extension MedicationViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return medicationArray.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Plain Cell", for: indexPath) as! medicaitonTableViewCell
		cell.label.text = medicationArray[indexPath.row]["name"] as? String
		let ID:Int = (medicationArray[indexPath.row]["id"] as? Int)!
		cell.ID.text = String(ID)
		cell.accessibilityIdentifier = cell.label.text
		return cell
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		
		let cell = tableView.cellForRow(at: indexPath) as! medicaitonTableViewCell
		let medid = cell.ID.text
		
		if editingStyle == .delete {
			let body: [String: Any] = [
				"id" : medid!
			]
			Alamofire.request(api.rootURL + "/meds/delete", method: .post, parameters: body, encoding: JSONEncoding.default, headers: User.header).responseJSON
				{ response in
				if let JSON = response.result.value {
					let data = JSON as! NSDictionary
					if(data["error_code"] != nil) {
						switch data["error_code"] as! Int {
						//Not sure what other errors there are.
						default:
							return self.createAlert(title: "Server Error", message: "There is a connection error. Please check your internet connection or try again later.")
						}
					}
					else {
							self.getMedicationList()
					}
				}
			}
		}
	}
}


