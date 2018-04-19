//
//  DashboardTabViewController.swift
//  MariGold
//
//  Created by Andrew Bass on 4/18/18.
//  Copyright © 2018 MariGold. All rights reserved.
//

import UIKit

protocol TabViewController {
    func viewBecameActive()
}

class DashboardTabViewController: UIViewController {
    @IBOutlet weak var segmentControl: UISegmentedControl!
	@IBOutlet var NextMedication: UILabel!
	@IBOutlet weak var scheduleView: UIView!
    @IBOutlet weak var sideEffectsView: UIView!
    
    var views: [UIView]!
    var activeView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        views = [scheduleView, sideEffectsView]
        for view in views {
            view.isHidden = true
        }
        
        segmentControl.selectedSegmentIndex = 0
        activeView = views[0]
        
        show(views[0])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func show(_ view: UIView) {
        activeView.isHidden = true
        view.isHidden = false
    
        activeView = view
    }
    
    @IBAction func selectedTab(_ sender: UISegmentedControl) {
        show(views[sender.selectedSegmentIndex])
    }
}
