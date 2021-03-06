//
//  BTPeripheralProviding.swift
//  BLE-Central-OSX
//
//  Created by d503 on 5/30/16.
//  Copyright © 2016 d503. All rights reserved.
//

import CoreBluetooth
import ReactiveCocoa
import Result

protocol BTPeripheralProviding {
        
    var peripherals: AnyProperty<[BTPeripheral]> { get }
    
    var centralManagerState: AnyProperty<CBCentralManagerState> { get }
    
    var isScanningForPeripherals: AnyProperty<Bool> { get }
}