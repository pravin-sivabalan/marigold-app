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

class ViewController: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
	override func viewDidLoad() {
		super.viewDidLoad()
		
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signInAction(_ sender: Any) {
        if(emailField.text == "" || passwordField.text == "") {
            return createAlert(title: "Not Finished", message: "Please finish filling out fields")
        } else if(!isValidEmail(email: emailField.text!)) {
            return createAlert(title: "Invalid Email", message: "Please enter a valid email")
        }
        
        let body: [String: Any] = [
            "email" : emailField.text!,
            "password" : passwordField.text!,
        ]
        
        Alamofire.request(api.rootURL + "/user/login", method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            if let JSON = response.result.value {
                let data = JSON as! NSDictionary
                if(data["error_code"] != nil) {
                    switch data["error_code"] as! Int {
                        case 20:
                            return self.createAlert(title: "Account ", message: "This account does not exist. Please check you have entered your information correctly.")
                        case 21:
                            return self.createAlert(title: "Incorrect Password", message: "You have entered the incorrect password for this account")
                        default:
                            return self.createAlert(title: "Server Error", message: "There is a connection error. Please check your internet connection or try again later")
                    }
                } else if(data["jwt"] != nil) {
                    UserDefaults.standard.set(data["jwt"]!, forKey: "jwt");
                    print("hi")
                    let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "DashboardViewController") as UIViewController
                    self.present(vc, animated: true, completion: nil)
                } else {
                    return self.createAlert(title: "Server Error", message: "There is a connection error. Please check your internet connection or try again later")
                }
            }
        }
    }

    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let match = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return match.evaluate(with: email)
    }

}

