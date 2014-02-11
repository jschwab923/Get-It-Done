//
//  JWCAppDelegate.m
//  Get It Done
//
//  Created by Jeff Schwab on 1/30/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCAppDelegate.h"
#import "UIColor+GetItDoneColors.h"
#import "JWCTaskManager.h"

@implementation JWCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIFont fontWithName:@"HelveticaNeue-Thin" size:18], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [[UINavigationBar appearance] setTitleTextAttributes:textAttributes];
    [[UIBarButtonItem appearance] setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    
    if (CGRectGetHeight([UIScreen mainScreen].bounds) == 568) {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:LANDSCAPE_IMAGE] forBarMetrics:UIBarMetricsLandscapePhone];
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:NAVBAR_IMAGE]
                                           forBarMetrics:UIBarMetricsDefault];
    } else {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:LANDSCAPE_IMAGE4] forBarMetrics:UIBarMetricsLandscapePhone];
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:NAVBAR_IMAGE4]
                                           forBarMetrics:UIBarMetricsDefault];
    }
        
    [[JWCTaskManager sharedManager] loadCurrentTasks];
    
    NSOperationQueue *loadQueue = [NSOperationQueue new];
    [loadQueue addOperationWithBlock:^{
         [[JWCTaskManager sharedManager] loadDoneTasks];
    }];
    
    //TODO: REMOVE THIS SHIT
    NSString *firstName;
    NSString *testString = @"Timothy HiseMan";
    firstName = [[testString componentsSeparatedByString:@" "] firstObject];
    NSLog(@"%@", firstName);
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [[JWCTaskManager sharedManager] saveCurrentTasks];
    [[JWCTaskManager sharedManager] saveDoneTasks];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
