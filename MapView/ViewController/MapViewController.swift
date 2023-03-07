//
//  MapViewController.swift
//  FindParkingLot
//
//  Created by 김재동 on 2023/02/09.
//

import UIKit
import NMapsMap
import CoreLocation

class MapViewController: UIViewController {
    var mapView = NMFMapView(frame: CGRect())
    let locationManager = CLLocationManager()
    
    var lat: Double = 0
    var lng: Double = 0
    
    let parkingLots: [item]
    var markers = [NMFMarker()]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        mapView = NMFMapView(frame: view.frame)
        view.addSubview(mapView)
        
        if CLLocationManager.locationServicesEnabled() {
            print("위치 서비스 on")
            self.locationManager.startUpdatingLocation()
            
//            lat = self.locationManager.location?.coordinate.latitude ?? 0
//            lng = self.locationManager.location?.coordinate.longitude ?? 0
            lat = 37.5670135
            lng = 126.9783740

            let cameraUpdate = NMFCameraUpdate(
                scrollTo: NMGLatLng(
                    lat: lat,
                    lng: lng))
            
            cameraUpdate.animation = .easeIn
            mapView.moveCamera(cameraUpdate)
        } else {
            print("위치 서비스 off")
        }
        
        showOverlay()
        showNearParkingLots(nearParkingLots: findNearParkingLot(lat: lat, lng: lng, range: 0.01))
        
        mapView.touchDelegate = self
        mapView.addCameraDelegate(delegate: self)
        //mapView.positionMode = .direction
    }
    
    init(parkingLots: [item]) {
        self.parkingLots = parkingLots
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {

    }
}

extension MapViewController: NMFMapViewTouchDelegate {
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        print("\(latlng.lat), \(latlng.lng)")
    }
}

extension MapViewController: NMFMapViewCameraDelegate {
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        let cameraPosition = mapView.cameraPosition
        
        deleteMarkers()
        showNearParkingLots(nearParkingLots: findNearParkingLot(lat: cameraPosition.target.lat,
                                                                lng: cameraPosition.target.lng,
                                                                range: 0.01))
    }
}

extension MapViewController {
    private func showOverlay() {
        let locationOverlay = self.mapView.locationOverlay

        locationOverlay.hidden = false
        locationOverlay.location = NMGLatLng(
            lat: locationManager.location?.coordinate.latitude ?? 0,
            lng: locationManager.location?.coordinate.longitude ?? 0)
//            lat: 36,
//            lng: 127)
        
        locationOverlay.iconWidth = 100
        locationOverlay.iconHeight = 100

        //locationOverlay.circleRadius = 50
    }
    
    private func findNearParkingLot(lat: Double, lng: Double, range: Double) -> [item] {
        var nearParkingLots: [item] = []
        
        for parkingLot in parkingLots {
            switch Double(parkingLot.lat)! {
            case (lat - range)...(lat + range):
                break
            default:
                continue
            }
            
            switch Double(parkingLot.lng)! {
            case (lng - range)...(lng + range):
                break
            default:
                continue
            }
            
            nearParkingLots.append(parkingLot)
        }
        
        return nearParkingLots
    }
    
    private func showNearParkingLots(nearParkingLots: [item]) {
        for parkingLot in nearParkingLots {
            let marker = NMFMarker()
            
            marker.position = NMGLatLng(
                lat: Double(parkingLot.lat)!,
                lng: Double(parkingLot.lng)!)
            
            marker.iconImage = NMFOverlayImage(name: "parkingLot_icon")
            marker.width = 30
            marker.height = 30
            
            marker.captionText = parkingLot.name + parkingLot.type + "주차장"
            marker.isHideCollidedMarkers = true
            
            marker.mapView = self.mapView
            self.markers.append(marker)
        }
        print(mapView.self)
    }
    
    private func deleteMarkers() {
        for marker in self.markers {
            marker.mapView = nil
        }
        
        self.markers = []
    }
}
