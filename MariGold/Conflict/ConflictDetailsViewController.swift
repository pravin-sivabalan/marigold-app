//
//  ConflictDetailsViewController.swift
//  MariGold
//
//  Created by Devin Sova on 3/26/18.
//  Copyright © 2018 MariGold. All rights reserved.
//

import UIKit

class ConflictDetailsViewController: UITableViewController {
	@IBOutlet var Medication1: UILabel!
	@IBOutlet var Medication2: UILabel!
	@IBOutlet var Severity: UILabel!
	@IBOutlet var Details: UILabel!
	var conflict: Conflict!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		Medication1.text = CoreDataHelper.retrieveMedWithID(id: conflict.drug1id)?.name
		Medication2.text = CoreDataHelper.retrieveMedWithID(id: conflict.drug2id)?.name
		Severity.text = conflict.severity
		Details.text = conflict.info
	}
}
