//
//  ViewController.swift
//  MariGold
//
//  Created by Pravin Sivabalan on 1/23/18.
//  Copyright © 2018 MariGold. All rights reserved.
//  View Controller for Login View Controller

import UIKit
import Pastel

class ViewController: UIViewController {
	
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
}

