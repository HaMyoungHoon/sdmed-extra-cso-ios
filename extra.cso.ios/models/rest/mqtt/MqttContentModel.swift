import Foundation

class MqttContentModel: Codable {
    var topic: String = ""
    @FallbackString var senderPK: String
    @FallbackString var senderName: String
    @FallbackString var content: String
    @FallbackEnum var contentType: MqttContentType
    @FallbackString var targetItemPK: String
    
    func parseThis(_ topic: String, _ payload: Data) -> MqttContentModel {
        self.topic = topic
        do {
            let buff = try JSONDecoder().decode(MqttContentModel.self, from: payload)
            self.senderPK = buff.senderPK
            self.senderName = buff.senderName
            self.content = buff.content
            self.contentType = buff.contentType
            self.targetItemPK = buff.targetItemPK
        } catch {
            
        }
        return self
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(_senderPK.wrappedValue, forKey: CodingKeys.senderPK)
        try container.encodeIfPresent(_senderName.wrappedValue, forKey: CodingKeys.senderName)
        try container.encodeIfPresent(_content.wrappedValue, forKey: CodingKeys.content)
        try container.encodeIfPresent(_contentType.wrappedValue.rawValue, forKey: CodingKeys.contentType)
        try container.encodeIfPresent(_targetItemPK.wrappedValue, forKey: CodingKeys.targetItemPK)
    }
    
    enum CodingKeys: String, CodingKey {
        case senderPK, senderName, content, contentType, targetItemPK
    }
}

