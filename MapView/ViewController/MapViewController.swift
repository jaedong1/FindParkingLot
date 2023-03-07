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
    
    var infoViewController = InfoViewController(parkingLot: nil, mapViewController: nil)
    
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
        showNearParkingLots(nearParkingLots: findNearParkingLot(lat: lat, lng: lng, range: 0.03))
        
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
        infoViewController.dismiss()
    }
}

extension MapViewController: NMFMapViewCameraDelegate {
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        let cameraPosition = mapView.cameraPosition
        
        deleteMarkers()
        showNearParkingLots(nearParkingLots: findNearParkingLot(lat: cameraPosition.target.lat,
                                                                lng: cameraPosition.target.lng,
                                                                range: 0.03))
    }
}

extension MapViewController {
    private func showOverlay() {
        let locationOverlay = mapView.locationOverlay

        locationOverlay.hidden = false
        locationOverlay.location = NMGLatLng(
            lat: lat,
            lng: lng)
        
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
            
            marker.captionText = parkingLotRename(parkingLot: parkingLot)
            marker.isHideCollidedMarkers = true
            
            marker.touchHandler = { (overlay: NMFOverlay) -> Bool in
                self.infoViewController.dismiss()
                
                self.infoViewController = InfoViewController(parkingLot: parkingLot, mapViewController: self)
                self.infoViewController.view.backgroundColor = .white
                self.infoViewController.modalPresentationStyle = .pageSheet
                
                if let sheet = self.infoViewController.sheetPresentationController {
                    sheet.detents = [.medium()]
                    sheet.prefersGrabberVisible = false

                    sheet.largestUndimmedDetentIdentifier = .medium
                }

                self.present(self.infoViewController, animated: true, completion: nil)
                
                return true
            }
            
            marker.mapView = mapView
            markers.append(marker)
        }
    }
    
    private func deleteMarkers() {
        for marker in markers {
            marker.mapView = nil
        }
        
        markers = []
    }
    
    func parkingLotRename(parkingLot: item?) -> String {
        guard let parkingLot = parkingLot else { return "" }
        
        var name = parkingLot.name
        
        if !name.contains("공영") && !name.contains("민영") { name += parkingLot.type }
        if !name.contains("주차장") { name += "주차장" }
        
        return name
    }
}
