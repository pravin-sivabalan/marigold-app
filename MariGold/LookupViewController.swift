//
//  LookupViewController.swift
//
//
//  Created by Andrew Bass on 3/25/18.
//

import UIKit
import Alamofire

struct Match {
    var name: String
    var cui: String
}

class LookupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
	var spinner: UIView!
	
	let imagePicker = UIImagePickerController()
    
    var matches: [Match] = []
    var selectedMatch = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
		imagePicker.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToAdd" {
            guard let dest = segue.destination as? MedicationAdditionTableViewController else {
                return
            }
            
            dest.Name = matches[selectedMatch].name
            dest.Cui = matches[selectedMatch].cui
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
	@IBAction func openPhotoLibraryButton(sender: AnyObject) {
		if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
			imagePicker.sourceType = .photoLibrary
			imagePicker.allowsEditing = true
			self.present(imagePicker, animated: true, completion: nil)
		}
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		NSLog("here!")
		let image = info[UIImagePickerControllerOriginalImage] as! UIImage
		guard let imageData = UIImageJPEGRepresentation(image, 0.5)?.base64EncodedString()
		else {
			return self.createAlert(title: "Image Error", message: "Could not encode image.")
		}
		let fullBase64String = "data:image/png;base64,\(imageData))"
		//Make API Call
		        if(!Connectivity.isConnectedToInternet) {
		            return self.createAlert(title: "Connection Error", message: "There is a connection error. Please check your internet connection or try again later.")
		        }
		
		        //Valid Input
		        else {
		            let body: [String: Any] = [
						"photo" : fullBase64String
		            ]
		
		            Alamofire.request(api.rootURL + "/meds/pic", method: .post, parameters: body, encoding: JSONEncoding.default, headers: User.header).responseJSON { response in
		                if let JSON = response.result.value {
		                    let data = JSON as! NSDictionary
		                    if(data["error_code"] != nil) {
		                        switch data["error_code"] as! Int {
		                        //Room for adding more detailed error messages
		                        default:
		                            return self.createAlert(title: "Server Error", message: "There is a connection error. Please check your internet connection or try again later.")
		                        }
		                    }
						}
					}
		}
		//dismiss(animated:true, completion: nil)
	}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = matches[indexPath.row].name
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMatch = indexPath.row
        performSegue(withIdentifier: "ToAdd", sender: self)
    }
    
    func readInMatches(jsonMatches: [Any]) {
        matches.removeAll()
        
        for match in jsonMatches {
            let obj = match as! NSDictionary
            
            let name = obj["name"] as! String
            let cui = obj["cui"] as! String
            
            matches.append(Match(name: name, cui: cui))
        }
        
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let name = searchBar.text else {
            return
        }
        
        if name == "" {
            return
        }
        
        let body: [String: Any] = [
            "name": name
        ]
        
        spinner = UIViewController.displaySpinner(onView: self.tableView)
        
        let req = Alamofire.request(api.rootURL + "/meds/lookup", method: .post, parameters: body, encoding: JSONEncoding.default, headers: User.header)
        req.responseJSON { resp in
            UIViewController.removeSpinner(spinner: self.spinner)
            
            guard let data = resp.result.value else {
                return
            }
            
            guard let json = data as? NSDictionary else {
                print("Could not read in data as JSON")
                return
            }
            
            guard let message = json["message"] as? String else {
                print("Could not get message")
                return
            }
            
            if (message != "ok") {
                self.createAlert(title: "Lookup", message: "Could not find specified medicine")
            }
            
            guard let jsonMatches = json["matches"] as? [Any] else {
                print("Could not read in matches")
                return
            }
            
            self.readInMatches(jsonMatches: jsonMatches)
        }
    }
    
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

