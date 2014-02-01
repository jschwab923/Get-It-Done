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
    
    // Used to access preloaded background color with image
    JWCAppDelegate *appDelegate = (JWCAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.view.contentMode = UIViewContentModeScaleAspectFill;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.view.backgroundColor = appDelegate.backgroundColorPortrait;
    }
    
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
    // Used to access preloaded background color from image
    JWCAppDelegate *appDelegate = (JWCAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.view.contentMode = UIViewContentModeScaleAspectFill;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft||
            [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight)
        {
            self.view.backgroundColor = appDelegate.backgroundColorLandscape;
        } else {
            self.view.backgroundColor = appDelegate.backgroundColorPortrait;
        }
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    CGFloat newX = CGRectGetWidth(self.label.frame)+5;
    CGFloat newY = CGRectGetHeight(self.label.frame)+5;
    CGFloat newWidth = CGRectGetWidth(self.view.frame)/2 - 20;
    CGFloat newHeight = CGRectGetHeight(self.view.frame);
    
    CGRect newFrame = CGRectMake(newX, newY, newWidth, newHeight);
    
    CGPoint newCenter = CGPointMake(CGRectGetMidX(self.view.frame) + 20, CGRectGetHeight(self.view.frame)/2);
    
    [UIView animateWithDuration:duration animations:^{
        self.collectionViewTasks.center = newCenter;
        [self.collectionViewTasks.collectionViewLayout invalidateLayout];
    }];
}

@end
