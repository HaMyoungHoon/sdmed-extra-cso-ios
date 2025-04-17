import Foundation
import CocoaMQTT

class FMqttBackgroundService {
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
    
    func mqttConnect(_ mqttConnectModel: MqttConnectModel) {
        if client?.connState == CocoaMQTTConnState.connected {
            return
        }
        let clientID = "ios-extra-cso/\(UUID().uuidString)"
        guard let brokerBuff = mqttConnectModel.brokerUrl.first(where: { $0.contains("tc") || $0.contains("tcp") }) else {
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

        client.username = mqttConnectModel.userName
        client.password = mqttConnectModel.password
        for topic in mqttConnectModel.topic {
            client.subscribe(topic, qos: .qos1)
        }
        client.keepAlive = 60
        client.didReceiveMessage = { mqtt, message, id, decode in
            self.parsePublish(message)
        }
        _ = client.connect()
    }
    func mqtt5(_ mqtt: CocoaMQTT5, didReceiveMessage message: CocoaMQTT5Message, id: UInt16) {
        
    }
    func parsePublish(_ data: CocoaMQTT5Message) {
        let mqttContentModel = MqttContentModel().parseThis(data.topic, data.payload)
        if mqttContentModel.senderPK == FAmhohwa.getThisPK() {
            return
        }
    }
}
