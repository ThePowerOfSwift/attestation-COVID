//
//  Address.swift
//  COVI19-deplacement
//
//  Created by Quentin PIDOUX on 12/04/2020.
//  Copyright © 2020 Quentin PIDOUX. All rights reserved.
//

import Foundation
import CoreData
import SwifterSwift
import Combine

extension Address {
    static func getAll() -> NSFetchRequest<Address> {
		let request = NSFetchRequest<Address>(entityName: "Address")
		let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
		
        request.sortDescriptors = [sortDescriptor]
        return request
    }
}


class AddressData: ObservableObject {
	@Published var city: String = ""
	@Published var streetName: String = ""
	@Published var zipcode: String = ""
}
