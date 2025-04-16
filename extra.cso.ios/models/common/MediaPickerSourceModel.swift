import Foundation

class MediaPickerSourceModel: FDataModelClass<MediaPickerSourceModel.ClickEvent> {
    var thisPK: String = UUID().uuidString
    var mediaUrl: String? = nil
    var mediaName: String = ""
    var mediaFileType: MediaFileType = MediaFileType.UNKNOWN
    var mediaDateTime: String = ""
    var mediaMimeType: String = ""
    
    @Published var duration = -1
    @Published var clickState = false
    @Published var num: Int? = nil
    @Published var lastClick = false
    
    enum ClickEvent: Int, CaseIterable {
        case SELECT = 0
        case SELECT_LONG = 1
    }
}
