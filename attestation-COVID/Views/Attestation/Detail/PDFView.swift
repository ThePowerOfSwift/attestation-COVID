//
//  PDFView.swift
//  COVI19-deplacement
//
//  Created by Quentin PIDOUX on 12/04/2020.
//  Copyright © 2020 Quentin PIDOUX. All rights reserved.
//

import SwiftUI
import PDFKit

struct PDFKitView: View {
    var pdf_data: Data
    
    var body: some View {
		PDFKitRepresentedView(data: self.pdf_data)
    }
}

struct PDFView_Previews: PreviewProvider {
    static var previews: some View {
        PDFKitView(pdf_data: Data())
    }
}


struct PDFKitRepresentedView: UIViewRepresentable {
    let data: Data

    func makeUIView(context: UIViewRepresentableContext<PDFKitRepresentedView>) -> PDFKitRepresentedView.UIViewType {
        // Create a `PDFView` and set its `PDFDocument`.
        let pdfView = PDFView()
        pdfView.document = PDFDocument(data: data)
        pdfView.autoScales = true
        
        return pdfView
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PDFKitRepresentedView>) {
        // Update the view.
    }
}
