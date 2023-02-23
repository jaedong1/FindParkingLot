//
//  MapViewController.swift
//  FindParkingLot
//
//  Created by 김재동 on 2023/02/09.
//

import UIKit
import NMapsMap
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, NMFMapViewTouchDelegate {

//    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapView = NMFMapView(frame: view.frame)
        
        view.addSubview(mapView)
        
        mapView.touchDelegate = self
        mapView.positionMode = .direction
             
//
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization()
        
//        if CLLocationManager.locationServicesEnabled() {
//            print("위치 서비스 on")
//            self.locationManager.startUpdatingLocation()
//            print(self.locationManager.location?.coordinate as Any)
//
//            let cameraUpdate = NMFCameraUpdate(
//                scrollTo: NMGLatLng(
//                    lat: self.locationManager.location?.coordinate.latitude ?? 0,
//                    lng: self.locationManager.location?.coordinate.longitude ?? 0))
//
//            cameraUpdate.animation = .easeIn
//            mapView.moveCamera(cameraUpdate)
//        } else {
//            print("위치 서비스 off")
//        }
        
//        let locationOverlay = mapView.locationOverlay
//
//        locationOverlay.hidden = false
//        locationOverlay.location = NMGLatLng(
//            lat: locationManager.location?.coordinate.latitude ?? 0,
//            lng: locationManager.location?.coordinate.longitude ?? 0)
//
//        locationOverlay.iconWidth = 100
//        locationOverlay.iconHeight = 100
//
//        locationOverlay.circleRadius = 50

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
//        let marker = NMFMarker()
//        marker.position = NMGLatLng(
//            lat: locationManager.location?.coordinate.latitude ?? 0,
//            lng: locationManager.location?.coordinate.longitude ?? 0)
//        marker.captionText = "서울특별시청"
//        marker.mapView = mapView
    }

    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        print("\(latlng.lat), \(latlng.lng)")
    }
}

