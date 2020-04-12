//
//  InformationsView.swift
//  COVI19-deplacement
//
//  Created by Quentin PIDOUX on 12/04/2020.
//  Copyright © 2020 Quentin PIDOUX. All rights reserved.
//

import SwiftUI
import SwifterSwift

struct InformationsView: View {
	
    var body: some View {
        NavigationView{
			List {
				Section(header: Text("information.section.1.title")) {
					Text("information.section.1.content")
						.font(.body)
				}
				
				Section(header: Text("information.section.2.title")) {
					Text("information.section.2.content")
						.font(.body)
					Text("information.section.2.content.2")
						.font(.body)
						.onTapGesture {
							if let url = URL(string: "https://media.interieur.gouv.fr/deplacement-covid-19/") {
								UIApplication.shared.open(url)
							}
					}
				}
				
				Section(header: Text("information.section.3.title"), footer: Text("information.section.3.footer \(UIApplication.shared.displayName ?? "") \(UIApplication.shared.version ?? "")")) {
					Text("information.section.3.content")
						.font(.body)
						.onTapGesture {
							if let url = URL(string: "https://github.com/phoenisis/attestation-COVID") {
								UIApplication.shared.open(url)
							}
					}
				}
			}
			.listStyle(GroupedListStyle())
				.environment(\.horizontalSizeClass, .regular)
            
            .navigationBarTitle(Text("information.title"))
        }
    }
}

struct InformationsView_Previews: PreviewProvider {
    static var previews: some View {
        InformationsView()
    }
}
