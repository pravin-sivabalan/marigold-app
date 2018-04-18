//
//  AllergyConflictDetailsViewController.swift
//  MariGold
//
//  Created by Devin Sova on 4/16/18.
//  Copyright © 2018 MariGold. All rights reserved.
//

import UIKit

class AllergyConflictDetailsViewController: UITableViewController {
	@IBOutlet var Medication: UILabel!
	@IBOutlet var Allergy: UILabel!
	@IBOutlet var TypeLabel: UILabel!
	@IBOutlet var Desc: UILabel!
	var AllergyConflict: AllergyConflict!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		Medication.text = CoreDataHelper.retrieveMedWithID(id: AllergyConflict.drugid)?.name
		Allergy.text = AllergyConflict.allergy
		TypeLabel.text = AllergyConflict.type
		Desc.text = AllergyConflict.desc
	}
}
