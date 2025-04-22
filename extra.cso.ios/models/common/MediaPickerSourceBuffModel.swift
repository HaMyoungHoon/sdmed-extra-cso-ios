import Foundation
import Photos
import SwiftUI

class MediaPickerSourceBuffModel: FDataModelClass<MediaPickerSourceBuffModel.ClickEvent> {
    var thisPK: String = UUID().uuidString
    var asset: PHAsset = PHAsset()
    var thumbnail: UIImage = UIImage()
    
    @Published var clickState = false
    @Published var num: Int? = nil
    @Published var lastClick = false
    
    enum ClickEvent: Int, CaseIterable {
        case SELECT = 0
    }
}
