//
//  BTPeripheralManagerBlockHandler.swift
//  BLE-Peripheral
//
//  Created by d503 on 3/22/16.
//  Copyright © 2016 d503. All rights reserved.
//

import Foundation
import CoreBluetooth

@objc class BTPeripheralManagerBlockHandler: BTCustomQueueHandler {
    
    // MARK: Typenames
    
    typealias BTPeripheralManagerBlock = (peripheral: BTPeripheralManagerAPIType) -> Void
    typealias BTPeripheralManagerAdvertisingBlock = (peripheral: BTPeripheralManagerAPIType, error: NSError?) -> Void
    typealias BTPeripheralManagerServiceBlock = (peripheral: BTPeripheralManagerAPIType, addedService: CBService,
        error: NSError?) -> Void
    typealias BTPeripheralManagerReadBlock = (peripheral: BTPeripheralManagerAPIType, receivedReadRequest: CBATTRequest) -> Void
    typealias BTPeripheralManagerWriteBlock = (peripheral: BTPeripheralManagerAPIType, receivedWiteRequests: [CBATTRequest]) -> Void

    // MARK: Internal Properties
    
    var didUpdateStateBlock: BTPeripheralManagerBlock
    var didStartAdvertisingBlock: BTPeripheralManagerAdvertisingBlock?
    var didAddServiceBlock: BTPeripheralManagerServiceBlock?
    var didReceiveReadRequestBlock: BTPeripheralManagerReadBlock?
    var didReceiveWriteRequestsBlock : BTPeripheralManagerWriteBlock?
    
    // MARK: Initializers
    
    init(withDidUpdateStateBlock didUpdateStateBlock: BTPeripheralManagerBlock) {
        self.didUpdateStateBlock = didUpdateStateBlock
        super.init()
    }
}

// MARK: BTCentralManagerHandlerProtocol

extension BTPeripheralManagerBlockHandler: BTPeripheralManagerHandlerProtocol {
    // MARK: Monitoring Peripheral's State Changes
    
    func peripheralManagerDidUpdateState(peripheral: BTPeripheralManagerAPIType) {
        dispatch_async(queue) { [unowned self] () -> Void in
            self.didUpdateStateBlock(peripheral: peripheral)
        }
    }
    
    // MARK: Peripheral Manager Advertising Added
    
    func peripheralManagerDidStartAdvertising(peripheral: BTPeripheralManagerAPIType,
        error: NSError?) {
            dispatch_async(queue) { [unowned self] () -> Void in
                self.didStartAdvertisingBlock?(peripheral: peripheral, error: error)
            }
    }
    
    // MARK: Peripheral Manager Service Added
    
    func peripheralManager(peripheral: BTPeripheralManagerAPIType,
        didAddService service: CBService,
        error: NSError?) {
            dispatch_async(queue) { [unowned self] () -> Void in
                self.didAddServiceBlock?(peripheral: peripheral,
                    addedService: service,
                    error: error)
            }
    }
    
    // MARK: Receiving Read/Write Requests
    
    func peripheralManager(peripheral: BTPeripheralManagerAPIType,
        didReceiveReadRequest request: CBATTRequest) {
            dispatch_async(queue) { [unowned self] () -> Void in
                self.didReceiveReadRequestBlock?(peripheral: peripheral, receivedReadRequest: request)
            }
    }
    
    func peripheralManager(peripheral: BTPeripheralManagerAPIType,
        didReceiveWriteRequests requests: [CBATTRequest]) {
            dispatch_async(queue) { [unowned self] () -> Void in
                self.didReceiveWriteRequestsBlock?(peripheral: peripheral, receivedWiteRequests: requests)
            }
    }
}
