//
//  AccountEditViewController.swift
//  MariGold
//
//  Created by Devin Sova on 3/26/18.
//  Copyright © 2018 MariGold. All rights reserved.
//

import UIKit
import Alamofire

protocol HandlePharmacySelection {
	func setPharmacyInfo(name: String?, address: String?, phone: String?)
}

class AccountEditViewController: UITableViewController, HandlePharmacySelection {
	
	@IBOutlet var FirstNameField: UITextField!
	@IBOutlet var LastNameField: UITextField!
	@IBOutlet var AllergiesField: UITextField!
	@IBOutlet var NFLSwitch: UISwitch!
	@IBOutlet var NBASwitch: UISwitch!
	@IBOutlet var NCAASwitch: UISwitch!
	@IBOutlet var PharmacyName: UILabel!
	@IBOutlet var PharmacyAddress: UILabel!
	@IBOutlet var PharmacyPhone: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		FirstNameField.text = UserDefaults.standard.string(forKey: "first_name")
		LastNameField.text = UserDefaults.standard.string(forKey: "last_name")
		AllergiesField.text = UserDefaults.standard.string(forKey: "allergies")
		let Leagues = UserDefaults.standard.string(forKey: "league") ?? ""
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
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.navigationController?.navigationBar.topItem!.title = "Edit Account"
	}
	
	func setPharmacyInfo(name: String?, address: String?, phone: String?) {
		PharmacyName.text = name
		PharmacyAddress.text = address
		PharmacyPhone.text = phone
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let identifier = segue.identifier else { return }
		
		if identifier == "displayPharmacyMapView" {
			let nextVC = segue.destination as! PharmacyMapViewController
			nextVC.handlePharmacySelectionDelegate = self
		}
	}
	
	@IBAction func SetPharmacy(_ sender: Any) {
		//It will automatically segue
		self.navigationController?.navigationBar.topItem!.title = " "
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
					self.setAccountDetails()
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
	
	func setAccountDetails() {
		Alamofire.request(api.rootURL + "/user", encoding: JSONEncoding.default, headers: User.header).responseJSON { response in
			if let JSON = response.result.value {
				let data = JSON as! NSDictionary
				if(data.object(forKey: "message") as! String == "ok") {
					let profile = data["profile"] as! NSDictionary
					UserDefaults.standard.set(profile["first_name"] as! String, forKey: "first_name")
					UserDefaults.standard.set(profile["last_name"] as! String, forKey: "last_name")
					UserDefaults.standard.set(profile["email"] as? String ?? "", forKey: "email")
					UserDefaults.standard.set(profile["league"] as? String ?? "", forKey: "league")
					UserDefaults.standard.set(profile["allergies"] as? String ?? "", forKey: "allergies")
				}
				else {
					self.createAlert(title: "Server Error", message: "There is a connection error. Please check your internet connection or try again later")
				}
			}
		}
	}
}
