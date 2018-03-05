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
	
	static func newMed(id: Int64, name:String, dose: Int64, expir_date: String) -> Medication {
		let med = NSEntityDescription.insertNewObject(forEntityName: "Medication", into: context) as! Medication
		
		med.id = id
		med.name = name
		med.dose = dose
		med.expir_date = expir_date
		
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
