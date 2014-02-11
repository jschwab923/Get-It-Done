//
//  JWCViewController.m
//  Get It Done
//
//  Created by Jeff Schwab on 1/30/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCRootViewController.h"
#import "JWCSoonViewController.h"
#import "JWCAddTaskViewController.h"
#import "JWCViewControllerAnimatedTransition.h"

#import "JWCTwitterHandler.h"

@interface JWCRootViewController ()

@end

@implementation JWCRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    UIViewController *destinationViewController = segue.destinationViewController;
    destinationViewController.transitioningDelegate = self;
    destinationViewController.modalPresentationStyle = UIModalPresentationCustom;
    
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    JWCViewControllerAnimatedTransition *animator = [JWCViewControllerAnimatedTransition new];
    animator.presenting = YES;
    return animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    JWCViewControllerAnimatedTransition *animator = [JWCViewControllerAnimatedTransition new];
    return animator;
}
- (IBAction)tweet:(id)sender
{
    JWCTwitterHandler *twitterTest = [JWCTwitterHandler new];
    [twitterTest sendCustomTweet];
}


@end
