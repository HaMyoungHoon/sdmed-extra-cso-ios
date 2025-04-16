class MqttService: PMqttRepository {
    var baseUrl: String
    init(_ url: String) {
        baseUrl = url
    }
    func getSubscribe() async -> RestResultT<MqttConnectModel> {
        let url = "\(baseUrl)/subscribe"
        let http = FHttp()
        return await http.get(url, MqttConnectModel.self)
    }
    func postPublish(_ topic: String, _ mqttContentModel: MqttContentModel) async -> RestResult {
        let url = "\(baseUrl)/publish"
        let http = FHttp()
        http.addParam("topic", topic)
        return await http.post(url, mqttContentModel)
    }
    func postQnA(_ thisPK: String, _ content: String) async -> RestResult {
        let topic = "ios-extra-cso"
        let mqttContentModel = MqttContentModel()
        mqttContentModel.contentType = MqttContentType.QNA_REQUEST
        mqttContentModel.content = content
        mqttContentModel.targetItemPK = thisPK
        return await postPublish(topic, mqttContentModel)
    }
    func postEDIRequest(_ thisPK: String, _ content: String) async -> RestResult {
        let topic = "ios-extra-cso"
        let mqttContentModel = MqttContentModel()
        mqttContentModel.contentType = MqttContentType.EDI_REQUEST
        mqttContentModel.content = content
        mqttContentModel.targetItemPK = thisPK
        return await postPublish(topic, mqttContentModel)
    }
    func postEDIFileAdd(_ thisPK: String, _ content: String) async -> RestResult {
        let topic = "ios-extra-cso"
        let mqttContentModel = MqttContentModel()
        mqttContentModel.contentType = MqttContentType.EDI_FILE_ADD
        mqttContentModel.content = content
        mqttContentModel.targetItemPK = thisPK
        return await postPublish(topic, mqttContentModel)
    }
    func postUserFileAdd(_ thisPK: String, _ content: String) async -> RestResult {
        let topic = "ios-extra-cso"
        let mqttContentModel = MqttContentModel()
        mqttContentModel.contentType = MqttContentType.USER_FILE_ADD
        mqttContentModel.content = content
        mqttContentModel.targetItemPK = thisPK
        return await postPublish(topic, mqttContentModel)
    }
}
