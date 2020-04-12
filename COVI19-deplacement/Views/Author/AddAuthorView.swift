//
//  AddAuthorView.swift
//  COVI19-deplacement
//
//  Created by Quentin PIDOUX on 12/04/2020.
//  Copyright © 2020 Quentin PIDOUX. All rights reserved.
//

import SwiftUI
import Combine

struct AddAuthorView: View {
	@Environment(\.managedObjectContext) var managedContext
	@Environment(\.presentationMode) var presentationMode
	@EnvironmentObject var authorData: AuthorData
	
    var body: some View {
		NavigationView{
			Form {
				Section(header: Text("author.add.section.name")){
					TextField("author.add.lastname", text:  self.$authorData.lastName)
						.textContentType(.familyName)
					TextField("author.add.firstname", text: self.$authorData.firstName)
						.textContentType(.name)
				}
				
				Section(header: Text("author.add.section.birth")){
					DatePicker(selection: self.$authorData.birthdate, in: ...Date(), displayedComponents: .date) {
						Text("author.add.birthdate")
					}.environment(\.locale, Locale.current)
					TextField("author.add.birthplace", text: self.$authorData.birthPlace)
					
				}
					
				Section(header: Text("author.add.section.address")){
					TextField("author.add.streetname", text: self.$authorData.address.streetName)
						.textContentType(.streetAddressLine1)
					TextField("author.add.city", text: self.$authorData.address.city)
						.textContentType(.addressCity)
					TextField("author.add.zipcode", text: self.$authorData.address.zipcode)
						.keyboardType(.numberPad)
				}
			}.keyboardResponsive()
			.environment(\.horizontalSizeClass, .regular)
			.navigationBarTitle(Text("author.add.new.author"))
			.navigationBarItems(trailing:
                Button(action: {
					self.authorData.save(self.managedContext)
					UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
					self.presentationMode.wrappedValue.dismiss()
					}) {
					HStack {
						Text("author.add.new.save")
							.fontWeight(.semibold)
							.font(.body)
					}
				}.disabled(disableButton)
            )
			}
		}
	
	var disableButton: Bool {
		authorData.lastName.isEmpty ||
		authorData.firstName.isEmpty ||
		authorData.birthPlace.isEmpty ||
		authorData.address.streetName.isEmpty ||
		authorData.address.city.isEmpty ||
		authorData.address.zipcode.isEmpty
	}
}


struct AddAuthorView_Previews: PreviewProvider {
    static var previews: some View {
        AddAuthorView()
    }
}
