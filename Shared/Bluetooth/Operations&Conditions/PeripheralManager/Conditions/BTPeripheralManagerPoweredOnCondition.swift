//
//  BTPeripheralManagerPoweredOnCondition.swift
//  BLE-Peripheral
//
//  Created by d503 on 3/22/16.
//  Copyright © 2016 d503. All rights reserved.
//

import Operations
import CoreBluetooth

class BTPeripheralManagerPoweredOnCondition: BTBaseCondition, OperationCondition {
    
    // MARK: Private Properties
    
    private unowned var peripheralManager: BTPeripheralManagerAPIType
    
    // MARK: Initializers
    
    init(withPeripheralManager peripheralManager: BTPeripheralManagerAPIType) {
        self.peripheralManager = peripheralManager
        super.init(mutuallyExclusive: false)
    }

    // MARK: OperationCondition protocol
    
    func dependencyForOperation(operation: Operation) -> NSOperation? {
        return .None
    }
    
    func evaluateForOperation(operation: Operation, completion: OperationConditionResult -> Void) {
        if peripheralManager.state == .PoweredOn {
            completion(.Satisfied)
        }
        else {
            let error = BTPeripheralManagerStateInvalidError(withExpectedState: .PoweredOn,
                realState: peripheralManager.state)
            completion(.Failed(error))
        }
    }
}

class BTPeripheralManagerPoweredOnWaitingCondition: BTPeripheralManagerPoweredOnCondition {
    
    // MARK: OperationCondition protocol
    
    override func dependencyForOperation(operation: Operation) -> NSOperation? {
        return BTPeripheralManagerPoweredOnWaitingOperation(withPeripheralManager: peripheralManager)
    }
}

class BTPeripheralManagerPoweredOnWaitingOperation: BTPeripheralManagerOperation {
    
    override func execute() {
        guard !cancelled else { return }
        
        guard peripheralManager?.state != .PoweredOn else {
            finish()
            return
        }
        
        peripheralManager?.addHandler(self)
    }
}

extension BTPeripheralManagerPoweredOnWaitingOperation: BTPeripheralManagerHandlerProtocol {
    
    func peripheralManagerDidUpdateState(peripheral: BTPeripheralManagerAPIType) {
        if peripheral.state == .PoweredOn {
            removeHandlerAndFinish()
        }
    }
}
