//
//  JWCViewStatsViewController.m
//  Get It Done
//
//  Created by Jeff Schwab on 2/5/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCViewStatsViewController.h"
#import "JWCViewControllerAnimatedTransition.h"

@interface JWCViewStatsViewController ()

@end

@implementation JWCViewStatsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self performSegueWithIdentifier:@"SoonViewSegue" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - Custom Transition Methods
//- (IBAction)pressedBack:(id)sender
//{
//    UIViewController *destinationViewController = self.segue.sourceViewController;
//    
//    destinationViewController.transitioningDelegate = self;
//    destinationViewController.modalPresentationStyle = UIModalPresentationCustom;
//}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *destinationViewController = self.segue.sourceViewController;
    
    destinationViewController.transitioningDelegate = self;
    destinationViewController.modalPresentationStyle = UIModalPresentationCustom;
}

//- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
//{
//    JWCViewControllerAnimatedTransition *animator = [JWCViewControllerAnimatedTransition new];
//    animator.presenting = YES;
//    return animator;
//}
//
//- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
//{
//    JWCViewControllerAnimatedTransition *animator = [JWCViewControllerAnimatedTransition new];
//    return animator;
//}
//- (IBAction)panGesturePanned:(id)sender
//{
//    
//}

@end
