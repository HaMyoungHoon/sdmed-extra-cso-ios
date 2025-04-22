import ActivityKit

struct UploadAttributes: ActivityAttributes {
    var uuid: String = ""
    
    init(_ uuid: String) {
        self.uuid = uuid
    }
    public struct ContentState: Codable, Hashable {
        var progress: Double = -1
        var title: String = ""
        var content: String = ""
        init(_ progress: Double, _ title: String, _ content: String) {
            self.progress = progress
            self.title = title
            self.content = content
        }
    }
}
