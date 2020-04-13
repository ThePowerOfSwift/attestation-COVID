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
	@FetchRequest(entity: Author.entity(), sortDescriptors: []) var authors: FetchedResults<Author>
	@FetchRequest(entity: Attestation.entity(), sortDescriptors: [NSSortDescriptor(key: "createdAt", ascending: false)], predicate: NSPredicate(format: "expiredAt >= %@", argumentArray: [Date()])) var activeAttestations: FetchedResults<Attestation>
 	
    private var badgePosition: CGFloat = 2
    private var tabsCount: CGFloat = 4
	
	@ViewBuilder
    var body: some View {
		if authors.isEmpty {
			AddAuthorView()
		} else {
			GeometryReader { geometry in
            ZStack(alignment: .bottomLeading) {
				TabView(selection: self.$selection) {
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
					.tabItem {
						VStack {
							Image(systemName: "info.circle")
							Text(LocalizedStringKey("tabbar.information"))
						}
					}
					.tag(3)
				}
				ZStack {
					Circle()
						.foregroundColor(.red)
					Text("\(self.activeAttestations.count)")
						.foregroundColor(.white)
						.font(Font.system(size: 12))
				}
				.frame(width: 15, height: 15)
				.offset(x: ( ( 2 * self.badgePosition) - 0.95 ) * ( geometry.size.width / ( 2 * self.tabsCount ) ) + 2, y: -30)
				.opacity(self.activeAttestations.count == 0 ? 0 : 1.0)
				}
		}
	  }
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

