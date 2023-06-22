//
//  UserLocationManager.swift
//  mf-ble-app
//
//  Created by Yang Ding on 22.06.23.
//

import CoreLocation
import RxSwift
import Combine

class UserLocationManager: NSObject{
    
    let locationManager = CLLocationManager()
    // use rxswift to observe events
    var locationAuthorizationSubject = PublishSubject<CLAuthorizationStatus>()
    var locationAuthorizationObserver: AnyObserver<CLAuthorizationStatus> { locationAuthorizationSubject.asObserver() }
    var disposeBag = DisposeBag()
    
    //use combine to transmit usr location authorization state to main view controller
    private let userLocationAuthorizationCombineSubject = PassthroughSubject<Bool, Never>()
    var userLocationAuthorizationCombinePublisher: AnyPublisher<Bool, Never> {
        userLocationAuthorizationCombineSubject.eraseToAnyPublisher()
    }
    
    var hasLocationPermission: Bool = false
    
    static let shared = UserLocationManager()
    
    private override init() {
        super.init()
        locationManager.delegate = self
        let authorizationStatus = locationManager.authorizationStatus
        self.hasLocationPermission = authorizationStatus == CLAuthorizationStatus.authorizedAlways  || authorizationStatus == CLAuthorizationStatus.authorizedWhenInUse
        
        locationAuthorizationSubject.subscribe{
            status in
            print("location auth status is:")
            print(status)
            self.handleChangeLocationAuthorization(status)
        } onError: { error in
            print(error)
        }.disposed(by: disposeBag)
    }
    
    
    func handleChangeLocationAuthorization(_ locationStatus: CLAuthorizationStatus){
        self.hasLocationPermission = locationStatus == CLAuthorizationStatus.authorizedAlways  || locationStatus == CLAuthorizationStatus.authorizedWhenInUse
        self.userLocationAuthorizationCombineSubject.send(self.hasLocationPermission) 
    }
    
    func requestUserLocationAuthorization(){
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
}

// MARK: --- Extension CLLocation Manager
extension UserLocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            print("latitude: \(lat)")
            print("longitude: \(lon)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("locationManager error: \(error)")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        //        case notDetermined = 0 (ask next time)
        //        case restricted = 1
        //        case denied = 2 (never)
        //        case authorizedAlways = 3
        //        case authorizedWhenInUse = 4 (while using the app)
        print("authorization Status is now:::::: \(manager.authorizationStatus)")
        locationAuthorizationObserver.onNext(manager.authorizationStatus)
    }
}

