//
//  RMGeolocationService.swift
//  RxMars
//
//  Created by emoji on 2019/3/27.
//  Copyright © 2019 emoji. All rights reserved.
//

import CoreLocation
import RxCocoa
import RxSwift

class GeolocationService {
    //单例
    static let instance = GeolocationService()
    //Driver: 不会产生错误 主线程 共享状态变化
    private (set) var authorized: Driver<Bool>
    private (set) var location: Driver<CLLocationCoordinate2D>
    
    private let locationManager = CLLocationManager()
    
    private init() {
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        authorized = Observable.deferred { [weak locationManager] in
            let status = CLLocationManager.authorizationStatus()
            guard let locationManager = locationManager else {
                return Observable.just(status)
            }
            return locationManager
                .rx
                .didChangeAuthorizationStatus
                .startWith(status)
        }
        .asDriver(onErrorJustReturn: CLAuthorizationStatus.notDetermined)
            .map {
                switch $0 {
                case .authorizedAlways:
                    return false
                default:
                    return true
                }
        }
        location = locationManager
            .rx.didUpdateLocations
            .asDriver(onErrorJustReturn:[])
            .flatMap {
                return $0.last.map(Driver.just) ?? Driver.empty()
            }.map { $0.coordinate }
        
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        
    }
}
