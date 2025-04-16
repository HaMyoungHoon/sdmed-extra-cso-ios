class MqttConnectModel: Decodable {
    @FallbackDataClass var brokerUrl: [String]
    @FallbackDataClass var topic: [String]
    @FallbackString var userName: String
    @FallbackString var password: String
}
