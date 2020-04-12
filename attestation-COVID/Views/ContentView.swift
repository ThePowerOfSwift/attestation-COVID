//
//  ContentView.swift
//  COVI19-deplacement
//
//  Created by Quentin PIDOUX on 12/04/2020.
//  Copyright © 2020 Quentin PIDOUX. All rights reserved.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State private var selection = 0
	@Environment(\.managedObjectContext) var managedContext
//	@FetchRequest(fetchRequest: Author.getAll()) var authors: FetchedResults<Author>
	@FetchRequest(entity: Author.entity(), sortDescriptors: []) var authors: FetchedResults<Author>
 	
	@ViewBuilder
    var body: some View {
		if authors.isEmpty {
			AddAuthorView()
		} else {
			TabView(selection: $selection) {
				AddAttestationView()
				.tabItem {
					VStack {
						Image(systemName: "square.and.pencil")
						Text(LocalizedStringKey("tabbar.create"))
					}
				}
				.tag(0)
				
				AttestationList()
			   .tabItem {
				   VStack {
					   Image(systemName: "tray.full")
					   Text(LocalizedStringKey("tabbar.attestations"))
				   }
			   }
			   .tag(1)
		
				AuthorsView()
				.tabItem {
					VStack {
						Image(systemName: "person")
						Text(LocalizedStringKey("tabbar.profiles"))
					}
				}
				.tag(2)
		
				InformationsView()
				.font(.title)
				.tabItem {
					VStack {
						Image(systemName: "info.circle")
						Text(LocalizedStringKey("tabbar.information"))
					}
				}
				.tag(3)
		   }
		}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


