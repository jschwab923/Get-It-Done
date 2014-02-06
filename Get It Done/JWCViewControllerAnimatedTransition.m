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
        
        toViewController.view.center = CGPointMake(-CGRectGetWidth(fromViewController.view.frame)/2,fromViewController.view.center.y);
        [toViewController.view.layer setShadowColor:[UIColor blackColor].CGColor];
        [toViewController.view.layer setShadowOpacity:.5];
        [toViewController.view.layer setShadowOffset:CGSizeMake(7, 7)];
        
        [UIView animateWithDuration:.4 delay:0 options:0 animations:^{
            CGPoint fromViewOriginalCenter = fromViewController.view.center;
            fromViewController.view.center = CGPointMake(CGRectGetWidth(fromViewController.view.frame), fromViewOriginalCenter.y);
            toViewController.view.center = fromViewOriginalCenter;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    } else {
        [[transitionContext containerView] addSubview:toViewController.view];
        [[transitionContext containerView] addSubview:fromViewController.view];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]  animations:^{
            toViewController.view.center = CGPointMake(-CGRectGetWidth(fromViewController.view.frame)/2,fromViewController.view.center.y);
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
}

@end
