//
//  RegisterLeagueViewController.swift
//  MariGold
//
//  Created by Pravin Sivabalan on 4/15/18.
//  Copyright © 2018 MariGold. All rights reserved.
//

import UIKit
import Pastel

class RegisterLeagueViewController: UIViewController {
    var userInfo: [String: Any] = [:]
    
    @IBOutlet weak var NFLSwitch: UISwitch!
    @IBOutlet weak var NBASwitch: UISwitch!
    @IBOutlet weak var NCAASwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let pastelView = PastelView(frame: view.bounds)
        pastelView.setColors([UIColor(red: 240/255, green: 138/255, blue: 1/255, alpha: 1.0),
                              UIColor(red: 249/255, green: 212/255, blue: 0/255, alpha: 1.0)])
        pastelView.startAnimation()
        view.insertSubview(pastelView, at: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
        userInfo["league"] = leagues

        let vc = segue.destination as! RegisterAllergyViewController
        vc.userInfo = userInfo
    }
    
}
