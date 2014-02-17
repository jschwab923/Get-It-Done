//
//  JWCSoonViewController.m
//  Get It Done
//
//  Created by Jeff Schwab on 1/30/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCSoonViewController.h"
#import "M13ProgressViewPie.h"
#import "JWCTaskManager.h"
#import "JWCViewControllerAnimatedTransition.h"
#import "JWCViewStatsViewController.h"
#import "JWCSubtask.h"
#import "JWCSoonCollectionViewCell.h"
#import "JWCSoonCollectionViewHeader.h"
#import "KGModal.h"

#import "JWCViewLine.h"

#import "JWCSoonCollectionViewDataSource.h"

@interface JWCSoonViewController ()

{
    NSLayoutConstraint *_landScapeCollectionViewTopConstraint;
    NSLayoutConstraint *_landScapeCollectionViewLeftConstraint;
    NSLayoutConstraint *_landScapeCollectionViewBottomConstraint;
    NSLayoutConstraint *_landScapeProgressViewLeftConstraint;
    
    NSLayoutConstraint *_portraitCollectionViewBottomConstraint;
    NSLayoutConstraint *_portraitCollectionViewTopConstraint;
    
    JWCViewLine *_underLine;
    
    CGRect _originalContainerViewFrame;
    CGRect _originalCollectionViewFrame;
}

//Only visible when all subtasks marked as done
@property (nonatomic) UILabel *doneButton;
@property (nonatomic) UITapGestureRecognizer *taskDoneTapRecognizer;

@property (weak, nonatomic) UIImageView *imageViewFace;

@property (weak, nonatomic) IBOutlet UIView *viewLabelProgressContainter;
@property (nonatomic) M13ProgressViewPie *progressViewPie;
@property (weak, nonatomic) IBOutlet UIView *progressContainerView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewTasks;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewBackground;

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
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    self.view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    self.collectionViewTasks.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    
    self.viewLabelProgressContainter.backgroundColor = DEFAULT_FOREGROUND_COLOR;
    self.viewLabelProgressContainter.autoresizesSubviews = YES;
    self.viewLabelProgressContainter.layer.shadowColor = [UIColor colorWithRed:0.110 green:0.040 blue:0.194 alpha:0.620].CGColor;
    self.viewLabelProgressContainter.layer.shadowOffset = CGSizeMake(0, -3);
    [self.view bringSubviewToFront:self.viewLabelProgressContainter];
    _originalContainerViewFrame = self.viewLabelProgressContainter.frame;
    
    self.label.textColor = DEFAULT_PIE_TITLE_COLOR;
    
    _underLine = [[JWCViewLine alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(self.collectionViewTasks.frame)-3, CGRectGetWidth(self.viewLabelProgressContainter.frame), 1)];
    [self.viewLabelProgressContainter addSubview:_underLine];
    
    
    self.progressViewPie = [[M13ProgressViewPie alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    [self.progressContainerView addSubview:self.progressViewPie];
    
    self.progressViewPie.primaryColor = DEFAULT_PIE_TITLE_COLOR;
    self.progressViewPie.secondaryColor = DEFAULT_PIE_TITLE_COLOR;
    
    // Hidden until all subtasks marked as done
    self.doneButton = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_progressViewPie.frame)*.9, CGRectGetHeight(_progressViewPie.frame))];
    self.doneButton.center = _progressViewPie.center;
    self.doneButton.text = @"Tap to Prove";
    self.doneButton.font = DEFAULT_FONT;
    self.doneButton.textColor = [UIColor colorWithRed:0.000 green:1.000 blue:0.958 alpha:1.000];
    self.doneButton.textAlignment = NSTextAlignmentCenter;
    
    self.collectionViewTasks.delegate = self;
    self.collectionViewTasks.directionalLockEnabled = YES;
    _originalCollectionViewFrame = self.collectionViewTasks.frame;
    
    // Setup task done gesture recognier
    UISwipeGestureRecognizer *sideSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(collectionViewCellSwiped:)];
    [sideSwipeGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    
    // Setup swipe down to bring back progress pie
    UISwipeGestureRecognizer *downSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(collectionViewSwipedDown:)];
    [downSwipeGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionDown];
    
    [self.collectionViewTasks addGestureRecognizer:downSwipeGestureRecognizer];
    
    //    [self setUpConstraintsAndFramesForCurrentDevice];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    [self updateCustomConstraints];
    self.doneButton.transform = CGAffineTransformMakeScale(0, 0);
    
    if ([[JWCTaskManager sharedManager] getProgressPercent] > .01) {
        [self.progressViewPie setProgress:[[JWCTaskManager sharedManager] getProgressPercent]
                                 animated:YES];
    } else {
        [self.progressViewPie setProgress:.2 animated:YES];
    }
    [self.collectionViewTasks reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    if ([[JWCTaskManager sharedManager] getProgressPercent] > .07) {
        [self.progressViewPie setProgress:[[JWCTaskManager sharedManager] getProgressPercent]
                                 animated:YES];
    } else {
        [self.progressViewPie setProgress:0 animated:YES];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.progressViewPie setProgress:0 animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Rotation Handling
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    //    [self updateCustomConstraints];
}

#pragma mark - ScrollView Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint scrollViewContentOffset = [scrollView contentOffset];
    if (scrollViewContentOffset.y > 70) {
        [UIView animateKeyframesWithDuration:.2 delay:0 options:0 animations:^{
            self.collectionViewTasks.frame = CGRectMake(0, 64, CGRectGetWidth(self.collectionViewTasks.frame), CGRectGetHeight(self.view.frame) - 64);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.7 animations:^{
                self.viewLabelProgressContainter.center = CGPointMake(CGRectGetMidX(self.viewLabelProgressContainter.frame), -CGRectGetHeight(self.viewLabelProgressContainter.frame)/2+20);
            } completion:^(BOOL finished) {
                
            }];
        }];
    } else if (CGRectGetHeight(self.collectionViewTasks.frame) == CGRectGetHeight(self.view.frame)-64) {
        if (scrollViewContentOffset.y < 0) {
            [self collectionViewSwipedDown:nil];
        }
    }
}

#pragma mark - Contraints and Orientation Methods
//
//- (void)updateCustomConstraints
//{
//    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight ||
//        [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft)
//    {
//        [_underLine removeFromSuperview];
//        [self.view removeConstraints:@[_portraitCollectionViewBottomConstraint,
//                                       _portraitCollectionViewTopConstraint]];
//        
//        [self.view addConstraints:@[_landScapeCollectionViewTopConstraint,
//                                    _landScapeCollectionViewLeftConstraint,
//                                    _landScapeCollectionViewBottomConstraint,
//                                    _landScapeProgressViewLeftConstraint]];
//        [self.collectionViewTasks.collectionViewLayout invalidateLayout];
//    } else {
//        [self.view addSubview:_underLine];
//        [self.view removeConstraints:@[_landScapeCollectionViewTopConstraint,
//                                       _landScapeCollectionViewLeftConstraint,
//                                       _landScapeProgressViewLeftConstraint,
//                                       _landScapeCollectionViewBottomConstraint]];
//        
//        [self.view addConstraints:@[_portraitCollectionViewBottomConstraint,
//                                    _portraitCollectionViewTopConstraint]];
//        [self.collectionViewTasks.collectionViewLayout invalidateLayout];
//    }
//}
//
//- (void)setUpConstraintsAndFramesForCurrentDevice
//{
//    // Setup contraints for handling rotation
//    _landScapeCollectionViewTopConstraint = [NSLayoutConstraint constraintWithItem:self.collectionViewTasks attribute:NSLayoutAttributeTop relatedBy:0 toItem:self.progressContainerView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
//    _landScapeCollectionViewLeftConstraint = [NSLayoutConstraint constraintWithItem:self.collectionViewTasks attribute:NSLayoutAttributeLeft relatedBy:0 toItem:self.progressContainerView attribute:NSLayoutAttributeRight multiplier:1 constant:5];
//    _landScapeCollectionViewBottomConstraint = [NSLayoutConstraint constraintWithItem:self.collectionViewTasks attribute:NSLayoutAttributeBottom relatedBy:0 toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
//    
//    _landScapeProgressViewLeftConstraint = [NSLayoutConstraint constraintWithItem:self.progressContainerView attribute:NSLayoutAttributeLeft relatedBy:0 toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:5];
//    
//    _portraitCollectionViewBottomConstraint = [NSLayoutConstraint constraintWithItem:self.collectionViewTasks attribute:NSLayoutAttributeBottom relatedBy:0 toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
//    _portraitCollectionViewTopConstraint = [NSLayoutConstraint constraintWithItem:self.collectionViewTasks attribute:NSLayoutAttributeTop relatedBy:0 toItem:self.viewLabelProgressContainter attribute:NSLayoutAttributeBottom multiplier:1 constant:5];
//    
//    
//    // Add appropriate constraints based on initial device orientation and screen size
//    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
//    
//    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight ||
//        [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft)
//    {
//        if (screenSize.height == 480) {
//            [self.view addConstraints:@[_landScapeCollectionViewTopConstraint,
//                                        _landScapeProgressViewLeftConstraint,
//                                        _landScapeCollectionViewBottomConstraint]];
//        } else if (screenSize.height == 568) {
//            [self.view addConstraints:@[_landScapeCollectionViewTopConstraint,
//                                        _landScapeProgressViewLeftConstraint,
//                                        _landScapeCollectionViewBottomConstraint]];
//        }
//    } else {
//        [self.view addConstraints:@[_portraitCollectionViewBottomConstraint,
//                                    _portraitCollectionViewTopConstraint]];
//    }
//}

#pragma mark - Custom Transition Methods
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString: @"ViewStatsSeque"]) {
        JWCViewStatsViewController *destinationViewController = (JWCViewStatsViewController *)segue.destinationViewController;
        
        destinationViewController.modalPresentationStyle = UIModalPresentationCustom;
        destinationViewController.segue = segue;
    }
}

#pragma mark - UICollectionViewDelegate Methods
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Get height of text
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:18];
    CGSize textSize = CGSizeMake(265, MAXFLOAT);
    
    JWCTask *currentTask = [[JWCTaskManager sharedManager] currentTask];
    if (currentTask) {
        JWCSubtask *currentSubTask = (JWCSubtask *)[currentTask.subTasks objectAtIndex:indexPath.row];
        
        CGRect boundingRect = [currentSubTask.subTaskDescription boundingRectWithSize:textSize
                                                                              options:NSStringDrawingUsesLineFragmentOrigin
                                                                           attributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil]
                                                                              context:nil];
        
        CGSize roundedSize = CGSizeMake(CGRectGetWidth(collectionView.frame)-15, ceil(boundingRect.size.height)+15);
        
        return roundedSize;
    }
    return CGSizeMake(CGRectGetWidth(collectionView.frame), 50);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    // Get height of text
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:18];
    CGSize textSize = CGSizeMake(265.0, MAXFLOAT);
    
    JWCTask *currentTask = [[JWCTaskManager sharedManager] currentTask];
    if (currentTask) {
        CGRect boundingRect = [currentTask.title boundingRectWithSize:textSize
                                                              options:NSStringDrawingUsesLineFragmentOrigin
                                                           attributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil]
                                                              context:nil];
        
        CGSize roundedSize = CGSizeMake(CGRectGetWidth(collectionView.frame), ceil(boundingRect.size.height)+20);
        
        return roundedSize;
    }
    return CGSizeMake(CGRectGetWidth(collectionView.frame), 70);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel *detailsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    detailsLabel.numberOfLines = 0;
    detailsLabel.center = self.view.center;
    detailsLabel.font = DEFAULT_FONT;
    detailsLabel.textColor = [UIColor whiteColor];
    
    JWCSubtask *tappedSubtask = [JWCTaskManager sharedManager].currentTask.subTasks[indexPath.row];
    NSString *stringForDetails = [NSString stringWithFormat:@"Worth %i percent of total", tappedSubtask.percent.intValue];
    
    detailsLabel.text = stringForDetails;
    
    [[KGModal sharedInstance] showWithContentView:detailsLabel];
}

#pragma mark - Touch Handling
- (void)collectionViewCellSwiped:(UISwipeGestureRecognizer *)sideSwipe
{
    JWCSoonCollectionViewCell *swipedCell = (JWCSoonCollectionViewCell *)sideSwipe.view;
    NSIndexPath *swipedCellIndexPath = [self.collectionViewTasks indexPathForCell:swipedCell];
    [JWCTaskManager sharedManager].currentTask.numberOfTimesSubtasksChecked = [NSNumber numberWithInteger:[JWCTaskManager sharedManager].currentTask.numberOfTimesSubtasksChecked.integerValue + 1];
    
    UIButton *tappedCellButton = swipedCell.buttonSubtaskDone;
    tappedCellButton.selected = !tappedCellButton.selected;
    
    JWCSubtask *selectedSubtask =  [[JWCTaskManager sharedManager] currentTask].subTasks[swipedCellIndexPath.row];
    selectedSubtask.done = !selectedSubtask.done;
    
    NSNumber *subTaskPoints = [NSNumber numberWithFloat:(selectedSubtask.percent.floatValue/100.0)*[JWCTaskManager sharedManager].currentTask.points.floatValue];
    
    [[JWCTaskManager sharedManager] updateTaskProgress:subTaskPoints
                                           withSubtask:selectedSubtask];
    
    CGFloat currentProgressPercent = [[JWCTaskManager sharedManager] getProgressPercent];
    
    [UIView animateWithDuration:.3 delay:0 options:0 animations:^{
        [self.progressViewPie setProgress:currentProgressPercent animated:YES];
    } completion:^(BOOL finished) {
        if ([JWCTaskManager sharedManager].currentTask.numberOfSubtasksDone == [[JWCTaskManager sharedManager].currentTask.subTasks count]) {
            [self showDoneButton];
        } else {
            [self hideDoneButton];
        }
    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SUBTASK_DONE object:nil];
    
}

- (void)collectionViewSwipedDown:(UISwipeGestureRecognizer *)downSwipe
{
    CGFloat scrollViewContentOffsetY = self.collectionViewTasks.contentOffset.y;
    if (CGRectGetHeight(self.collectionViewTasks.frame) == CGRectGetHeight(self.view.frame)-64 && scrollViewContentOffsetY == 0) {
        [UIView animateKeyframesWithDuration:.7 delay:0 options:0 animations:^{
            self.viewLabelProgressContainter.frame = _originalContainerViewFrame;
            self.collectionViewTasks.frame = CGRectMake(_originalCollectionViewFrame.origin.x, _originalCollectionViewFrame.origin.y, CGRectGetWidth(_originalCollectionViewFrame), CGRectGetHeight(self.collectionViewTasks.frame));
        } completion:^(BOOL finished) {
            self.collectionViewTasks.frame = _originalCollectionViewFrame;
        }];
    } else if (CGRectGetHeight(self.collectionViewTasks.frame) == CGRectGetHeight(self.view.frame)-64 &&scrollViewContentOffsetY < -50) {
        [UIView animateKeyframesWithDuration:.7 delay:0 options:0 animations:^{
            self.viewLabelProgressContainter.frame = _originalContainerViewFrame;
            self.collectionViewTasks.frame = CGRectMake(_originalCollectionViewFrame.origin.x, _originalCollectionViewFrame.origin.y, CGRectGetWidth(_originalCollectionViewFrame), CGRectGetHeight(self.collectionViewTasks.frame));
        } completion:^(BOOL finished) {
            self.collectionViewTasks.frame = _originalCollectionViewFrame;
        }];
    }
}

#pragma mark - Convenience Methods
- (void)showDoneButton
{
    [_progressViewPie addSubview:self.doneButton];
    [_progressViewPie setProgress:1 animated:YES];
    [UIView animateWithDuration:.4 animations:^{
        self.doneButton.transform = CGAffineTransformIdentity;
    }];
    
    self.taskDoneTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doneButtonPressed:)];
    [self.progressContainerView addGestureRecognizer:self.taskDoneTapRecognizer];
}

- (void)hideDoneButton
{
    if (self.taskDoneTapRecognizer) {
        [self.progressContainerView removeGestureRecognizer:self.taskDoneTapRecognizer];
    }
    
    [UIView animateWithDuration:.3 animations:^{
        self.doneButton.transform = CGAffineTransformMakeScale(0, 0);
    }];
}

- (void)doneButtonPressed:(id)sender
{
    if ([[JWCTaskManager sharedManager].currentTask.proofType isEqualToString:PROOF_TYPE_DESCRIBE]) {
        [self performSegueWithIdentifier:SEGUE_PROOF_DESCRIBE sender:self];
    } else if ([[JWCTaskManager sharedManager].currentTask.proofType isEqualToString:PROOF_TYPE_QUESTIONS]) {
        [self performSegueWithIdentifier:SEGUE_PROOF_QUESTIONS sender:self];
    } else if ([[JWCTaskManager sharedManager].currentTask.proofType isEqualToString:PROOF_TYPE_PICTURE])
    {
        [self performSegueWithIdentifier:SEGUE_PROOF_PICTURE sender:self];
    }
}

@end
