//
//  MedicationDetailsViewController.swift
//  MariGold
//
//  Created by Devin Sova on 3/22/18.
//  Copyright © 2018 MariGold. All rights reserved.
//

import UIKit
import Alamofire

class MedicationDetailsViewController: UITableViewController{
	
	@IBOutlet var MainNameCell: UITableViewCell!
	@IBOutlet var Name: UILabel!
	@IBOutlet var Quantity: UITextField!
	@IBOutlet var RunOutDate: UITextField!
	@IBOutlet var Temporary: UILabel!
	@IBOutlet var TemporarySwitch: UISwitch!
	@IBOutlet var EditNameField: UITextField!
	
	var medication: Medication!
	var isEditingMedication = false
	
	//Hidden Nav Edit Buttons
	var DoneButton: UIBarButtonItem!
	var CancelButton: UIBarButtonItem!
	var EditButton: UIBarButtonItem!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		populateFieldsWithOGMedication()
		
		DoneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(setEditingMedication(sender:)))
		CancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(setEditingMedication(sender:)))
		EditButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(setEditingMedication(sender:)))
		
		self.navigationItem.setRightBarButton(EditButton, animated: false)
		self.tableView.reloadData()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let identifier = segue.identifier else { return }
		
		if identifier == "displayConflictList" {
			let nextVC = segue.destination as! ConflictsViewController
			nextVC.medication = medication
		}
	}
	
	@IBAction func temporaryOnOffSwitch() {
		if TemporarySwitch.isOn {
			Temporary.text = "Yes"
		}
		else {
			Temporary.text = "No"
		}
	}
	
	func populateFieldsWithOGMedication() {
		Name.text = medication.name ?? "Undefined"
		EditNameField.text = medication.name ?? "Undefined"
		Quantity.text = String(medication.quantity)
		var formattedRunOutDate = medication.run_out_date
		if formattedRunOutDate!.count >= 13 {
			formattedRunOutDate?.removeLast(13)
		}
		RunOutDate.text = formattedRunOutDate
		Temporary.text = String(medication.temporary)
		if TemporarySwitch.isOn {
			Temporary.text = "Yes"
		}
		else {
			Temporary.text = "No"
		}
	}
	
	@objc func setEditingMedication(sender: UIBarButtonItem) {
		//Check for Done Button Pressed
		if sender == DoneButton {
			//Make API call and update fields
				let body: [String: Any] = [
					"med_id" : String(medication.id),
					"name" : EditNameField.text!,
					"quantity" : Quantity.text!,
					"temporary" : TemporarySwitch.isOn
				]
				
				Alamofire.request(api.rootURL + "/update/med", method: .post, parameters: body, encoding: JSONEncoding.default, headers: User.header).responseJSON { response in
					if let JSON = response.result.value {
						let data = JSON as! NSDictionary
						if(data["error_code"] != nil) {
							switch data["error_code"] as! Int {
							//Room for adding more detailed error messages
							default:
								self.populateFieldsWithOGMedication()
								return self.createAlert(title: "Server Error", message: "There is a connection error. Please check your internet connection or try again later.")
							}
						}
						else {
							self.Name.text = self.EditNameField.text
						}
					}
				}
			
			//Successful
		}
		
		if sender == CancelButton {
			//Fix all fields
			populateFieldsWithOGMedication()
		}
		
		if(!isEditingMedication) {
			self.navigationItem.setHidesBackButton(true, animated: true)
			self.navigationItem.setLeftBarButton(CancelButton, animated: true)
			self.navigationItem.setRightBarButton(DoneButton, animated: true)
			
			EditNameField.isEnabled = true
			EditNameField.textAlignment = .left
			Quantity.isEnabled = true
			Quantity.textAlignment = .left
			RunOutDate.textAlignment = .left
			TemporarySwitch.isHidden = false
			Temporary.textAlignment = .left
		}
		else {
			self.navigationItem.setRightBarButton(EditButton, animated: true)
			self.navigationItem.setLeftBarButton(nil, animated: true)
			self.navigationItem.setHidesBackButton(false, animated: true)
			
			EditNameField.isEnabled = false
			EditNameField.textAlignment = .right
			Quantity.isEnabled = false
			Quantity.textAlignment = .right
			RunOutDate.textAlignment = .right
			TemporarySwitch.isHidden = true
			Temporary.textAlignment = .right
		}
		isEditingMedication = !isEditingMedication
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	//Helper Methods
	func createAlert(title: String, message: String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: nil))
		self.present(alert, animated: true)
	}
}
