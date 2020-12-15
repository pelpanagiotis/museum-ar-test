//
//  SensorStatus.swift
//  Museum AR App
//
//  Created by Panos Peltekis on 8/12/20.
//  Copyright © 2020 Panos Peltekis. All rights reserved.
//

enum SensorStatus {
    /// The sensor's status is unknown
    case Indeterminate

    /// Access has not been granted by the user
    case Blocked

    /// The sensor is active but has not provided any observations
    case Unavailable

    /// The sensor is providing observations
    case Available
}

