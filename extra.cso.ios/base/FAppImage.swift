import Foundation
import SwiftUI

class FAppImage {
    static let landingBackgroundNamed: String = "landing_background"
    static let hospitalRedNamed: String = "hospital_red"
    static let pharmacyGreenNamed: String = "pharmacy_green"
    
    static let close = Image(systemName: "xmark")
    static let doubleLeft = Image(systemName: "chevron.left.2")
    static let doubleRight = Image(systemName: "chevron.right.2")
    
    static let landingBackground = Image(landingBackgroundNamed)
    static let hospitalRed = Image(hospitalRedNamed)
    static let pharmacyGreen = Image(pharmacyGreenNamed)
}
