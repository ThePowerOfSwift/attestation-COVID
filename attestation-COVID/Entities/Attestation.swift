//
//  Attestation.swift
//  COVI19-deplacement
//
//  Created by Quentin PIDOUX on 12/04/2020.
//  Copyright © 2020 Quentin PIDOUX. All rights reserved.
//

import Foundation
import CoreData

class AttestationData {
	let expiredAt: Date = Date().adding(.hour, value: 1)
	let id = UUID()
	let pdf: Data
	let qrCode: String
	let author: Author
	
	internal init(pdf: Data, qrCode: String, author: Author) {
		self.pdf = pdf
		self.qrCode = qrCode
		self.author = author
	}
	
	func save(_ context: NSManagedObjectContext) -> Error? {
	
		let attestation = NSEntityDescription.insertNewObject(forEntityName: "Attestation",
		into: context) as! Attestation
		
		attestation.createdAt = Date()
		attestation.pdf = self.pdf
		attestation.qrCode = self.qrCode
		attestation.author = self.author
		attestation.id = self.id
		attestation.expiredAt = self.expiredAt
		
		do {
			try context.save()
		} catch let error {
			return error
		}
		
		return nil
	}
}
