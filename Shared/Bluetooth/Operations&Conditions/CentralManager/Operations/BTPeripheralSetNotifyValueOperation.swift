//
//  BTPeripheralSetNotifyValueOperation.swift
//  BLE-Central-OSX
//
//  Created by d503 on 5/30/16.
//  Copyright © 2016 d503. All rights reserved.
//

import CoreBluetooth
import Operations

class BTPeripheralSetNotifyValueOperation: BTPeripheralOperation {
    
    // MARK: Private Properties
    
    private var notificationEnabled: Bool
    private var characterictic: CBCharacteristic
    
    // MARK: Initializers
    
    init(centralManager: BTCentralManagerAPIType,
         peripheral: BTPeripheralAPIType,
         characterictic: CBCharacteristic,
         notificationEnabled: Bool) {
        
        self.notificationEnabled = notificationEnabled
        self.characterictic = characterictic
        
        super.init(centralManager: centralManager,
                   peripheral: peripheral)
        
        // FIXME: add CBPeripheral's state condition
        addCondition(BTCentralManagerPoweredOnCondition(centralManager: centralManager))
    }
    
    override func execute() {
        guard !cancelled else { return }
        
        centralManager?.addHandler(self)
        peripheral?.addHandler(self)
        
        peripheral?.setNotifyValue(notificationEnabled,
                                   forCharacteristic: characterictic)
    }
}

// MARK: BTCentralManagerHandlerProtocol

extension BTPeripheralSetNotifyValueOperation: BTCentralManagerHandlerProtocol {
    
    func centralManagerDidUpdateState(central: BTCentralManagerAPIType) {
        
        if central.state != .PoweredOn {
            let error = BTCentralManagerStateInvalidError(withExpectedState: .PoweredOn,
                                                          realState: central.state)
            removeHandlerAndFinish(error)
        }
    }
    
    func centralManager(
        central: BTCentralManagerAPIType,
        didDisconnectPeripheral peripheral: BTPeripheralAPIType,
                                error: NSError?) {
        
        let btError: ErrorType? = (error != nil) ?
            BTCentralManagerFailToConnectPeripheralError(originalError: error) : nil
        removeHandlerAndFinish(btError)
    }
}

// MARK: BTPeripheralHandlerProtocol

extension BTPeripheralSetNotifyValueOperation: BTPeripheralHandlerProtocol {
    
    func peripheral(
        peripheral: BTPeripheralAPIType,
        didUpdateNotificationStateForCharacteristic characteristic: CBCharacteristic,
                                                    error: NSError?) {
        
        if let originalError = error {
            let btError = BTPeripheralUpdateNotificationStateForCharacteristicError(
                characteristicUUID: (characteristic.UUID.copy() as! CBUUID),
                originalError: originalError)
            removeHandlerAndFinish(btError)
            return
        }
        
        removeHandlerAndFinish()
    }
}
