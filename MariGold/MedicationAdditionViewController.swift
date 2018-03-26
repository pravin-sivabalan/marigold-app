//
//  MedicationAdditionViewController.swift
//  MariGold
//
//  Created by Devin Sova on 3/4/18.
//  Copyright © 2018 MariGold. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class MedicationAdditionTableViewController: UITableViewController {
	
	//Outlets
	@IBOutlet var Name: UITextField!
	@IBOutlet var Dosage: UITextField!
	@IBOutlet var Quantity: UITextField!
	@IBOutlet var TimesPerWeek: UITextField!
	@IBOutlet var Done: UIBarButtonItem!
	@IBOutlet var Temporary: UISwitch!
	
	//Check if Required Fields are filled out so Done can be pressed
	@IBAction func RequiredFieldsChanged(_ sender: Any) {
		if(Name.text != "" && Dosage.text != "" && Quantity.text != "" && TimesPerWeek.text != "") {
			Done.isEnabled = true
		}
		else {
			Done.isEnabled = false
		}
	}
	
	//Nav Bar
	@IBAction func Cancel(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
	
	@IBAction func Done(_ sender: Any) {
		//Make API Call
		if(!Connectivity.isConnectedToInternet) {
			return self.createAlert(title: "Connection Error", message: "There is a connection error. Please check your internet connection or try again later.")
		}
			
		//Valid Input
		else {
			let body: [String: Any] = [
				"name" : Name.text!,
				"cui" : "198405",
				"quantity" : Quantity.text!,
				"per_week" : TimesPerWeek.text!,
				"temporary" : Temporary.isOn,
				"notifications" : [String](),
				"alert_user" : 0
			]
			
			Alamofire.request(api.rootURL + "/meds/add", method: .post, parameters: body, encoding: JSONEncoding.default, headers: User.header).responseJSON { response in
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
						//If Successful Pop View Controller
						self.navigationController?.popViewController(animated: true)
					}
				}
			}
		}
		
	}
	
	//Helper Methods
	func createAlert(title: String, message: String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: nil))
		self.present(alert, animated: true)
	}
}
