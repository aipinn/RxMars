//
//  RMModel.swift
//  RxMars
//
//  Created by emoji on 2019/3/23.
//  Copyright © 2019 emoji. All rights reserved.
//

import UIKit

struct RMProduct {
    let name: String
    let price: String
}

extension RMProduct: CustomStringConvertible {
    var description: String {
        return "name: \(name) price: \(price)"
    }
}
