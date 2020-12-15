//
//  SensorStatus.h
//  Museum AR App
//
//  Created by Panos Peltekis on 9/12/20.
//  Copyright © 2020 Panos Peltekis. All rights reserved.
//

typedef NS_ENUM(NSInteger, SensorStatus) {
    /// The sensor's status is unknown
    SensorStatusIndeterminate,

    /// Access has not been granted by the user
    SensorStatusBlocked,

    /// The sensor is active but has not provided any observations
    SensorStatusUnavailable,

    /// The sensor is providing observations
    SensorStatusAvailable
};
