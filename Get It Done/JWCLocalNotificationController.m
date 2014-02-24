//
//  JWCLocalNotificationController.m
//  Get It Done
//
//  Created by Jeff Schwab on 2/17/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCLocalNotificationController.h"
#import "JWCTaskManager.h"

@implementation JWCLocalNotificationController

+ (void)registerLocalNotification
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:10];
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.alertAction = @"Get it done!";
    notification.alertBody = [JWCTaskManager sharedManager].currentTask.title ?: @"Anything that needs to get done?";
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

+ (void)cancelLocalNotification
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

@end
