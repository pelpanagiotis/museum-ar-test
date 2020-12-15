//
//  SensorStatus.swift
//  Museum AR App
//
//  Created by Panos Peltekis on 9/12/20.
//  Copyright © 2020 Panos Peltekis. All rights reserved.
//

enum SensorStatus : Int {
    /// The sensor's status is unknown
    case indeterminate
    /// Access has not been granted by the user
    case blocked
    /// The sensor is active but has not provided any observations
    case unavailable
    /// The sensor is providing observations
    case available
}
