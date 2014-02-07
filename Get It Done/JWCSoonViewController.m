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
#import "JWCViewStatsViewController.h"

#import "JWCSoonCollectionViewDataSource.h"

@interface JWCSoonViewController () <CollectionScrollViewDelegate>

{
    NSLayoutConstraint *_landScapeCollectionViewTopConstraint;
    NSLayoutConstraint *_landScapeCollectionViewLeftConstraint;
    NSLayoutConstraint *_landScapeCollectionViewBottomConstraint;
    NSLayoutConstraint *_landScapeProgressViewLeftConstraint;
    
    NSLayoutConstraint *_portraitCollectionViewBottomConstraint;
    NSLayoutConstraint *_portraitCollectionViewTopConstraint;
}

@property (nonatomic) M13ProgressViewPie *progressViewPie;
@property (weak, nonatomic) IBOutlet UIView *progressContainerView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewTasks;

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButtonViewStats;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButtonAddTask;

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
    
    
    
    [self setUpConstraintsAndFramesForCurrentDevice];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self updateCustomConstraints];
    [self.collectionViewTasks reloadData];

    [self.progressViewPie setProgress:.7 animated:YES];

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.progressViewPie setProgress:0.f animated:NO];
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
        [self.view removeConstraints:@[_portraitCollectionViewBottomConstraint,
                                       _portraitCollectionViewTopConstraint]];
        
        [self.view addConstraints:@[_landScapeCollectionViewTopConstraint,
                                    _landScapeCollectionViewLeftConstraint,
                                    _landScapeCollectionViewBottomConstraint,
                                    _landScapeProgressViewLeftConstraint]];
        [self.collectionViewTasks.collectionViewLayout invalidateLayout];
    } else {
        [self.view removeConstraints:@[_landScapeCollectionViewTopConstraint,
                                       _landScapeCollectionViewLeftConstraint,
                                       _landScapeProgressViewLeftConstraint,
                                       _landScapeCollectionViewBottomConstraint]];
        
        [self.view addConstraints:@[_portraitCollectionViewBottomConstraint,
                                    _portraitCollectionViewTopConstraint]];
        [self.collectionViewTasks.collectionViewLayout invalidateLayout];
    }
}

- (void)setUpConstraintsAndFramesForCurrentDevice
{
    // Setup contraints for handling rotation
    _landScapeCollectionViewTopConstraint = [NSLayoutConstraint constraintWithItem:self.collectionViewTasks attribute:NSLayoutAttributeTop relatedBy:0 toItem:self.progressContainerView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    _landScapeCollectionViewLeftConstraint = [NSLayoutConstraint constraintWithItem:self.collectionViewTasks attribute:NSLayoutAttributeLeft relatedBy:0 toItem:self.progressContainerView attribute:NSLayoutAttributeRight multiplier:1 constant:5];
    _landScapeCollectionViewBottomConstraint = [NSLayoutConstraint constraintWithItem:self.collectionViewTasks attribute:NSLayoutAttributeBottom relatedBy:0 toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    
    _landScapeProgressViewLeftConstraint = [NSLayoutConstraint constraintWithItem:self.progressContainerView attribute:NSLayoutAttributeLeft relatedBy:0 toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:5];
    
    _portraitCollectionViewBottomConstraint = [NSLayoutConstraint constraintWithItem:self.collectionViewTasks attribute:NSLayoutAttributeBottom relatedBy:0 toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    _portraitCollectionViewTopConstraint = [NSLayoutConstraint constraintWithItem:self.collectionViewTasks attribute:NSLayoutAttributeTop relatedBy:0 toItem:self.progressContainerView attribute:NSLayoutAttributeBottom multiplier:1 constant:5];
    
    
    // Add appropriate constraints based on initial device orientation and screen size
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;

    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight ||
        [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft)
    {
        if (screenSize.height == 480) {
            [self.view addConstraints:@[_landScapeCollectionViewTopConstraint,
                                        _landScapeProgressViewLeftConstraint,
                                        _landScapeCollectionViewBottomConstraint]];
        } else if (screenSize.height == 568) {
            [self.view addConstraints:@[_landScapeCollectionViewTopConstraint,
                                        _landScapeProgressViewLeftConstraint,
                                        _landScapeCollectionViewBottomConstraint]];
        }
    } else {
        [self.view addConstraints:@[_portraitCollectionViewBottomConstraint,
                                    _portraitCollectionViewTopConstraint]];
    }
}

#pragma mark - Custom Transition Methods
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString: @"ViewStatsSeque"]) {
        JWCViewStatsViewController *destinationViewController = (JWCViewStatsViewController *)segue.destinationViewController;
        
        destinationViewController.transitioningDelegate = self;
        destinationViewController.modalPresentationStyle = UIModalPresentationCustom;
        destinationViewController.segue = segue;
    }
}

- (IBAction)viewStatsSegue:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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

#pragma mark - ScrollView Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat newHeight = 150.f - scrollView.contentOffset.y;
    [_progressContainerView.subviews[0] setFrame:CGRectMake(scrollView.contentOffset.y / 2.f, 0, newHeight , newHeight)];
    [_progressContainerView.subviews[0] setNeedsDisplay];

    
}

@end
