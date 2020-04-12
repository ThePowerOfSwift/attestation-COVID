//
//  AuthorsView.swift
//  COVI19-deplacement
//
//  Created by Quentin PIDOUX on 12/04/2020.
//  Copyright © 2020 Quentin PIDOUX. All rights reserved.
//

import SwiftUI
import CoreData
import SwifterSwift

struct AuthorsView: View {
	var newAuthorData = AuthorData()
	
	@Environment(\.managedObjectContext) private var managedContext
	@FetchRequest(entity: Author.entity(), sortDescriptors: []) var authors: FetchedResults<Author>

	@State private var showModal = false
	
	@ViewBuilder
    var body: some View {
        NavigationView {
			List {
				ForEach(self.authors, id: \.self) { author in
					AuthorsRow(author: author)
                }.onDelete(perform: { (IndexSet) in
					let deleteItem = self.authors[IndexSet.first!]
					self.managedContext.delete(deleteItem)
					do {
						try self.managedContext.save()
					}catch {
						print(error)
					}
				})
			}
			.listStyle(GroupedListStyle())
				.environment(\.horizontalSizeClass, .regular)
			.navigationBarTitle(Text("author.list.title"))
			.navigationBarItems(trailing:
				Button(action: {
					self.showModal = true
				}) {
					HStack {
						Text("author.list.add.new")
						Image(systemName: "plus")
					}					
				}
				.sheet(isPresented: self.$showModal) {
					AddAuthorView()
						.environment(\.managedObjectContext, self.managedContext)
						.environmentObject(self.newAuthorData)
				}
			)
		}
	}
}

struct AuthorsView_Previews: PreviewProvider {
    static var previews: some View {
        AuthorsView()
    }
}
