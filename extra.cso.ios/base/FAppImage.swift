import Foundation
import SwiftUI

class FAppImage {
    static let landingBackgroundNamed: String = "landing_background"
    static let hospitalRedNamed: String = "hospital_red"
    static let pharmacyGreenNamed: String = "pharmacy_green"
    static let imageNoImageNamed: String = "image_no_image"
    static let imageExcelNamed: String = "image_excel"
    static let imagePdfNamed: String = "image_pdf"
    static let imageWordNamed: String = "image_word"
    static let imageZipNamed: String = "image_zip"
    
    static let close = Image(systemName: "xmark")
    static let doubleLeft = Image(systemName: "chevron.left.2")
    static let doubleRight = Image(systemName: "chevron.right.2")
    static let checkCircle = Image(systemName: "checkmark.circle")
    static let checkCircleFill = Image(systemName: "checkmark.circle.fill")
    
    static let landingBackground = Image(landingBackgroundNamed)
    static let hospitalRed = Image(hospitalRedNamed)
    static let pharmacyGreen = Image(pharmacyGreenNamed)
    static let imageNoImage = Image(imageNoImageNamed)
    static let imageExcel = Image(imageExcelNamed)
    static let imagePdf = Image(imagePdfNamed)
    static let imageWord = Image(imageWordNamed)
    static let imageZip = Image(imageZipNamed)
}
