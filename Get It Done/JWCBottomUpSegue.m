//
//  JWCLeftSegue.m
//  Get It Done
//
//  Created by Jeff Schwab on 2/5/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCBottomUpSegue.h"
#import "JWCSoonViewController.h"
#import "JWCViewStatsViewController.h"

@implementation JWCBottomUpSegue

- (void)perform
{
    JWCSoonViewController *sourceController = (JWCSoonViewController *)self.sourceViewController;
    JWCViewStatsViewController *destinationController = (JWCViewStatsViewController *)self.destinationViewController;
    
    [UIView transitionWithView:sourceController.view duration:1 options:UIViewAnimationOptionTransitionCurlUp animations:^{
        [sourceController.navigationController pushViewController:destinationController animated:YES];
    } completion:^(BOOL finished) {
        
    }];
}

@end
