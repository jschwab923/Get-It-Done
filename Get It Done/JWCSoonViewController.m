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
#import "JWCSubtask.h"
#import "JWCSoonCollectionViewCell.h"

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

//Only visible when all subtasks marked as done
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (nonatomic) UITapGestureRecognizer *taskDoneTapRecognizer;

@property (nonatomic) UIImageView *imageViewProgressFace;

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
    [self updateCustomConstraints];
    if ([[JWCTaskManager sharedManager] getProgressFloatValue] < .1) {
        [self.progressViewPie setProgress:.1 animated:YES];
    } else {
        [self.progressViewPie setProgress:[[JWCTaskManager sharedManager] getProgressFloatValue] animated:YES];
    }
    [self.collectionViewTasks reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.progressViewPie setProgress:0 animated:YES];
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

//#pragma mark - ScrollView Methods
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    CGFloat newHeight = 150.f - scrollView.contentOffset.y;
//    [_progressContainerView.subviews[0] setFrame:CGRectMake(scrollView.contentOffset.y / 2.f, 0, newHeight , newHeight)];
//    [_progressContainerView.subviews[0] setNeedsDisplay];
//}

- (IBAction)pressedSubtaskDone:(UIButton *)sender
{
    NSUInteger subCount = [[JWCTaskManager sharedManager].currentTask.subTasks count];
    
    if (!sender.isSelected) {
        sender.selected = YES;
        [[JWCTaskManager sharedManager] setNumberOfSubtasksDone:[JWCTaskManager sharedManager].numberOfSubtasksDone + 1.0];
        [[JWCTaskManager sharedManager] setProgress:[NSNumber numberWithFloat:[JWCTaskManager sharedManager].numberOfSubtasksDone/subCount]];
    } else {
        sender.selected = NO;
        [[JWCTaskManager sharedManager] setNumberOfSubtasksDone:[JWCTaskManager sharedManager].numberOfSubtasksDone - 1.0];
        [[JWCTaskManager sharedManager] setProgress:[NSNumber numberWithFloat:[JWCTaskManager sharedManager].numberOfSubtasksDone/subCount]];
    }
    
    // TODO: SET THIS PROGRESS VALUE WITH THE ACTUAL SELECTED SUBTASK PERCENT VALUE
    CGFloat currentProgress = [[JWCTaskManager sharedManager] getProgressFloatValue];

    [UIView animateWithDuration:.3 delay:0 options:0 animations:^{
        [self.progressViewPie setProgress:currentProgress animated:YES];
    } completion:^(BOOL finished) {
        if ([[JWCTaskManager sharedManager] getProgressFloatValue] >= .99) {
            [self showDoneButton];
        } else {
            [self hideDoneButton];
        }
    }];
}

#pragma mark - Convenience Methods
- (void)showDoneButton
{
    self.doneButton.titleLabel.textColor = [UIColor colorWithRed:0.166 green:0.667 blue:0.808 alpha:1.000];
    self.doneButton.transform = CGAffineTransformMakeScale(0, 0);
    self.doneButton.hidden = NO;
    
    self.taskDoneTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doneButtonPressed:)];
    [self.progressContainerView addGestureRecognizer:self.taskDoneTapRecognizer];
    
    [UIView animateWithDuration:.4 animations:^{
        self.doneButton.transform = CGAffineTransformIdentity;
        self.progressViewPie.primaryColor = [UIColor clearColor];
    }];
}

- (void)doneButtonPressed:(id)sender
{
    [self performSegueWithIdentifier:SEGUE_PROOF_DESCRIBE sender:self];
}

- (void)hideDoneButton
{
    if (self.taskDoneTapRecognizer) {
        [self.progressContainerView removeGestureRecognizer:self.taskDoneTapRecognizer];
    }
  
    self.doneButton.hidden = YES;
    self.progressViewPie.primaryColor = [UIColor darkBlueColor];
}

@end
