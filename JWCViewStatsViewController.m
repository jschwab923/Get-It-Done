//
//  JWCViewStatsViewController.m
//  Get It Done
//
//  Created by Jeff Schwab on 2/5/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCViewStatsViewController.h"
#import "JWCViewControllerAnimatedTransition.h"
#import "BEMSimpleLineGraphView.h"
#import "JWCTaskManager.h"

@interface JWCViewStatsViewController () <BEMSimpleLineGraphDelegate>

@property (weak, nonatomic) IBOutlet BEMSimpleLineGraphView *graphView;

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
    
    self.graphView.delegate = self;
    self.graphView.colorBottom = [UIColor colorWithRed:0.000 green:0.770 blue:0.884 alpha:0.820];
    
    [self performSegueWithIdentifier:@"SoonViewSegue" sender:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.graphView reloadGraph];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *destinationViewController = self.segue.sourceViewController;
    
    destinationViewController.transitioningDelegate = self;
    destinationViewController.modalPresentationStyle = UIModalPresentationCustom;
}

#pragma mark - BEMSimpleLineGraph Methods
- (int)numberOfPointsInGraph
{
    return 8;
}

- (float)valueForIndex:(NSInteger)index
{
    float randomNum = ((float)rand() / RAND_MAX) * 5;
    return randomNum;
}

@end
