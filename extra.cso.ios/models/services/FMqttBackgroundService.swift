import Foundation
import CocoaMQTT

class FMqttBackgroundService: CocoaMQTT5Delegate {
    func mqtt5(_ mqtt5: CocoaMQTT5, didConnectAck ack: CocoaMQTTCONNACKReasonCode, connAckData: MqttDecodeConnAck?) {
    }
    func mqtt5(_ mqtt5: CocoaMQTT5, didPublishMessage message: CocoaMQTT5Message, id: UInt16) {
    }
    func mqtt5(_ mqtt5: CocoaMQTT5, didPublishAck id: UInt16, pubAckData: MqttDecodePubAck?) {
    }
    func mqtt5(_ mqtt5: CocoaMQTT5, didPublishRec id: UInt16, pubRecData: MqttDecodePubRec?) {
    }
    func mqtt5(_ mqtt5: CocoaMQTT5, didReceiveMessage message: CocoaMQTT5Message, id: UInt16, publishData: MqttDecodePublish?) {
        self.parsePublish(message)
    }
    func mqtt5(_ mqtt5: CocoaMQTT5, didSubscribeTopics success: NSDictionary, failed: [String], subAckData: MqttDecodeSubAck?) {
    }
    func mqtt5(_ mqtt5: CocoaMQTT5, didUnsubscribeTopics topics: [String], unsubAckData: MqttDecodeUnsubAck?) {
    }
    func mqtt5(_ mqtt5: CocoaMQTT5, didReceiveDisconnectReasonCode reasonCode: CocoaMQTTDISCONNECTReasonCode) {
    }
    func mqtt5(_ mqtt5: CocoaMQTT5, didReceiveAuthReasonCode reasonCode: CocoaMQTTAUTHReasonCode) {
    }
    func mqtt5DidPing(_ mqtt5: CocoaMQTT5) {
    }
    func mqtt5DidReceivePong(_ mqtt5: CocoaMQTT5) {
    }
    func mqtt5DidDisconnect(_ mqtt5: CocoaMQTT5, withError err: (any Error)?) {
    }
    
    let notificationService = FDI.notificationService
    let mqttService = FDI.mqttService
    var client: CocoaMQTT5? = nil
    
    func mqttInit() async {
        if !FRestVariable.ins.tokenValid {
            return
        }
        
        let ret = await mqttService.getSubscribe()
        if ret.result != true {
            return
        }
        
        if let model = ret.data {
            mqttConnect(model)
        }
    }
    
    func mqttDisconnect() {
        if client?.connState != CocoaMQTTConnState.connected {
            return
        }
        client?.disconnect()
    }
    func mqttConnect(_ mqttConnectModel: MqttConnectModel) {
        if client?.connState == CocoaMQTTConnState.connected {
            return
        }
        let clientID = "ios-extra-cso/\(UUID().uuidString)"
        guard let brokerBuff = mqttConnectModel.brokerUrl.first(where: { $0.contains("tcp") }) else {
            return
        }

        var brokerType = ""
        var brokerUrl = ""
        var brokerPort = 0

        let splitProtocol = brokerBuff.components(separatedBy: "://")
        if splitProtocol.count > 1 {
            brokerType = splitProtocol[0]
            brokerUrl = splitProtocol[1]
        }

        let splitHost = brokerUrl.components(separatedBy: ":")
        if splitHost.count > 1 {
            brokerUrl = splitHost[0]
            brokerPort = Int(splitHost[1]) ?? 0
        }

        guard !brokerUrl.isEmpty, brokerPort != 0 else {
            return
        }
        let connectProperties = MqttConnectProperties()
        connectProperties.topicAliasMaximum = 0
        connectProperties.sessionExpiryInterval = 0
        connectProperties.receiveMaximum = 100
        connectProperties.maximumPacketSize = 500
        client = CocoaMQTT5(clientID: clientID, host: brokerUrl, port: UInt16(brokerPort))
        guard let client = client else {
            return
        }
        client.connectProperties = connectProperties
        client.enableSSL = false
        client.allowUntrustCACertificate = true
        client.username = mqttConnectModel.userName
        client.password = mqttConnectModel.password
        client.keepAlive = 60
        client.didConnectAck = { mqtt, code, ack in
            for topic in mqttConnectModel.topic {
                client.subscribe(topic, qos: .qos1)
            }
        }
        client.delegate = self
        _ = client.connect()
    }
    func parsePublish(_ data: CocoaMQTT5Message) {
        let mqttContentModel = MqttContentModel().parseThis(data.topic, data.payload)
        if mqttContentModel.senderPK == FAmhohwa.getThisPK() {
            return
        }
        
        let title: String
        let notifyIndex: NotifyIndex
        let content = mqttContentModel.content
        let targetPK = mqttContentModel.targetItemPK
        switch mqttContentModel.contentType {
        case MqttContentType.None:
            title = FAppLocalString.mqttTitleNone
            notifyIndex = NotifyIndex.UNKNOWN
            break
        case MqttContentType.QNA_REPLY:
            title = FAppLocalString.mqttTitleQnaReply
            notifyIndex = NotifyIndex.QNA_RESPONSE
            break
        case MqttContentType.EDI_REJECT:
            title = FAppLocalString.mqttTitleEdiReject
            notifyIndex = NotifyIndex.EDI_RESPONSE
            break
        case MqttContentType.EDI_OK:
            title = FAppLocalString.mqttTitleEdiOk
            notifyIndex = NotifyIndex.EDI_RESPONSE
            break
        case MqttContentType.EDI_RECEP:
            title = FAppLocalString.mqttTitleEdiRecep
            notifyIndex = NotifyIndex.EDI_RESPONSE
            break
        case MqttContentType.EDI_FILE_DELETE:
            title = FAppLocalString.mqttTitleEdiDelete
            notifyIndex = NotifyIndex.EDI_FILE_REMOVE
            break
        case MqttContentType.USER_FILE_ADD:
            title = FAppLocalString.mqttTitleUserFile
            notifyIndex = NotifyIndex.USER_FILE_UPLOAD
            break
        default: return
        }
        switch mqttContentModel.contentType {
        case MqttContentType.None: notificationService.sendNotify(title, content)
        case MqttContentType.QNA_REPLY: notificationService.sendNotify(notifyIndex, title, content, targetPK)
        case MqttContentType.EDI_REJECT: notificationService.sendNotify(notifyIndex, title, content, targetPK)
        case MqttContentType.EDI_OK: notificationService.sendNotify(notifyIndex, title, content, targetPK)
        case MqttContentType.EDI_RECEP: notificationService.sendNotify(notifyIndex, title, content, targetPK)
        case MqttContentType.EDI_FILE_DELETE: notificationService.sendNotify(notifyIndex, title, content, targetPK)
        case MqttContentType.USER_FILE_ADD: notificationService.sendNotify(notifyIndex, title, content, targetPK)
        default: return
        }
    }
}
