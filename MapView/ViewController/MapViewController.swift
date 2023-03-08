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
    let locationManager = CLLocationManager()
    
    var mapView = NMFMapView(frame: CGRect())
    var infoViewController = InfoViewController(parkingLot: nil)
    
    var lat: Double = 0
    var lng: Double = 0
    
    let parkingLots: [item]
    var searchResults: [item] = []
    var markers = [NMFMarker()]
    var selectedParkingLot = ""
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isHidden = true
        
        return tableView
    }()
    
    init(parkingLots: [item]) {
        self.parkingLots = parkingLots
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationItems()
        layout()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            print("위치 서비스 on")
            self.locationManager.startUpdatingLocation()
            
//            lat = self.locationManager.location?.coordinate.latitude ?? 0
//            lng = self.locationManager.location?.coordinate.longitude ?? 0
            lat = 37.5670135
            lng = 126.9783740
            
            moveCamera(lat: lat, lng: lng)
        } else {
            print("위치 서비스 off")
        }
        
        showOverlay()
        showNearParkingLots(nearParkingLots: findNearParkingLot(lat: lat, lng: lng, range: 0.01))
        
        mapView.touchDelegate = self
        mapView.addCameraDelegate(delegate: self)
        //mapView.positionMode = .direction
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
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        deleteMarkers()
        showNearParkingLots(nearParkingLots: findNearParkingLot(lat: mapView.cameraPosition.target.lat,
                                                                lng: mapView.cameraPosition.target.lng,
                                                                range: 0.01))
    }
}

extension MapViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let parkingLot = searchResults[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = MapViewController.parkingLotRename(parkingLot: parkingLot)
        cell.detailTextLabel?.text = parkingLot.address
        
        cell.textLabel?.textColor = .black
        cell.textLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        
        cell.detailTextLabel?.textColor = .gray
        cell.detailTextLabel?.font = .systemFont(ofSize: 15, weight: .regular)
        
        return cell
    }
}

extension MapViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let parkingLot = searchResults[indexPath.row]
        
        guard let lat = Double(parkingLot.lat) else { return }
        guard let lng = Double(parkingLot.lng) else { return }
        
        deleteMarkers()
        tableView.isHidden = true
        navigationItem.searchController?.dismiss(animated: true)
        
        moveCamera(lat: lat, lng: lng)
        self.showInfoView(parkingLot: parkingLot)
        
        selectedParkingLot = parkingLot.name
    }
}

extension MapViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.infoViewController.dismiss()
        
        tableView.isHidden = false
        tableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        tableView.isHidden = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchResults = []
        searchParkingLots(from: searchText)
    }
}

extension MapViewController {
    static func parkingLotRename(parkingLot: item?) -> String {
        guard let parkingLot = parkingLot else { return "" }
        
        var name = parkingLot.name
        
        if !name.contains("공영") && !name.contains("민영") { name += parkingLot.type }
        if !name.contains("주차장") { name += "주차장" }
        
        return name
    }
    
    private func layout() {
        mapView = NMFMapView(frame: view.frame)
        
        [
            mapView,
            tableView
        ].forEach { view.addSubview($0) }
        
        mapView.snp.makeConstraints {$0.edges.equalToSuperview() }
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    private func setNavigationItems() {
        navigationController?.title = "주변 주차장 찾기"
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.view.backgroundColor = .white

        navigationItem.leftBarButtonItem = UIBarButtonItem()

        let searchController = UISearchController()
        searchController.searchBar.placeholder = "주차장 정보를 입력하여 검색하세요."
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self

        navigationItem.searchController = searchController
    }
    
    private func showOverlay() {
        let locationOverlay = mapView.locationOverlay

        locationOverlay.hidden = false
        locationOverlay.location = NMGLatLng(
            lat: lat,
            lng: lng)
        
        locationOverlay.iconWidth = 100
        locationOverlay.iconHeight = 100
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
    
    private func showInfoView(parkingLot: item) {
        self.infoViewController.dismiss()
        
        self.infoViewController = InfoViewController(parkingLot: parkingLot)
        self.infoViewController.view.backgroundColor = .white
        self.infoViewController.modalPresentationStyle = .pageSheet
        
        if let sheet = self.infoViewController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = false

            sheet.largestUndimmedDetentIdentifier = .medium
        }

        mapView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 450, right: 0) //주차장 선택 시 마커가 infoView에 가려져서 위도 보정
        self.present(self.infoViewController, animated: true, completion: nil)
    }
    
    private func showNearParkingLots(nearParkingLots: [item]) {
        for parkingLot in nearParkingLots {
            let marker = NMFMarker()
            
            let lat = Double(parkingLot.lat) ?? 0
            let lng = Double(parkingLot.lng) ?? 0
            
            marker.position = NMGLatLng(
                lat: lat,
                lng: lng)
            
            marker.iconImage = NMFOverlayImage(name: "parkingLot_icon")
            marker.width = 30
            marker.height = 30
            
            marker.isHideCollidedMarkers = true
            marker.captionText = MapViewController.parkingLotRename(parkingLot: parkingLot)
            
            if parkingLot.name == selectedParkingLot {    //검색창에서 선택된 주차장 이름은 가리지 않음
                marker.zIndex = 1
                marker.isForceShowIcon = true
            }
            
            marker.touchHandler = { (overlay: NMFOverlay) -> Bool in
                self.selectedParkingLot = parkingLot.name
                
                self.moveCamera(lat: lat, lng: lng)
                self.showInfoView(parkingLot: parkingLot)
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
    
    private func searchParkingLots(from: String) {
        for parkingLot in parkingLots {
            if parkingLot.name.contains(from) { searchResults.append(parkingLot) }
            else if parkingLot.address.contains(from) { searchResults.append(parkingLot) }
            else if parkingLot.type.contains(from) { searchResults.append(parkingLot) }
        }
        
        tableView.reloadData()
    }
    
    private func moveCamera(lat: Double, lng: Double) {
        let cameraUpdate = NMFCameraUpdate(
            scrollTo: NMGLatLng(
                lat: lat,
                lng: lng))
        
        cameraUpdate.animation = .fly
        cameraUpdate.animationDuration = 0.25
        
        mapView.moveCamera(cameraUpdate)
    }
}
