//
//  BTPrototypes.swift
//  BLE-Central-OSX
//
//  Created by d503 on 7/3/16.
//  Copyright © 2016 d503. All rights reserved.
//

import CoreBluetooth

struct BTCharacteristicPrototype {
    let UUID: CBUUID
}

struct BTServicePrototype {
    let UUID: CBUUID
    let characteristicPrototypes: [BTCharacteristicPrototype]
}
