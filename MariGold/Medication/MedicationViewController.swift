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
	@IBOutlet var MedicationTableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		updateMedicationList()
		self.MedicationTableView.reloadData()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let identifier = segue.identifier else { return }
		
		if identifier == "displayMedicationDetails" {
			guard let indexPath = MedicationTableView.indexPathForSelectedRow else { NSLog("Could not get index path of selected medication"); return }
			let nextVC = segue.destination as! MedicationDetailsViewController
			let medicationSelected = CoreDataHelper.retrieveMeds()[indexPath.row]
			nextVC.medication = medicationSelected
		}
	}
	
	@IBAction func Refresh(_ sender: Any) {
		updateMedicationList()
	}
	
	
	func createAlert(title: String, message: String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: nil))
		self.present(alert, animated: true)
	}
	
	func updateMedicationList() {
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
					CoreDataHelper.deleteAllMeds()
					CoreDataHelper.saveCoreData()
					
					let JSONmeds = data["meds"] as! [[String: Any]]
					for JSONmed in JSONmeds {
						let newMed = CoreDataHelper.newMed()
						newMed.id = JSONmed["id"] as! Int64
						newMed.medication_id = JSONmed["medication_id"] as! Int64
						newMed.name = JSONmed["name"] as? String
						newMed.quantity = JSONmed["quantity"] as! Int64
						newMed.run_out_date = JSONmed["run_out_date"] as? String
						newMed.rxcui = JSONmed["rxcui"] as? String
						newMed.temporary = JSONmed["temporary"] as! Bool
						newMed.generic_name = JSONmed["generic_name"] as? String
						newMed.brand_name = JSONmed["brand_name"] as? String
						newMed.warnings_and_cautions = JSONmed["warnings_and_cautions"] as? String
						newMed.inactive_ingredient = JSONmed["inactive_ingredient"] as? String
						newMed.information_for_patients = JSONmed["information_for_patients"] as? String
						newMed.purpose = JSONmed["purpose"] as? String
						newMed.indications_and_usage = JSONmed["indications_and_usage"] as? String
						newMed.questions = JSONmed["questions"] as? String
						newMed.route = JSONmed["route"] as? String
						newMed.warnings = JSONmed["warnings"] as? String
						newMed.when_using = JSONmed["when_using"] as? String
					}
					CoreDataHelper.saveCoreData()
                    
                    self.MedicationTableView.reloadData()
				}
			}
		}
	}
}

//Table view Classes and Methods
class medicationTableViewCell: UITableViewCell {
	@IBOutlet var Label: UILabel!
	@IBOutlet var ID: UILabel!
	@IBOutlet var Temporary: UILabel!
}

extension MedicationViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let medications = CoreDataHelper.retrieveMeds()
		return medications.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Plain Cell", for: indexPath) as! medicationTableViewCell
		let medications = CoreDataHelper.retrieveMeds()
		let medication = medications[indexPath.row]
		cell.Label.text = String(medication.name!.prefix(upTo: medication.name!.index(of: " ") ?? medication.name!.endIndex))
		cell.ID.text = String(medication.id)
		
		if medication.temporary {
			cell.Temporary.isHidden = false
		}
		else {
			cell.Temporary.isHidden = true
		}
		
		if medication.quantity < 1 {
			cell.Label.textColor = UIColor.red
			cell.ID.textColor = UIColor.red
			cell.Temporary.textColor = UIColor.red
		}
		else {
			cell.Label.textColor = UIColor.black
			cell.ID.textColor = UIColor.black
			cell.Temporary.textColor = UIColor.black
		}
		cell.accessibilityIdentifier = cell.Label.text
		return cell
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath) as! medicationTableViewCell
		let medid = cell.ID.text
		
		if editingStyle == .delete {
			let body: [String: Any] = [
				"id" : medid!
			]
            
            let spinner = UIViewController.displaySpinner(onView: tableView)
			Alamofire.request(api.rootURL + "/meds/delete", method: .post, parameters: body, encoding: JSONEncoding.default, headers: User.header).responseJSON
				{ response in
                UIViewController.removeSpinner(spinner: spinner)
				if let JSON = response.result.value {
					let data = JSON as! NSDictionary
					if(data["error_code"] != nil) {
						switch data["error_code"] as! Int {
						//Not sure what other errors there are.
						default:
							return self.createAlert(title: "Server Error", message: "There is a connection error. Please check your internet connection or try again later.")
						}
					} else {
						let idInt = Int64(cell.ID.text!) ?? -1
						CoreDataHelper.deleteConflictsForID(id: idInt)
						CoreDataHelper.saveCoreData()
                        self.Refresh(self)
					}
				}
			}
		}
	}
}
