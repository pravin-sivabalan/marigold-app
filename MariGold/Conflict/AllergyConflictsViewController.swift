//
//  AllergyConflictsViewController.swift
//  MariGold
//
//  Created by Devin Sova on 4/16/18.
//  Copyright © 2018 MariGold. All rights reserved.
//

import UIKit

class AllergyConflictsViewController: UIViewController {
	@IBOutlet var AllergyConflictTableView: UITableView!
	var medication: Medication!
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let identifier = segue.identifier else { return }
		
		if identifier == "displayAllergyConflictDetails" {
			guard let indexPath = AllergyConflictTableView.indexPathForSelectedRow else { NSLog("Could not get index path of selected medication"); return }
			let nextVC = segue.destination as! AllergyConflictDetailsViewController
			let allergyConflictSelected = CoreDataHelper.retrieveAllergyConflictsForID(id: medication.id)[indexPath.row]
			nextVC.AllergyConflict = allergyConflictSelected
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.AllergyConflictTableView.reloadData()
	}
}

class allergyConflictTableViewCell: UITableViewCell {
	@IBOutlet var AllergyConflictLabel: UILabel!
}

extension AllergyConflictsViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let allgeryConflicts = CoreDataHelper.retrieveAllergyConflictsForID(id: medication.id)
		return allgeryConflicts.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Plain Cell", for: indexPath) as! allergyConflictTableViewCell
		let allergyConflicts = CoreDataHelper.retrieveAllergyConflictsForID(id: medication.id)
		let allergyConflict = allergyConflicts[indexPath.row]
		var medName = CoreDataHelper.retrieveMedWithID(id: allergyConflict.drugid)?.name
		medName = String(medName!.prefix(upTo: medName!.index(of: " ") ?? medName!.endIndex))
		cell.AllergyConflictLabel.text = "\(allergyConflict.allergy ?? "?") & \(medName ?? "?")" 
		return cell
	}
}
