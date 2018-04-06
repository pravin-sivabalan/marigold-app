//
//  AccountEditViewController.swift
//  MariGold
//
//  Created by Devin Sova on 3/26/18.
//  Copyright © 2018 MariGold. All rights reserved.
//

import UIKit
import Alamofire

class AccountEditViewController: UITableViewController {
	@IBOutlet var FirstNameField: UITextField!
	@IBOutlet var LastNameField: UITextField!
	@IBOutlet var AllergiesField: UITextField!
	@IBOutlet var NFLSwitch: UISwitch!
	@IBOutlet var NBASwitch: UISwitch!
	@IBOutlet var NCAASwitch: UISwitch!
	var FirstName: String!
	var LastName: String!
	var Leagues: String!
	var Allergies: String!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		FirstNameField.text = FirstName
		LastNameField.text = LastName
		AllergiesField.text = Allergies
		if Leagues.contains("NFL") {
			NFLSwitch.isOn = true
		}
		else {
			NFLSwitch.isOn = false
		}
		
		if Leagues.contains("NBA") {
			NBASwitch.isOn = true
		}
		else {
			NBASwitch.isOn = false
		}
		
		if Leagues.contains("NCAA") {
			NCAASwitch.isOn = true
		}
		else {
			NCAASwitch.isOn = false
		}
	}
	
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
			var leagueArray = [String]()
			if(NFLSwitch.isOn) {
				leagueArray.append("NFL")
			}
			if(NBASwitch.isOn) {
				leagueArray.append("NBA")
			}
			if(NCAASwitch.isOn) {
				leagueArray.append("NCAA")
			}
			let leagues = leagueArray.joined(separator: ", ")
			
			let body: [String: Any] = [
				"first_name" : FirstNameField.text!,
				"last_name" : LastNameField.text!,
				"allergies" : AllergiesField.text!,
				"league" : leagues
			]
			
			Alamofire.request(api.rootURL + "/update/profile", method: .post, parameters: body, encoding: JSONEncoding.default, headers: User.header).responseJSON { response in
				if let JSON = response.result.value {
					let data = JSON as! NSDictionary
					if(data["error_code"] != nil) {
						switch data["error_code"] as! Int {
						//Room for adding more detailed error messages
						default:
							return self.createAlert(title: "Server Error", message: "There is a connection error. Please check your internet connection or try again later.")
						}
					}
					//If Successful Pop View Controller
					self.navigationController?.popViewController(animated: true)
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