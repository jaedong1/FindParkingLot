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
    var locationManager = CLLocationManager()
    let parkingLots: [item]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        let mapView = NMFMapView(frame: view.frame)
        view.addSubview(mapView)
        
        if CLLocationManager.locationServicesEnabled() {
            print("위치 서비스 on")
            self.locationManager.startUpdatingLocation()
            print(self.locationManager.location?.coordinate ?? 0)

            let cameraUpdate = NMFCameraUpdate(
                scrollTo: NMGLatLng(
                        lat: self.locationManager.location?.coordinate.latitude ?? 0,
                        lng: self.locationManager.location?.coordinate.longitude ?? 0))
//                    lat: 36,
//                    lng: 127))
            
            cameraUpdate.animation = .easeIn
            mapView.moveCamera(cameraUpdate)
        } else {
            print("위치 서비스 off")
        }
        
        showOverlay(mapView: mapView)
        //showNearParkingLots(mapView: mapView, nearParkingLots: findNearParkingLot(range: 0.01))
        showNearParkingLots(mapView: mapView, nearParkingLots: findNearParkingLot(range: 0.03))
        
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
        <#code#>
    }
}

extension MapViewController {
    private func findNearParkingLot(range: Double) -> [item] {
        guard let lat = self.locationManager.location?.coordinate.latitude else { return [] }
        guard let lng = self.locationManager.location?.coordinate.longitude else { return [] }
        
//        let lat = 36.0
//        let lng = 127.0

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
    
    private func showNearParkingLots(mapView: NMFMapView, nearParkingLots: [item]) {
        var markers = [NMFMarker()]
        
        for parkingLot in nearParkingLots {
            let marker = NMFMarker()
            
            marker.position = NMGLatLng(
                lat: Double(parkingLot.lat)!,
                lng: Double(parkingLot.lng)!)
            
            marker.captionText = parkingLot.name + parkingLot.type + "주차장"
            marker.mapView = mapView
            
            markers.append(marker)
        }
    }
    
    private func showOverlay(mapView: NMFMapView) {
        let locationOverlay = mapView.locationOverlay

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
}
