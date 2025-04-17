enum MqttContentType: String, Codable, CaseIterable {
    case None
    case QNA_REQUEST
    case QNA_REPLY
    case EDI_REQUEST
    case EDI_REJECT
    case EDI_OK
    case EDI_RECEP
    case EDI_FILE_ADD
    case EDI_FILE_DELETE
    case USER_FILE_ADD
}
