//
//  PDFHelper.swift
//  COVI19-deplacement
//
//  Created by Quentin PIDOUX on 12/04/2020.
//  Copyright © 2020 Quentin PIDOUX. All rights reserved.
//

import Foundation
import PDFKit
import CoreImage.CIFilterBuiltins

let context = CIContext()
let filter = CIFilter.qrCodeGenerator()

func LoadPDF(filename:String) -> PDFDocument? {
    let fileURL = Bundle.main.url(forResource: "Sample", withExtension: "pdf")
    let pdf_doc = PDFDocument(url: fileURL!)
    return pdf_doc
}

func InsertInPDF(firstname:String, lastName: String, birthday: String, lieunaissance: String, address: String, town: String, zipcode: String, reason:String) {
    
}

func addAnnotation(x:Int, y:Int, text: String, view: PDFView){
    let rect = CGRect(x: x, y: y, width: 250, height: 20)
    let annotation = PDFAnnotation(bounds: rect, forType: .freeText, withProperties: nil)
    annotation.contents = text
    annotation.font = UIFont.systemFont(ofSize: 13.0)
    annotation.fontColor = .black
    annotation.color = .clear
    guard let document = view.document else { return }
    let FirstPage = document.page(at: 0)
    FirstPage?.addAnnotation(annotation)

}

class PDFImageAnnotation: PDFAnnotation {
    var image: UIImage?
    
    convenience init(_ image: UIImage?, bounds: CGRect, properties: [AnyHashable : Any]?) {
        self.init(bounds: bounds, forType: PDFAnnotationSubtype.stamp, withProperties: properties)
        self.image = image
    }

    override func draw(with box: PDFDisplayBox, in context: CGContext) {
        super.draw(with: box, in: context)

        // Drawing the image within the annotation's bounds.
        guard let cgImage = image?.cgImage else { return }
        context.interpolationQuality = .none
        context.draw(cgImage, in: bounds)
    }
}

func addImageAnnotation(image: UIImage, view: PDFView){
    guard let document = view.document else { return }
    let FirstPage = document.page(at: 0)
    let rect = CGRect(x: (FirstPage?.bounds(for: PDFDisplayBox.mediaBox).size.width)! - 120, y: 175, width: 82, height: 82)
    let imageAnnotation = PDFImageAnnotation(image, bounds: rect, properties: nil)
    FirstPage?.addAnnotation(imageAnnotation)
}

func GeneratePDF(firstName: String,
				 lastName: String,
				 birthPlace: String,
				 BirthDate: String,
				 adress: String,
				 city: String,
				 zipcode: String,
				 reasons: [String],
				 currentDate: String,
				 hourAndMinute: String,
				 hour: String,
				 minute: String,
				 qrcodeText: String)
    -> Data? {
    let url =  Bundle.main.url(forResource: "certificate", withExtension: "pdf")
    let pdfView = PDFView()
    pdfView.document = PDFDocument(url: url!)
    pdfView.autoScales = true
    
    addAnnotation(x: 123, y: 680, text: lastName + " " + firstName, view: pdfView)
    addAnnotation(x: 123, y: 656, text: BirthDate, view: pdfView)
    addAnnotation(x: 92, y: 633, text: birthPlace, view: pdfView)
    addAnnotation(x: 134, y: 608, text: adress + " " + zipcode + " " + city, view: pdfView)
		
    addAnnotation(x: 111, y: 221, text: city, view: pdfView)
    
		for reason in reasons {
			switch reason.lowercased() {
				case "travail":
					addAnnotation(x: 76, y: 522, text: "X", view: pdfView)
				case "courses":
					addAnnotation(x: 76, y: 473, text: "X", view: pdfView)
				case "sante":
					addAnnotation(x: 76, y: 431, text: "X", view: pdfView)
				case "famille":
					addAnnotation(x: 76, y: 395, text: "X", view: pdfView)
				case "sport":
					addAnnotation(x: 76, y: 340, text: "X", view: pdfView)
				case "judiciaire":
					addAnnotation(x: 76, y: 293, text: "X", view: pdfView)
				case "missions":
					addAnnotation(x: 76, y: 255, text: "X", view: pdfView)
				default:
					print("")
			}
		}
    
    if !reasons.isEmpty {
        // Date sortie
        addAnnotation(x: 92, y: 195, text: currentDate, view: pdfView)
        addAnnotation(x: 196, y: 196, text: hour, view: pdfView)
        addAnnotation(x: 220, y: 196, text: minute, view: pdfView)
    }
    
    addAnnotation(x: 464, y: 160, text: "Date de création", view: pdfView)
    addAnnotation(x: 455, y: 144, text: currentDate + " à " + hourAndMinute, view: pdfView)
    let image = generateQRCode(from: qrcodeText)
    
    addImageAnnotation(image: image, view: pdfView)
    return SavePDF(view: pdfView)
}

func SavePDF(view: PDFView) -> Data? {
    let data = view.document?.dataRepresentation()
    return data
}


func generateQRCode(from string: String) -> UIImage {
    let data = Data(string.utf8)
    filter.setValue(data, forKey: "inputMessage")

    if let outputImage = filter.outputImage {
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            return UIImage(cgImage: cgimg)
        }
    }

    return UIImage(systemName: "xmark.circle") ?? UIImage()
}
