//
//  AddAttestationView.swift
//  COVI19-deplacement
//
//  Created by Quentin PIDOUX on 12/04/2020.
//  Copyright © 2020 Quentin PIDOUX. All rights reserved.
//

import SwiftUI
import CoreImage.CIFilterBuiltins
import SwifterSwift

struct AddAttestationView: View {
	@Environment(\.managedObjectContext) var managedContext
    @FetchRequest(entity: Author.entity(), sortDescriptors: []) var authors: FetchedResults<Author>
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    @State private var showingAlert = false

	var raisons: [Reason] = [
		Reason(key: "travail"	, label: "attestation.reason.work"),
		Reason(key: "courses"	, label: "attestation.reason.food"),
		Reason(key: "sante"		, label: "attestation.reason.health"),
		Reason(key: "famille"	, label: "attestation.reason.familly"),
		Reason(key: "sport"		, label: "attestation.reason.sport"),
		Reason(key: "judiciaire", label: "attestation.reason.justice"),
		Reason(key: "missions"	, label: "attestation.reason.mission")
	]
	
    @State var alertTextTop: String = ""
    @State var alertMessage: String = ""

	@State private var selections = [String]()
	@State private var selectedAuthor = 0
	
    var body: some View {
        NavigationView {
			Form {
				Section(header: Text("attestation.add.section.who")){
					Picker(selection: $selectedAuthor, label: Text("attestation.add.who")) {
						ForEach(0 ..< authors.count) {
							Text("\(self.authors[$0].firstname ?? "") \(self.authors[$0].lastname ?? "")" )
						}
					}
				}
				
				Section(header: Text("attestation.add.section.reason")){
					ForEach(raisons, id: \.self) { item in
						MultipleSelectionRow(title: item.label, isSelected: self.selections.contains(item.key)) {
							if self.selections.contains(item.key) {
								self.selections.removeAll(where: { $0 == item.key })
                            }
                            else {
								self.selections.append(item.key)
                            }
                        }
                    }
				}
			}.keyboardResponsive()
				.listStyle(GroupedListStyle())
				.environment(\.horizontalSizeClass, .regular)
            
            .navigationBarTitle(Text("attestation.add.title"))
            .navigationBarItems(trailing:
				HStack {
					Button("attestation.add.button") {
						self.save()
					}.alert(isPresented: $showingAlert) {
						Alert(title: Text(LocalizedStringKey(alertTextTop)), message: Text(LocalizedStringKey(alertMessage)), dismissButton: .default(Text("attestation.add.alert.dismiss")))
					}.disabled(disableButton)
					Image(systemName: "plus")
				}
               
                
            )
        }
    }
	
	var disableButton: Bool {
		return selections.isEmpty
	}
	
	func save() {
		let author = self.authors[selectedAuthor]
	
		let now = Date()
		
		guard let qrCode = self.generateString(now: now) else { return }
		guard let pdf = self.generatePDF(now: now) else { return }

		let attestation = AttestationData(pdf: pdf, qrCode: qrCode, author: author)
		
		if let _  = attestation.save(managedContext) {
			self.showingAlert = true
			self.alertTextTop = "attestation.add.alert.error.title"
			self.alertMessage = "attestation.add.alert.error.body"
		} else {
			self.showingAlert = true
			self.alertTextTop = "attestation.add.alert.success.title"
			self.alertMessage = "attestation.add.alert.success.body"
			self.selections = []
		}
	}
		
	func generateString(now: Date) -> String? {
		let author = self.authors[selectedAuthor]
		let reasons = self.selections
		
		let creationDate = now.string(withFormat: "dd/MM/yyyy")
		let creationTime: String = {
			let hour = now.string(withFormat: "HH:mm")
			return hour.replacingOccurrences(of: ":", with: "h")
		}()
	
		
		let when = "Cree le: \(creationDate) a \(creationTime);"
		let person = "Nom: \(author.lastname ?? ""); Prenom: \(author.firstname ?? ""); Naissance: \(author.birthDate?.string(withFormat: "dd/MM/yyyy") ?? "") a \(author.birthPlace ?? "");"
		let address = "Adresse: \(author.address?.streetname ?? "") \(author.address?.zipcode ?? "") \(author.address?.city ?? "");"
		let time = "Sortie: \(creationDate) a \(creationTime);"
		let reason: String = {
			return "Motifs: \(reasons.joined(separator: "-"))"
		}()
		
		return "\(when) \(person) \(address) \(time) \(reason)"
    }
	
	func generatePDF(now: Date) -> Data? {
		let author = self.authors[selectedAuthor]
		
		let birthDate = author.birthDate?.string(withFormat: "dd/MM/yyyy") ?? ""
		
		let creationDate = now.string(withFormat: "dd/MM/yyyy")
		let creationTime: String = {
			let hour = now.string(withFormat: "HH:mm")
			return hour.replacingOccurrences(of: ":", with: "h")
		}()
		
		return GeneratePDF(firstName: author.firstname ?? "",
						   lastName: author.lastname ?? "",
						   birthPlace: author.birthPlace ?? "",
						   BirthDate: birthDate,
						   adress: author.address?.streetname ?? "",
						   city: author.address?.city ?? "",
						   zipcode: author.address?.zipcode ?? "",
						   reasons: selections,
						   currentDate: creationDate,
						   hourAndMinute: creationTime, hour: now.string(withFormat: "HH"),
						   minute: now.string(withFormat: "mm"),
						   qrcodeText: generateString(now: now) ?? "")
	}
}

struct AddAttestationView_Previews: PreviewProvider {
    static var previews: some View {
        AddAttestationView()
    }
}


struct MultipleSelectionRow: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: self.action) {
            HStack {
				
				Text(verbatim: title.localized())
					.font(.body)
					.foregroundColor(Color.init("darkText"))
                if self.isSelected {
                    Spacer()
                    Image(systemName: "checkmark").foregroundColor(.blue)
                }
            }
        }.foregroundColor(Color.black)
    }
}

//extension String {
//    var localized: String {
//        return NSLocalizedString(self, comment: "")
//    }
//}
