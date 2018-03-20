//
//  CoreDataHelper.swift
//  MariGold
//
//  Created by Devin Sova on 3/3/18.
//  Copyright © 2018 MariGold. All rights reserved.
//

import UIKit
import CoreData

struct CoreDataHelper {
	static let context: NSManagedObjectContext = {
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
			fatalError()
		}
		let context = appDelegate.persistentContainer.viewContext
		return context
	}()
	
	static func newMed(dose: Int64, id:Int64, medication_id: Int64, name: String, quantity: Int64, run_out_date: String, rxcui: String, temporary: Bool) -> Medication {
		let med = NSEntityDescription.insertNewObject(forEntityName: "Medication", into: context) as! Medication
		
		med.dose = dose
		med.id = id
		med.medication_id = medication_id
		med.name = name
		med.quantity = quantity
		med.run_out_date = run_out_date
		med.rxcui = rxcui
		med.temporary = temporary
		
		return med
	}
	
	static func saveMeds() {
		do {
			try context.save()
		} catch let error {
			NSLog("Could not save \(error.localizedDescription)")
		}
	}
	
	static func deleteMed(medication: Medication) {
		context.delete(medication)
		saveMeds()
	}
	
	static func deleteAllMeds() {
		for med in retrieveMeds() {
			deleteMed(medication: med)
		}
		saveMeds()
	}
	
	static func retrieveMeds() -> [Medication] {
		do {
			let fetchRequest = NSFetchRequest<Medication>(entityName: "Medication")
			let results = try context.fetch(fetchRequest)
			return results
		} catch let error {
			NSLog("Could not fetch \(error.localizedDescription)")
			return []
		}
	}
}
