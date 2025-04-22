class FContentsType {
    static let type_aac   : String = "audio/aac"
    static let type_abw   : String = "application/x-abiword"
    static let type_arc   : String = "application/octet-stream"
    static let type_avi   : String = "video/x-msvideo"
    static let type_azw   : String = "application/vnd.amazon.ebook"
    static let type_bin   : String = "application/octet-stream"
    static let type_bz    : String = "application/x-bzip"
    static let type_bz2   : String = "application/x-bzip2"
    static let type_csh   : String = "application/x-csh"
    static let type_css   : String = "text/css"
    static let type_csv   : String = "text/csv"
    static let type_doc   : String = "application/msword"
    static let type_epub  : String = "application/epub+zip"
    static let type_gif   : String = "image/gif"
    static let type_htm   : String = "text/html"
    static let type_html  : String = "text/html"
    static let type_heic  : String = "image/heic"
    static let type_heif  : String = "image/heif"
    static let type_ico   : String = "image/x-icon"
    static let type_ics   : String = "text/calendar"
    static let type_jar   : String = "application/java-archive"
    static let type_jpeg  : String = "image/jpeg"
    static let type_jpg   : String = "image/jpeg"
    static let type_js    : String = "application/js"
    static let type_json  : String = "application/json"
    static let type_mid   : String = "audio/midi"
    static let type_midi  : String = "audio/midi"
    static let type_mpeg  : String = "video/mpeg"
    static let type_mpkg  : String = "application/vnd.apple.installer+xml"
    static let type_odp   : String = "application/vnd.oasis.opendocument.presentation"
    static let type_ods   : String = "application/vnd.oasis.opendocument.spreadsheet"
    static let type_odt   : String = "application/vnd.oasis.opendocument.text"
    static let type_oga   : String = "audio/ogg"
    static let type_ogv   : String = "video/ogg"
    static let type_ogx   : String = "application/ogg"
    static let type_png   : String = "image/png"
    static let type_pdf   : String = "application/pdf"
    static let type_ppt   : String = "application/vnd.ms-powerpoint"
    static let type_rar   : String = "application/x-rar-compressed"
    static let type_rtf   : String = "application/rtf"
    static let type_sh    : String = "application/x-sh"
    static let type_svg   : String = "image/svg+xml"
    static let type_swf   : String = "application/x-shockwave-flash"
    static let type_tar   : String = "application/x-tar"
    static let type_tif   : String = "image/tiff"
    static let type_tiff  : String = "image/tiff"
    static let type_ttf   : String = "application/x-font-ttf"
    static let type_txt   : String = "plain/text"
    static let type_vsd   : String = "application/vnd.visio"
    static let type_wav   : String = "audio/x-wav"
    static let type_weba  : String = "audio/webm"
    static let type_webm  : String = "video/webm"
    static let type_webp  : String = "image/webp"
    static let type_woff  : String = "application/x-font-woff"
    static let type_xhtml : String = "application/xhtml+xml"
    static let type_xls   : String = "application/vnd.ms-excel"
    static let type_xlsx  : String = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    static let type_xlsm  : String = "application/vnd.ms-excel.sheet.macroEnabled.12"
    static let type_xml   : String = "application/xml"
    static let type_xul   : String = "application/vnd.mozilla.xul+xml"
    static let type_zip   : String = "application/zip"
    static let type_3gp   : String = "video/3gpp"
    static let type_3g2   : String = "video/3gpp2"
    static let type_7z    : String = "application/x-7z-compressed"

    static func findContentType(_ fileName: String) -> String {
        switch fileName.split(separator: ".").last?.lowercased() {
        case "aac":     return type_aac
        case "abw":     return type_abw
        case "arc":     return type_arc
        case "avi":     return type_avi
        case "azw":     return type_azw
        case "bin":     return type_bin
        case "bz":      return type_bz
        case "bz2":     return type_bz2
        case "csh":     return type_csh
        case "css":     return type_css
        case "csv":     return type_csv
        case "doc":     return type_doc
        case "epub":    return type_epub
        case "gif":     return type_gif
        case "heic":    return type_heic
        case "heif":    return type_heif
        case "htm":     return type_htm
        case "html":    return type_html
        case "ico":     return type_ico
        case "ics":     return type_ics
        case "jar":     return type_jar
        case "jpeg":    return type_jpeg
        case "jpg":     return type_jpg
        case "js":      return type_js
        case "json":    return type_json
        case "mid":     return type_mid
        case "midi":    return type_midi
        case "mpeg":    return type_mpeg
        case "mpkg":    return type_mpkg
        case "odp":     return type_odp
        case "ods":     return type_ods
        case "odt":     return type_odt
        case "oga":     return type_oga
        case "ogv":     return type_ogv
        case "ogx":     return type_ogx
        case "png":     return type_png
        case "pdf":     return type_pdf
        case "ppt":     return type_ppt
        case "rar":     return type_rar
        case "rtf":     return type_rtf
        case "sh":      return type_sh
        case "svg":     return type_svg
        case "swf":     return type_swf
        case "tar":     return type_tar
        case "tif":     return type_tif
        case "tiff":    return type_tiff
        case "ttf":     return type_ttf
        case "txt":     return type_txt
        case "vsd":     return type_vsd
        case "wav":     return type_wav
        case "weba":    return type_weba
        case "webm":    return type_webm
        case "webp":    return type_webp
        case "woff":    return type_woff
        case "xhtml":   return type_xhtml
        case "xls":     return type_xls
        case "xlsx":    return type_xlsx
        case "xlsm":    return type_xlsm
        case "xml":     return type_xml
        case "xul":     return type_xul
        case "zip":     return type_zip
        case "3gp":     return type_3gp
        case "3g2":     return type_3g2
        case "7z":      return type_7z
        default:        return "application/octet-stream"
        }
    }
    static func getExtMimeTypeString(_ ext: String) -> String {
        switch ext.lowercased() {
        case "aac":     return type_aac
        case "abw":     return type_abw
        case "arc":     return type_arc
        case "avi":     return type_avi
        case "azw":     return type_azw
        case "bin":     return type_bin
        case "bz":      return type_bz
        case "bz2":     return type_bz2
        case "csh":     return type_csh
        case "css":     return type_css
        case "csv":     return type_csv
        case "doc":     return type_doc
        case "epub":    return type_epub
        case "gif":     return type_gif
        case "heic":    return type_heic
        case "heif":    return type_heif
        case "htm":     return type_htm
        case "html":    return type_html
        case "ico":     return type_ico
        case "ics":     return type_ics
        case "jar":     return type_jar
        case "jpeg":    return type_jpeg
        case "jpg":     return type_jpg
        case "js":      return type_js
        case "json":    return type_json
        case "mid":     return type_mid
        case "midi":    return type_midi
        case "mpeg":    return type_mpeg
        case "mpkg":    return type_mpkg
        case "odp":     return type_odp
        case "ods":     return type_ods
        case "odt":     return type_odt
        case "oga":     return type_oga
        case "ogv":     return type_ogv
        case "ogx":     return type_ogx
        case "png":     return type_png
        case "pdf":     return type_pdf
        case "ppt":     return type_ppt
        case "rar":     return type_rar
        case "rtf":     return type_rtf
        case "sh":      return type_sh
        case "svg":     return type_svg
        case "swf":     return type_swf
        case "tar":     return type_tar
        case "tif":     return type_tif
        case "tiff":    return type_tiff
        case "ttf":     return type_ttf
        case "txt":     return type_txt
        case "vsd":     return type_vsd
        case "wav":     return type_wav
        case "weba":    return type_weba
        case "webm":    return type_webm
        case "webp":    return type_webp
        case "woff":    return type_woff
        case "xhtml":   return type_xhtml
        case "xls":     return type_xls
        case "xlsx":    return type_xlsx
        case "xlsm":    return type_xlsm
        case "xml":     return type_xml
        case "xul":     return type_xul
        case "zip":     return type_zip
        case "3gp":     return type_3gp
        case "3g2":     return type_3g2
        case "7z":      return type_7z
        default:        return "application/octet-stream"
        }
    }
    static func getExtMimeType(_ mimeType: String?) -> String {
        switch mimeType {
        case FContentsType.type_aac:      return "aac"
        case FContentsType.type_abw:      return "abw"
        case FContentsType.type_arc:      return "arc"
        case FContentsType.type_avi:      return "avi"
        case FContentsType.type_azw:      return "azw"
        case FContentsType.type_bin:      return "bin"
        case FContentsType.type_bz:       return "bz"
        case FContentsType.type_bz2:      return "bz2"
        case FContentsType.type_csh:      return "csh"
        case FContentsType.type_css:      return "css"
        case FContentsType.type_csv:      return "csv"
        case FContentsType.type_doc:      return "doc"
        case FContentsType.type_epub:     return "epub"
        case FContentsType.type_gif:      return "gif"
        case FContentsType.type_heic:     return "heic"
        case FContentsType.type_heif:     return "heif"
        case FContentsType.type_htm:      return "htm"
        case FContentsType.type_html:     return "html"
        case FContentsType.type_ico:      return "ico"
        case FContentsType.type_ics:      return "ics"
        case FContentsType.type_jar:      return "jar"
        case FContentsType.type_jpeg:     return "jpeg"
        case FContentsType.type_jpg:      return "jpg"
        case FContentsType.type_js:       return "js"
        case FContentsType.type_json:     return "json"
        case FContentsType.type_mid:      return "mid"
        case FContentsType.type_midi:     return "midi"
        case FContentsType.type_mpeg:     return "mpeg"
        case FContentsType.type_mpkg:     return "mpkg"
        case FContentsType.type_odp:      return "odp"
        case FContentsType.type_ods:      return "ods"
        case FContentsType.type_odt:      return "odt"
        case FContentsType.type_oga:      return "oga"
        case FContentsType.type_ogv:      return "ogv"
        case FContentsType.type_ogx:      return "ogx"
        case FContentsType.type_png:      return "png"
        case FContentsType.type_pdf:      return "pdf"
        case FContentsType.type_ppt:      return "ppt"
        case FContentsType.type_rar:      return "rar"
        case FContentsType.type_rtf:      return "rtf"
        case FContentsType.type_sh:       return "sh"
        case FContentsType.type_svg:      return "svg"
        case FContentsType.type_swf:      return "swf"
        case FContentsType.type_tar:      return "tar"
        case FContentsType.type_tif:      return "tif"
        case FContentsType.type_tiff:     return "tiff"
        case FContentsType.type_ttf:      return "ttf"
        case FContentsType.type_txt:      return "txt"
        case FContentsType.type_vsd:      return "vsd"
        case FContentsType.type_wav:      return "wav"
        case FContentsType.type_weba:     return "weba"
        case FContentsType.type_webm:     return "webm"
        case FContentsType.type_webp:     return "webp"
        case FContentsType.type_woff:     return "woff"
        case FContentsType.type_xhtml:    return "xhtml"
        case FContentsType.type_xls:      return "xls"
        case FContentsType.type_xlsx:     return "xlsx"
        case FContentsType.type_xlsm:     return "xlsm"
        case FContentsType.type_xml:      return "xml"
        case FContentsType.type_xul:      return "xul"
        case FContentsType.type_zip:      return "zip"
        case FContentsType.type_3gp:      return "3gp"
        case FContentsType.type_3g2:      return "3g2"
        case FContentsType.type_7z:       return "7z"
        default:            return "application/octet-stream"
        }
    }
}
