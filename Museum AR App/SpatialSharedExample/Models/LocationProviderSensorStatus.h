//
//  LocationProviderSensorStatus.h
//  Museum AR App
//
//  Created by Panos Peltekis on 9/12/20.
//  Copyright © 2020 Panos Peltekis. All rights reserved.
//

#import <AzureSpatialAnchors/AzureSpatialAnchors.h>
#import "SensorStatusModel.h"

@interface LocationProviderSensorStatus: NSObject <SensorStatusModel>
- (id)initForLocationProvider:(ASAPlatformLocationProvider *)locationProvider;
@end

