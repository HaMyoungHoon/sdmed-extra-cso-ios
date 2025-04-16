import Foundation
import GoogleMaps
import GoogleMapsUtils
class MarkerClusterDataModel: NSObject, GMUClusterItem {
    var thisPK: String = ""
    var orgName: String = ""
    var address: String = ""
    var phoneNumber: String = ""
    var websiteUrl: String = ""
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var resDrawableId: String = ""
    var markerType: MarkerClusterType = MarkerClusterType.NONE
    var position: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: FConstants.DEF_LATITUDE, longitude: FConstants.DEF_LONGITUDE)
    }
    var title: String {
        return orgName
    }
    var snippet: String? {
        if address.isEmpty {
            return nil
        }
        
        return address
    }
    
}
