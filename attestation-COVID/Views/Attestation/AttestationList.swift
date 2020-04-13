//
//  AttestationList.swift
//  COVI19-deplacement
//
//  Created by Quentin PIDOUX on 12/04/2020.
//  Copyright © 2020 Quentin PIDOUX. All rights reserved.
//

import SwiftUI
import CoreData

struct AttestationList: View {
	@Environment(\.managedObjectContext) var managedContext
	@FetchRequest(entity: Attestation.entity(), sortDescriptors: [NSSortDescriptor(key: "createdAt", ascending: false)], predicate: NSPredicate(format: "expiredAt >= %@", argumentArray: [Date()])) var activeAttestations: FetchedResults<Attestation>
	@FetchRequest(entity: Attestation.entity(), sortDescriptors: [NSSortDescriptor(key: "createdAt", ascending: false)], predicate: NSPredicate(format: "expiredAt < %@", argumentArray: [Date()])) var oldAttestations: FetchedResults<Attestation>
	
	@State private var showModal = false
	
//	@ViewBuilder
    var body: some View {

		NavigationView{
			List {
				if !self.activeAttestations.isEmpty {
					Section(header: Text("attestations.section.active")) {
						ForEach(self.activeAttestations, id: \.self) { attestation in
							Button(action: {
								self.showModal.toggle()
							}) {
								AttestationItemCountDownView(attestation: attestation)
							}.sheet(isPresented: self.$showModal){
								AttestationDetailView(attestation: attestation)
							}
						}.onDelete(perform: { (IndexSet) in
							let deleteItem = self.activeAttestations[IndexSet.first!]
							self.managedContext.delete(deleteItem)
							do {
								try self.managedContext.save()
							}catch {
								print(error)
							}
						})
					}
				}
				
				if !self.oldAttestations.isEmpty {
					Section(header: Text("attestations.section.inactive")) {
						ForEach(self.oldAttestations, id: \.self) { attestation in
							
							Button(action: {
								self.showModal.toggle()
							}) {
								AttestationItemView(attestation: attestation)
							}.sheet(isPresented: self.$showModal){
								AttestationDetailView(attestation: attestation)
							}
						}.onDelete(perform: { (IndexSet) in
							let deleteItem = self.oldAttestations[IndexSet.first!]
							self.managedContext.delete(deleteItem)
							do {
								try self.managedContext.save()
							}catch {
								print(error)
							}
						})
					}
				}
				
				if self.activeAttestations.isEmpty && self.oldAttestations.isEmpty {
					HStack {
						Spacer()
						Text("attestations.empty")
						Spacer()
					}
				}
				
			}
			.listStyle(GroupedListStyle())
				.environment(\.horizontalSizeClass, .regular)
			.navigationBarTitle(Text("attestations.title"))
		}
    }
}

struct AttestationList_Previews: PreviewProvider {
    static var previews: some View {
        AttestationList()
    }
}
