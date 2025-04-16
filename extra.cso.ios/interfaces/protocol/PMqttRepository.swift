protocol PMqttRepository {
    func getSubscribe() async -> RestResultT<MqttConnectModel>
    func postPublish(_ topic: String, _ mqttContentModel: MqttContentModel) async -> RestResult
    func postQnA(_ thisPK: String, _ content: String) async -> RestResult
    func postEDIRequest(_ thisPK: String, _ content: String) async -> RestResult
    func postEDIFileAdd(_ thisPK: String, _ content: String) async -> RestResult
    func postUserFileAdd(_ thisPK: String, _ content: String) async -> RestResult
}
