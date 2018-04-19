//
//  SideEffectsViewController.swift
//  MariGold
//
//  Created by Andrew Bass on 4/19/18.
//  Copyright © 2018 MariGold. All rights reserved.
//

import UIKit
import Alamofire

struct SideEffect {
    var name: String
    var count: Int
}

class SideEffectsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    
    let nameTag = 1
    let barTag = 2
    let countTag = 3
    
    var sideEffects = [SideEffect]()
    var maxCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.bounces = true
        
        loadSideEffects()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func refreshPressed(_ sender: UIButton) {
        loadSideEffects()
    }
    
    func loadSideEffects() {
        sideEffects.removeAll()
        
        let spinner = UIViewController.displaySpinner(onView: collectionView)
        Alamofire.request(api.rootURL + "/user/side_effects", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: User.header).responseJSON { resp in

            guard let json = resp.result.value as? NSDictionary else {
                self.createAlert(title: "Server Error", message: "Could not call route for side effects.")
                return
            }
            
            if(json["error_code"] != nil) {
                self.createAlert(title: "Server Error", message: "There is a connection error. Please check your internet connection or try again later.")
                return
            }
            
            guard let sideEffectsJson = json["side_effects"] as? NSArray else {
                self.createAlert(title: "Server Error", message: "Expected an array back! Damn you Andrew Bass.")
                return
            }
            
            for sideEffectJson in sideEffectsJson {
                guard let sideEffectDict = sideEffectJson as? NSDictionary else {
                    return
                }
                
                let sideEffect = SideEffect(name: sideEffectDict["name"] as! String, count: sideEffectDict["count"] as! Int)
                self.sideEffects.append(sideEffect)
            }
            
            if self.sideEffects.count > 0 {
                self.maxCount = self.sideEffects[0].count
            }
            
            self.collectionView.reloadData()
            UIViewController.removeSpinner(spinner: spinner)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sideEffects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let sideEffect = sideEffects[indexPath.row]
        
        let label = cell.viewWithTag(nameTag) as! UILabel
        label.text = sideEffect.name
        
        label.adjustsFontSizeToFitWidth = true;
        label.minimumScaleFactor = 0.6;
        
        let count = cell.viewWithTag(countTag) as! UILabel
        count.text = String(sideEffect.count)
        
        let bar = cell.viewWithTag(barTag)!
        let widthConstraint = bar.constraints[0]
        
        let range = count.frame.minX - bar.frame.minX
        let percentage = CGFloat(sideEffect.count) / CGFloat(maxCount)
        
        widthConstraint.constant = CGFloat(range) * percentage
        return cell
    }

    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}
