//
//  Author.swift
//  COVI19-deplacement
//
//  Created by Quentin PIDOUX on 12/04/2020.
//  Copyright © 2020 Quentin PIDOUX. All rights reserved.
//

import Foundation
import CoreData
import SwifterSwift
import Combine
import PLogger

extension Author {
    static func getAll() -> NSFetchRequest<Author> {
		let request = NSFetchRequest<Author>(entityName: "Author")
        request.sortDescriptors = [
			NSSortDescriptor(key: "createdAt", ascending: true)
		]
        return request
    }
}

class AuthorData: ObservableObject {
	@Published var firstName: String = ""
	@Published var lastName: String = ""
	@Published var birthdate: Date = Date()?.adding(.year, value: -20) ?? Date()
	@Published var birthPlace: String = ""
	@Published var address: AddressData = AddressData()
	
	func save(_ context: NSManagedObjectContext) {
		let author = NSEntityDescription.insertNewObject(forEntityName: "Author",
														 into: context) as! Author
		
		author.createdAt = Date()
		author.id = UUID()
		
		author.firstname = firstName
		author.lastname = lastName
		author.birthPlace = birthPlace
		author.birthDate = birthdate
		
		
		let address = NSEntityDescription.insertNewObject(forEntityName: "Address",
		into: context) as! Address
		
		address.createdAt = Date()
		address.city = self.address.city
		address.streetname = self.address.streetName
		address.zipcode = self.address.zipcode
		address.author = author
		
		author.address = address
		
		do {
			try context.save()
			PLogger.debug("author saved")
		} catch let error {
			PLogger.error(error)
		}
	}
}
