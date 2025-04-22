struct EDIUploadEvent: PEventList {
    var thisPK: String = ""
    
    init(_ thisPK: String) {
        self.thisPK = thisPK
    }
}
