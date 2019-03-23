//
//  RMProductViewModel.swift
//  RxMars
//
//  Created by emoji on 2019/3/23.
//  Copyright © 2019 emoji. All rights reserved.
//

import UIKit
import RxSwift

struct RMProductViewModel {
    let data = Observable.just([
        RMProduct(name: "Apple", price: "100"),
        RMProduct(name: "MI", price: "200"),
        RMProduct(name: "Mate", price: "300"),
        ])
}
