import SwiftUI

enum FAppColor {
    static let accent = Color("AccentColor")
    static let foreground = Color("foreground")
    static let background = Color("background")

    static let border = Color("border")
    static let scrim = Color("#000000", 0.4)
    static let dimmedBackground = Color("#000000", 0.5)
    static let overlay = Color("#808080", 0.3)
    static let backdrop = Color("#FFFFFF", 0.25)
    static let modalBackground = Color("#121212", 0.6)
    
    static let buttonForeground = Color("buttonForeground")
    static let buttonBackground = Color("buttonBackground")
    static let disableForeground = Color("disableForeground")
    static let disableBackground = Color("disableBackground")
    
    static let absoluteBlack = Color("absoluteBlack")
    static let absoluteWhite = Color("absoluteWhite")
    static let transparent = Color("transparent")
    
    static let sunday = Color("sunday")
    static let monday = Color("monday")
    static let tuesday = Color("tuesday")
    static let wednesday = Color("wednesday")
    static let thursday = Color("thursday")
    static let friday = Color("friday")
    static let saturday = Color("saturday")
    
    static let ediStateOk = Color("ediStateOk")
    static let ediStateReject = Color("ediStateReject")
    static let ediStatePending = Color("ediStatePending")
    static let ediStatePartial = Color("ediStatePartial")
    static let ediBackStateOk = Color("ediBackStateOk")
    static let ediBackStateReject = Color("ediBackStateReject")
    static let ediBackStatePending = Color("ediBackStatePending")
    static let ediBackStatePartial = Color("ediBackStatePartial")
    
    static let qnaStateOk = Color("qnaStateOk")
    static let qnaStateRecep = Color("qnaStateRecep")
    static let qnaStateReply = Color("qnaStateReply")
    static let qnaBackStateOk = Color("qnaBackStateOk")
    static let qnaBackStateRecep = Color("qnaBackStateRecep")
    static let qnaBackStateReply = Color("qnaBackStateReply")
}

extension Color {
    init(_ hex: String, _ opacity: Double) {
        let hex = hex.replacingOccurrences(of: "#", with: "")
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let r: Double
        let g: Double
        let b: Double
        if hex.count == 6 {
            r = Double((int >> 16) & 0xFF) / 255
            g = Double((int >> 8) & 0xFF) / 255
            b = Double(int & 0xFF) / 255
        } else {
            r = 0
            g = 0
            b = 0
        }
        self.init(.sRGB, red: r, green: g, blue: b, opacity: opacity)
    }
}
