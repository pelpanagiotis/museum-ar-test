//
//  SensorStatusModel.swift
//  Museum AR App
//
//  Created by Panos Peltekis on 9/12/20.
//  Copyright © 2020 Panos Peltekis. All rights reserved.
//

import Foundation

protocol SensorStatusModel: NSObjectProtocol {
    var geoLocationStatus: SensorStatus { get }
    var wifiSignalStatus: SensorStatus { get }
    var bluetoothSignalStatus: SensorStatus { get }
}
