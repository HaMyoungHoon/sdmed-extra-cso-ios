struct BlobStorageInfoModel: Decodable {
    @FallbackString var blobName: String
    @FallbackString var blobUrl: String
    @FallbackString var blobContainerName: String
    @FallbackString var sasKey: String
    
    enum CodingKeys: String, CodingKey {
        case blobName, blobUrl, blobContainerName, sasKey
    }
}
