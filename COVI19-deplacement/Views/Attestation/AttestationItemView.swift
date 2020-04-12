//
//  AttestationItemView.swift
//  COVI19-deplacement
//
//  Created by Quentin PIDOUX on 12/04/2020.
//  Copyright © 2020 Quentin PIDOUX. All rights reserved.
//

import SwiftUI

struct AttestationItemView: View {
    var attestation: Attestation

    var body: some View {
        HStack {
            Image(uiImage: generateQRCode(from: attestation.qrCode!))
				.renderingMode(.original)
				.interpolation(.none)
				.resizable()
				.frame(width:75, height: 75)
				.aspectRatio(contentMode: .fit)
    
            VStack (alignment: .leading){
				HStack {
					Text(attestation.author?.firstname ?? "")
					Text(attestation.author?.lastname ?? "")
						.font(.headline)
					Spacer()
				}.foregroundColor(Color.init("darkText"))
				Spacer()
				Text("attestation.created.at \(attestation.createdAt?.dateTimeString() ?? "")")
					.font(.caption)
					.foregroundColor(Color.init("darkText"))
				Text("attestation.expired.at \(attestation.expiredAt?.dateTimeString() ?? "")")
					.font(.caption)
					.foregroundColor(Color.init("darkText"))
				Spacer()
            }
            
            Spacer()
        }
    }
}

