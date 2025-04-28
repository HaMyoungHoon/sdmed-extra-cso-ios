import Foundation
import SwiftUI
import GoogleMaps
import GoogleMapsUtils

class MapViewController: UIViewController, GMSMapViewDelegate, GMUClusterManagerDelegate {
    var selectedLocation: CLLocationCoordinate2D? = nil
    private var mapView: GMSMapView!
    private var zoom: Float = FConstants.DEF_ZOOM
    private var clusterManager: GMUClusterManager!
    var onMapLoaded: (() -> Void)? = nil
    var markerClick: ((MarkerClusterDataModel) -> Void)? = nil
    var markerListClick: (([MarkerClusterDataModel]) -> Void)? = nil
    
    override func loadView() {
        let camera = GMSCameraPosition.camera(withLatitude: selectedLocation?.latitude ?? FConstants.DEF_LATITUDE,
                                              longitude: selectedLocation?.longitude ?? FConstants.DEF_LONGITUDE,
                                              zoom: zoom)
        let options = GMSMapViewOptions()
        options.camera = camera
        options.mapID = GMSMapID(identifier: FConstants.GOOGLE_MAP_ID_2)
        mapView = GMSMapView(options: options)
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        self.view = mapView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let iconGenerator = GMUDefaultClusterIconGenerator()
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: mapView, clusterIconGenerator: iconGenerator)
        clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm, renderer: renderer)
        clusterManager.setMapDelegate(self)
    }
    
    func moveCamera(_ uiView: GMSMapView, _ latitude: Double, _ longitude: Double) {
        uiView.animate(toLocation: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
    }
    func moveCamera(_ uiView: GMSMapView) {
        if let loc = selectedLocation {
            uiView.animate(toLocation: loc)
        }
    }
    func addMarker(_ marker: MarkerClusterDataModel) {
        clusterManager.add(marker)
    }
    func addMarker(_ marker: [MarkerClusterDataModel]) {
        clusterManager.add(marker)
    }
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        mapView.animate(toLocation: marker.position)
        if let cluster = marker.userData as? MarkerClusterDataModel {
            markerClick?(cluster)
        } else {
            print(marker)
        }
        return false
    }
    func mapView(_ mapView: GMSMapView, didTap overlay: GMSOverlay) {
        if let overlayUserData = overlay.userData {
            print("overlay.userData")
            print(overlayUserData)
        }
    }
    func mapViewDidFinishTileRendering(_ mapView: GMSMapView) {
        onMapLoaded?()
    }
    func clusterManager(_ clusterManager: GMUClusterManager, didTap cluster: any GMUCluster) -> Bool {
        let newCamera = GMSCameraPosition.camera(withTarget: cluster.position,zoom: mapView.camera.zoom + 1)
        var ret: [MarkerClusterDataModel] = []
        cluster.items.forEach {
            if let item = $0 as? MarkerClusterDataModel {
                ret.append(item)
            }
        }
        if ret.count > 0 {
            markerListClick?(ret)
        }
        return true
    }
    func setMapLoaded(_ handler: @escaping (() -> Void)) {
        self.onMapLoaded = handler
    }
    func setMarkerClicked(_ handler: @escaping ((MarkerClusterDataModel) -> Void)) {
        self.markerClick = handler
    }
    func setMarkerListClicked(_ handler: @escaping (([MarkerClusterDataModel]) -> Void)) {
        self.markerListClick = handler
    }
}
