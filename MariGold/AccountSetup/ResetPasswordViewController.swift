//
//  ResetPasswordViewController.swift
//  MariGold
//
//  Created by Devin Sova on 2/19/18.
//  Copyright © 2018 MariGold. All rights reserved.
//

import UIKit
import Pastel
import Alamofire

class ResetPasswordViewController: UIViewController {
	@IBOutlet var pastelView: PastelView!
    @IBOutlet weak var emailField: UITextField!
    
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//Setup PastelView
		pastelView.setColors([UIColor(red: 240/255, green: 138/255, blue: 1/255, alpha: 1.0),
							  UIColor(red: 249/255, green: 212/255, blue: 0/255, alpha: 1.0)])
		pastelView.startAnimation()
	}
    
    @IBAction func resetPasswordAction(_ sender: Any) {
        if(!Connectivity.isConnectedToInternet) {
            return createAlert(title: "Connection Error", message: "There is a connection error. Please check your internet connection or try again later.")
        } else if(emailField.text == "") {
            return createAlert(title: "Not Finished", message: "Please enter your email address.")
        } else if(!isValidEmail(email: emailField.text!)) {
            return createAlert(title: "Invalid Email", message: "Please enter a valid email.")
        }
        
        Alamofire.request(api.rootURL + "/user/change-password/" + emailField.text!, method: .post, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            if let JSON = response.result.value {
                let data = JSON as! NSDictionary
                print(data)
                if(data["error_code"] != nil) {
                    switch data["error_code"] as! Int {
                        case 20:
                            return self.createAlert(title: "Account ", message: "This account does not exist. Please check you have entered your information correctly.")
                        default:
                            return self.createAlert(title: "Server Error", message: "There is a connection error. Please check your internet connection or try again later.")
                    }
                } else if(data.object(forKey: "message") as! String == "ok") {
                    return self.createAlert(title: "Success", message: "Please check your email for more instructions on resetting your password.")
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
    
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}
