struct MultiLoginEvent: PEventList {
    var thisPK: String = ""
    
    init(_ thisPK: String = "") {
        self.thisPK = thisPK
    }
}
