//
//  JWCSoonViewController.m
//  Get It Done
//
//  Created by Jeff Schwab on 1/30/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCSoonViewController.h"
#import "M13ProgressViewPie.h"
#import "UIColor+GetItDoneColors.h"
#import "JWCTaskManager.h"
#import "JWCViewControllerAnimatedTransition.h"

@interface JWCSoonViewController ()

{
    NSLayoutConstraint *_landScapeCollectionViewTopConstraint;
    NSLayoutConstraint *_landScapeCollectionViewLeftConstraint;
    NSLayoutConstraint *_landScapeProgressViewConstraint;
    NSLayoutConstraint *_portraitCollectionViewBottomConstraint;
}

@property (nonatomic) M13ProgressViewPie *progressViewPie;
@property (weak, nonatomic) IBOutlet UIView *progressContainerView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewTasks;

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation JWCSoonViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.label.textColor = [UIColor darkBlueColor];
    
    self.progressViewPie = [[M13ProgressViewPie alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    [self.progressContainerView addSubview:self.progressViewPie];
    
    self.progressViewPie.primaryColor = [UIColor darkBlueColor];
    self.progressViewPie.secondaryColor = [UIColor darkBlueColor];
    
    //TODO: Remove this default progress and base on current progress
    [self.progressViewPie setProgress:.7 animated:YES];
    
    [self setUpConstraintsAndFramesForCurrentDevice];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Rotation Handling
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self updateCustomConstraints];
}

#pragma mark - Contraints and Orientation Methods

- (void)updateCustomConstraints
{
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight ||
        [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft)
    {
        [self.view removeConstraint:_portraitCollectionViewBottomConstraint];
        [self.view addConstraints:@[_landScapeCollectionViewTopConstraint,
                                    _landScapeCollectionViewLeftConstraint,
                                    _landScapeProgressViewConstraint]];
        [self.collectionViewTasks.collectionViewLayout invalidateLayout];
    } else {
        [self.view removeConstraints:@[_landScapeCollectionViewTopConstraint,
                                       _landScapeCollectionViewLeftConstraint,
                                       _landScapeProgressViewConstraint]];
        [self.view addConstraint:_portraitCollectionViewBottomConstraint];
        [self.collectionViewTasks.collectionViewLayout invalidateLayout];
    }
}

- (void)setUpConstraintsAndFramesForCurrentDevice
{
    // Setup contraints for handling rotation
    _landScapeCollectionViewTopConstraint = [NSLayoutConstraint constraintWithItem:self.collectionViewTasks attribute:NSLayoutAttributeTop relatedBy:0 toItem:self.progressContainerView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    _landScapeCollectionViewLeftConstraint = [NSLayoutConstraint constraintWithItem:self.collectionViewTasks attribute:NSLayoutAttributeLeft relatedBy:0 toItem:self.progressContainerView attribute:NSLayoutAttributeRight multiplier:1 constant:5];
    
    _landScapeProgressViewConstraint = [NSLayoutConstraint constraintWithItem:self.progressContainerView attribute:NSLayoutAttributeLeft relatedBy:0 toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:5];
    
    _portraitCollectionViewBottomConstraint = [NSLayoutConstraint constraintWithItem:self.collectionViewTasks attribute:NSLayoutAttributeBottom relatedBy:0 toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    
    // Add appropriate constraints based on initial device orientation and screen size
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;

    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight ||
        [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft)
    {
        if (screenSize.height == 480) {
            [self.view addConstraints:@[_landScapeCollectionViewTopConstraint,
                                        _landScapeProgressViewConstraint]];
        } else if (screenSize.height == 568) {
            [self.view addConstraints:@[_landScapeCollectionViewTopConstraint,
                                        _landScapeProgressViewConstraint]];
        }
    } else {
        [self.view addConstraint:_portraitCollectionViewBottomConstraint];
    }
}

#pragma mark - Custom Transition Methods
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


@end
