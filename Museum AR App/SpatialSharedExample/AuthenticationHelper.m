//
//  AuthenticationHelper.m
//  Museum AR App
//
//  Created by Panos Peltekis on 9/12/20.
//  Copyright © 2020 Panos Peltekis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ADAL/ADAL.h>

@interface AuthenticationHelper : NSObject

+ (void) acquireAuthenticationToken: (void (^)(NSString *token, NSError *error))completionBlock;

@end

