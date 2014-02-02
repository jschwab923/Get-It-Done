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

@interface JWCSoonViewController ()

{
    NSLayoutConstraint *_landScapeCollectionViewTopConstraint;
    NSLayoutConstraint *_landScapeCollectionViewLeftConstraint;
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
    
    [self setUpConstraints];
    
    self.label.textColor = [UIColor darkBlueColor];
    
    self.progressViewPie = [[M13ProgressViewPie alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    [self.progressContainerView addSubview:self.progressViewPie];
    
    self.progressViewPie.primaryColor = [UIColor darkBlueColor];
    self.progressViewPie.secondaryColor = [UIColor darkBlueColor];
    
    //TODO: Remove this default progress and base on current focus duration
    [self.progressViewPie setProgress:.7 animated:YES];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Rotation Handling
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight ||
        [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft)
    {
        [self.view removeConstraint:_portraitCollectionViewBottomConstraint];
        [self.view addConstraints:@[_landScapeCollectionViewTopConstraint,
                                    _landScapeCollectionViewLeftConstraint]];
    } else {
        [self.view removeConstraints:@[_landScapeCollectionViewTopConstraint,
                                       _landScapeCollectionViewLeftConstraint]];
        
        [self.view addConstraint:_portraitCollectionViewBottomConstraint];
    }
    
}

#pragma mark - Convenience Methods

- (void)setUpConstraints
{
    // Setup contraints for handling rotation
    _landScapeCollectionViewTopConstraint = [NSLayoutConstraint constraintWithItem:self.collectionViewTasks attribute:NSLayoutAttributeTop relatedBy:0 toItem:self.progressContainerView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    _landScapeCollectionViewLeftConstraint = [NSLayoutConstraint constraintWithItem:self.collectionViewTasks attribute:NSLayoutAttributeTrailing relatedBy:0 toItem:self.progressContainerView attribute:NSLayoutAttributeLeading multiplier:1 constant:5];
    
    _portraitCollectionViewBottomConstraint = [NSLayoutConstraint constraintWithItem:self.collectionViewTasks attribute:NSLayoutAttributeBottom relatedBy:0 toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    
    // Add appropriate constraints based on initial device orientation
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight ||
        [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight)
    {
        [self.view addConstraints:@[_landScapeCollectionViewTopConstraint,
                                    _landScapeCollectionViewLeftConstraint]];
    } else {
        [self.view addConstraint:_portraitCollectionViewBottomConstraint];
    }
}

@end
