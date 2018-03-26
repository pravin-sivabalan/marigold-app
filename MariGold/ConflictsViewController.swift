//
//  ConflictsViewController.swift
//  MariGold
//
//  Created by Devin Sova on 3/25/18.
//  Copyright © 2018 MariGold. All rights reserved.
//

import UIKit

class ConflictsViewController: UIViewController {
	@IBOutlet var ConflictTableView: UITableView!
	var medication: Medication!
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let identifier = segue.identifier else { return }
		
		if identifier == "displayConflictDetails" {
			guard let indexPath = ConflictTableView.indexPathForSelectedRow else { NSLog("Could not get index path of selected medication"); return }
			let nextVC = segue.destination as! ConflictDetailsViewController
			let conflictSelected = CoreDataHelper.retrieveConflictsForID(id: medication.id)[indexPath.row]
			nextVC.conflict = conflictSelected
		}
	}
}

class conflictTableViewCell: UITableViewCell {
	@IBOutlet var ConflictLabel: UILabel!
	
}

extension ConflictsViewController: UITableViewDataSource {
	
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let conflicts = CoreDataHelper.retrieveConflictsForID(id: medication.id)
		return conflicts.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Plain Cell", for: indexPath) as! conflictTableViewCell
		let conflicts = CoreDataHelper.retrieveConflictsForID(id: medication.id)
		let conflict = conflicts[indexPath.row]
		var otherMedName: String
		if(self.medication.id == conflict.drug1id) {
			otherMedName = CoreDataHelper.retrieveMedWithID(id: conflict.drug2id)?.name ?? "Error"
		}
		else {
			otherMedName = CoreDataHelper.retrieveMedWithID(id: conflict.drug1id)?.name ?? "Error"
		}
		
		cell.ConflictLabel.text = "\(medication.name ?? "Error") & \(otherMedName)"
		return cell
	}
}
