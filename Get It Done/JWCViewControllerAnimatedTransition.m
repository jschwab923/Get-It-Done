//
//  JWCViewControllerAnimatedTransition.m
//  Get It Done
//
//  Created by Jeff Schwab on 1/31/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCViewControllerAnimatedTransition.h"
#import "JWCSoonViewController.h"
#import "JWCAddTaskViewController.h"

@implementation JWCViewControllerAnimatedTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 1.0f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if (self.presenting) {
        [[transitionContext containerView] addSubview:fromViewController.view];
        [[transitionContext containerView] addSubview:toViewController.view];
        
        toViewController.view.transform = CGAffineTransformMakeScale(0, 0);
        
        [UIView animateKeyframesWithDuration:[self transitionDuration:transitionContext] delay:0 options:0 animations:^{
            toViewController.view.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    } else {
        [[transitionContext containerView] addSubview:toViewController.view];
        [[transitionContext containerView] addSubview:fromViewController.view];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]  animations:^{
            toViewController.view.transform = CGAffineTransformMakeScale(0, 0);
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
}

@end
