//
//  SensorStatusView.h
//  Museum AR App
//
//  Created by Panos Peltekis on 9/12/20.
//  Copyright © 2020 Panos Peltekis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SensorStatusModel.h"

@interface SensorStatusView : UIView
- (void)setModel:(NSObject <SensorStatusModel> *)model;
- (void)update;
@end
