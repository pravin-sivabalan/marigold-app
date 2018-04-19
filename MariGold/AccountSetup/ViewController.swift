//
//  ViewController.swift
//  MariGold
//
//  Created by Pravin Sivabalan on 1/23/18.
//  Copyright © 2018 MariGold. All rights reserved.
//  View Controller for Login View Controller

import UIKit
import Pastel
import Alamofire
import LocalAuthentication

class ViewController: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

	override func viewDidLoad() {
		super.viewDidLoad()
        
        // Check if there is internet connectivity
        if(!Connectivity.isConnectedToInternet) {
            createAlert(title: "Connection Error", message: "There is a connection error. Please check your internet connection or try again later.")
        }
		
		//Setup pastelView (Can't do in storyboard due to safe area restraint)
		let pastelView = PastelView(frame: view.bounds)
		pastelView.setColors([UIColor(red: 240/255, green: 138/255, blue: 1/255, alpha: 1.0),
							  UIColor(red: 249/255, green: 212/255, blue: 0/255, alpha: 1.0)])
		pastelView.startAnimation()
		view.insertSubview(pastelView, at: 0)
		
		//Navigation Bar Transparent
		self.navigationController?.navigationBar.isTranslucent = true
		self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
		self.navigationController?.navigationBar.shadowImage = UIImage()
        
        // Prompt for TouchID, if credentials are stored
        if let credentials = retrieveCredentials() {
            performTouchID(credentials)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func retrieveCredentials() -> KeychainPasswordItem? {
        guard let passwords = try? KeychainPasswordItem.passwordItems() else {
            return nil
        }
        
        if passwords.count == 0 {
            return nil
        }
        
        return passwords[0]
    }
    
    func performTouchID(_ credentials: KeychainPasswordItem) {
        let context = LAContext()
        let reason = "Authenticate with Touch ID"
    
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { (success, error) in
            if !success {
                return
            }
            
            // Add login with credentials here boyos
			do {
				self.signIn(email: credentials.account, password: try credentials.readPassword(), touchid: true)
			} catch let error {
				NSLog("Error: \(error.localizedDescription)")
			}
        }
    }
    
    @IBAction func signInAction(_ sender: Any) {
        if(!Connectivity.isConnectedToInternet) {
            return createAlert(title: "Connection Error", message: "There is a connection error. Please check your internet connection or try again later.")
        } else if(emailField.text == "" || passwordField.text == "") {
            return createAlert(title: "Not Finished", message: "Please finish filling out fields")
        } else if(!isValidEmail(email: emailField.text!)) {
            return createAlert(title: "Invalid Email", message: "Please enter a valid email")
        }
		signIn(email: emailField.text!, password: passwordField.text!, touchid: false)
    }
	
	func signIn(email: String, password: String, touchid: Bool) {
		let body: [String: Any] = [
			"email" : email,
			"password" : password,
			]
		
		Alamofire.request(api.rootURL + "/user/login", method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
			if let JSON = response.result.value {
				let data = JSON as! NSDictionary
				if(data["error_code"] != nil) {
					switch data["error_code"] as! Int {
					case 20:
						return self.createAlert(title: "Account ", message: "This account does not exist. Please check you have entered your information correctly.")
					case 21:
						return self.createAlert(title: "Incorrect Password", message: "You have entered the incorrect password for this account.")
					default:
						return self.createAlert(title: "Server Error", message: "There is a connection error. Please check your internet connection or try again later.")
					}
				} else if(data.object(forKey: "jwt") != nil) {
					UserDefaults.standard.set(data.object(forKey: "jwt"), forKey: "jwt")
					self.setAccountDetails()
					
					let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
					let vc = storyboard.instantiateViewController(withIdentifier: "tabbarControllerID") as UIViewController
					
					// Store password within keychain
					if !touchid {
						try! KeychainPasswordItem.deleteItems()
						let keychainPassword = KeychainPasswordItem(account: self.emailField.text!)
					
						do {
							try keychainPassword.savePassword(self.passwordField.text!)
						} catch {
							print("Keychain saving error: \(error)")
						}
					}
					
					self.present(vc, animated: true, completion: nil)
					self.updateConflictList()
				} else {
					return self.createAlert(title: "Server Error", message: "There is a connection error. Please check your internet connection or try again later")
				}
			}
		}
	}
	
	func updateConflictList() {
		if(!Connectivity.isConnectedToInternet) {
			return self.createAlert(title: "Connection Error", message: "There is a connection error. Please check your internet connection or try again later.")
		}
		Alamofire.request(api.rootURL + "/meds/conflicts", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: User.header).responseJSON { response in
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
					CoreDataHelper.deleteAllConflicts()
					CoreDataHelper.deleteAllAllergyConflicts()
					CoreDataHelper.saveCoreData()
					
					
					if let JSONconflicts = data["conflicts"] as? [[String: Any]] {
						for JSONconflict in JSONconflicts {
							let newConflict = CoreDataHelper.newConflict()
							newConflict.drug1id = JSONconflict["drug1"] as! Int64
							newConflict.drug2id = JSONconflict["drug2"] as! Int64
							let JSONconflictinfo = JSONconflict["info"] as! [[String : String]]
							newConflict.info = JSONconflictinfo[0]["desc"]
							newConflict.severity = JSONconflictinfo[0]["severity"]
							CoreDataHelper.saveCoreData()
						}
					}
					
					//Allergy Conflicts
					
					if let JSONallergyConflicts = data["allergy_conflicts"] as? [[String: Any]] {
						for JSONallergyConflict in JSONallergyConflicts {
							let newAllergyConflict = CoreDataHelper.newAllergyConflict()
							newAllergyConflict.drugid = JSONallergyConflict["drug"] as! Int64
							newAllergyConflict.allergy = JSONallergyConflict["allergy"] as? String
							newAllergyConflict.type = JSONallergyConflict["type"] as? String
							newAllergyConflict.desc = JSONallergyConflict["desc"] as? String
							CoreDataHelper.saveCoreData()
						}
					}
					CoreDataHelper.saveCoreData()
				}
			}
		}
	}

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
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let match = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return match.evaluate(with: email)
    }

}

