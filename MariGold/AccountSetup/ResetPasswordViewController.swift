//
//  ResetPasswordViewController.swift
//  MariGold
//
//  Created by Devin Sova on 2/19/18.
//  Copyright © 2018 MariGold. All rights reserved.
//

import UIKit
import Pastel

class ResetPasswordViewController: UIViewController {
	@IBOutlet var pastelView: PastelView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//Setup PastelView
		pastelView.setColors([UIColor(red: 240/255, green: 138/255, blue: 1/255, alpha: 1.0),
							  UIColor(red: 249/255, green: 212/255, blue: 0/255, alpha: 1.0)])
		pastelView.startAnimation()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}
