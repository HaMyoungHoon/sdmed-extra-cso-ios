import Photos

enum MediaFileType: Decodable {
    case UNKNOWN
    case IMAGE
    case VIDEO
    case PDF
    case EXCEL
    case ZIP
    
    static func parse(_ data: PHAssetMediaType) -> MediaFileType {
        switch data {
        case PHAssetMediaType.image: return MediaFileType.IMAGE
        case PHAssetMediaType.video: return MediaFileType.VIDEO
        case PHAssetMediaType.unknown: return MediaFileType.UNKNOWN
        default: return MediaFileType.UNKNOWN
        }
    }
    static func fromMimeType(_ mimeType: String) -> MediaFileType {
        switch mimeType {
        case FContentsType.type_pdf:    return MediaFileType.PDF
        case FContentsType.type_xls:    return MediaFileType.EXCEL
        case FContentsType.type_xlsx:   return MediaFileType.EXCEL
        default:                        return MediaFileType.UNKNOWN
        }
    }
}
