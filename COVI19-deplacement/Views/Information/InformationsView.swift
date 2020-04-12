//
//  InformationsView.swift
//  COVI19-deplacement
//
//  Created by Quentin PIDOUX on 12/04/2020.
//  Copyright © 2020 Quentin PIDOUX. All rights reserved.
//

import SwiftUI

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
				}
				
				Section(header: Text("information.section.3.title"), footer: Text("information.section.3.footer")) {
					Text("information.section.3.content")
						.font(.body)
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
