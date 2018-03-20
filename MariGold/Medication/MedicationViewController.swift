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
	
	@IBAction func Refresh(_ sender: Any) {
		getMedicationList()
	}
	
	
	func createAlert(title: String, message: String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: nil))
		self.present(alert, animated: true)
	}
	
	func getMedicationList() {
		if(!Connectivity.isConnectedToInternet) {
			return self.createAlert(title: "Connection Error", message: "There is a connection error. Please check your internet connection or try again later.")
		}
		Alamofire.request(api.rootURL + "/meds/for-user", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: User.header).responseJSON { response in
			if let JSON = response.result.value {
				let data = JSON as! NSDictionary
				if(data["error_code"] != nil) {
					switch data["error_code"] as! Int {
						//Room for adding more detailed error messages
						default:
							return self.createAlert(title: "Server Error", message: "There is a connection error. Please check your internet connection or try again later.")
					}
				}
				else {
					let meds = data["meds"] as! [[String: Any]]
					for med in meds {
					//CoreDataHelper.newMed(dose: med["dose"], id: med["dose"], medication_id: <#T##Int64#>, name: <#T##String#>, quantity: <#T##Int64#>, run_out_date: <#T##String#>, rxcui: <#T##String#>, temporary: <#T##Bool#>)
					}
					//self.medicationArray = meds
					self.medicationTableView.reloadData()
				}
			}
		}
	}
}

//Table view Classes and Methods
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
		let medications = CoreDataHelper.retrieveMeds()
		cell.label.text = medications[indexPath.row].name
		cell.ID.text = String(medications[indexPath.row].id)
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


