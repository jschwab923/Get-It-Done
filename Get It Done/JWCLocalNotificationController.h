//
//  JWCLocalNotificationController.h
//  Get It Done
//
//  Created by Jeff Schwab on 2/17/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JWCLocalNotificationController : NSObject

+ (void)registerLocalNotification;
+ (void)cancelLocalNotification;

@end
