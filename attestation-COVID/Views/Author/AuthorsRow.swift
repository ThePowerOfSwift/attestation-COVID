//
//  AuthorsRow.swift
//  COVI19-deplacement
//
//  Created by Quentin PIDOUX on 12/04/2020.
//  Copyright © 2020 Quentin PIDOUX. All rights reserved.
//

import SwiftUI
import SwifterSwift

struct AuthorsRow: View {
	var author: Author
	
    var body: some View {
		VStack {
			HStack {
				Text(author.firstname ?? "")
				Text(author.lastname ?? "")
					.font(.headline)
				Spacer()
				Text( "author.list.added.at \(author.createdAt?.string(withFormat: "dd/MM/yyyy") ?? "")")
					.font(.caption)
			}
			HStack {
				Text("author.list.born.at \(author.birthDate?.string(withFormat: "dd/MM/yyyy") ?? "")")
					.font(.caption)
				Spacer()
			}
			
			
		}
		
    }
}
