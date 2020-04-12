//
//  AttestationDetailView.swift
//  COVI19-deplacement
//
//  Created by Quentin PIDOUX on 12/04/2020.
//  Copyright © 2020 Quentin PIDOUX. All rights reserved.
//

import SwiftUI
import PDFKit

struct AttestationDetailView: View {
	var attestation: Attestation
	@State private var showModal = false
	@State private var showDetailModal = false
	@State private var isSharePresented: Bool = false
	
    var body: some View {
		NavigationView{
			   List {
				   VStack {
					Image(uiImage: generateQRCode(from: attestation.qrCode!))
						.interpolation(.none)
						.resizable()
						.edgesIgnoringSafeArea(.top)
						.frame(width:200, height: 200)
						.aspectRatio(contentMode: .fit)
						.clipped()
						.padding(20)
					  
				  Text(attestation.qrCode!).padding(10)
				  Spacer()
				}
			}
			.listStyle(GroupedListStyle())
			.navigationBarTitle(Text("attestation.add.title"))
				.navigationBarItems(trailing: Button(action: {
						self.showDetailModal.toggle()
					}) {
						HStack {
							Text("attestation.show.pdf")
								.fontWeight(.semibold)
								.font(.body)
							Image(systemName: "doc")
								.font(.body)
						}
					}.sheet(isPresented: self.$showDetailModal){
						PDFKitView(pdf_data: self.attestation.pdf!)
					})
		}
    }
}
