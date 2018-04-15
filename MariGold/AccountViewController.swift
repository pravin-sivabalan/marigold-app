//
//  AccountViewController.swift
//  MariGold
//
//  Created by Pravin Sivabalan on 2/21/18.
//  Copyright © 2018 MariGold. All rights reserved.
//

import UIKit
import UserNotifications
import Alamofire

class AccountViewController: UIViewController {
    @IBOutlet weak var leaguesLabel: UILabel!
    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var allergiesLabel: UILabel!
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		getAccountDetails()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		getAccountDetails()
	}
	
	func getAccountDetails() {
		let firstName = UserDefaults.standard.string(forKey: "first_name")
		let lastName = UserDefaults.standard.string(forKey: "last_name")
		displayName.text = "\(firstName ?? "?") \(lastName ?? "?")"
		emailLabel.text = UserDefaults.standard.string(forKey: "email")
		leaguesLabel.text = UserDefaults.standard.string(forKey: "league")
		allergiesLabel.text = UserDefaults.standard.string(forKey: "allergies")
	}
    
    @IBAction func logoutAction(_ sender: Any) {
        let alert = UIAlertController(title: "Logout", message: "Are you sure you would like to logout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive) { (action:UIAlertAction!) in
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            
            UserDefaults.standard.removeObject(forKey: "jwt")
			UserDefaults.standard.removeObject(forKey: "first_name")
			UserDefaults.standard.removeObject(forKey: "last_name")
			UserDefaults.standard.removeObject(forKey: "email")
			UserDefaults.standard.removeObject(forKey: "league")
			UserDefaults.standard.removeObject(forKey: "allergies")
			
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "AccountSetupId") as UIViewController
            self.present(vc, animated: true, completion: nil)
        })
        self.present(alert, animated: true)
        
    }
    
    @IBAction func deleteAccountAction(_ sender: Any) {
        if(!Connectivity.isConnectedToInternet) {
            return createAlert(title: "Connection Error", message: "There is a connection error. Please check your internet connection or try again later.")
        }
        let alert = UIAlertController(title: "Delete Account", message: "Are you sure you would like delete your account FOREVER?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
            return
        })
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { (action:UIAlertAction!) in
            Alamofire.request(api.rootURL + "/user/delete", method: .post, encoding: JSONEncoding.default, headers: User.header).responseJSON { response in
                if let JSON = response.result.value {
                    let data = JSON as! NSDictionary
                    if(data.object(forKey: "message") as! String == "ok") {
                        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                        
						UserDefaults.standard.removeObject(forKey: "jwt")
						UserDefaults.standard.removeObject(forKey: "first_name")
						UserDefaults.standard.removeObject(forKey: "last_name")
						UserDefaults.standard.removeObject(forKey: "email")
						UserDefaults.standard.removeObject(forKey: "league")
						UserDefaults.standard.removeObject(forKey: "allergies")
						
                        try! KeychainPasswordItem.deleteItems()
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "AccountSetupId") as UIViewController
                        self.present(vc, animated: true, completion: nil)
                    } else {
                        self.createAlert(title: "Server Error", message: "There is a connection error. Please check your internet connection or try again later")
                    }
                }
            }
        })
        self.present(alert, animated: true)
    }
    
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
}

