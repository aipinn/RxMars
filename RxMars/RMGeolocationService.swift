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
    
    static let instance = GeolocationService()
    private (set) var authorized: Driver<Bool>
    
}
