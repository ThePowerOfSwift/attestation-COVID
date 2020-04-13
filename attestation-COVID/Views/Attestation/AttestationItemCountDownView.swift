//
//  AttestationItemCountDownView.swift
//  attestation-COVID
//
//  Created by Quentin PIDOUX on 13/04/2020.
//  Copyright © 2020 Quentin PIDOUX. All rights reserved.
//

import SwiftUI
import SwifterSwift

struct AttestationItemCountDownView: View {
	var attestation: Attestation
	
	@State var currentDate = Date()
	let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
	
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
				Text(getTime(currentDate))
					.font(.caption)
					.foregroundColor(Color.init("darkText"))
					.onReceive(timer) { input in
						self.currentDate = input
					}
				
				Spacer()
            }
            
            Spacer()
        }
    }
	
	
	func getTime(_ now: Date) -> String {
		guard let createdAt = attestation.expiredAt else {
			return ""
		}
		let duration = secondsToMinutesSeconds(seconds: createdAt.secondsSince(now).int)
		
		return String(format: NSLocalizedString("attestation.remaining", comment: ""), duration.0, duration.1)

		if duration.0 > 0 {

			return "Expire dans \(duration.0) min et \(duration.1) secondes"
		}
		return "Expire dans \(duration.1) secondes"
	}
	
	private func secondsToMinutesSeconds (seconds : Int) -> (Int, Int) {
	  return ((seconds % 3600) / 60, (seconds % 3600) % 60)
	}
}
