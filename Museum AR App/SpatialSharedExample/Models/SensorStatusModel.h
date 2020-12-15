//
//  SensorStatusModel.h
//  Museum AR App
//
//  Created by Panos Peltekis on 9/12/20.
//  Copyright © 2020 Panos Peltekis. All rights reserved.
//

#import "SensorStatus.h"

@protocol SensorStatusModel <NSObject>
@property (readonly) enum SensorStatus geoLocationStatus;
@property (readonly) enum SensorStatus wifiSignalStatus;
@property (readonly) enum SensorStatus bluetoothSignalStatus;
@end
