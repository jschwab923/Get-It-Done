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
#import "KGModal.h"

@interface JWCViewStatsViewController () <BEMSimpleLineGraphDelegate, BEMAnimationDelegate>
{
    UILabel *_pointsLabel;
}

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
    
    _pointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 20, 20)];
    
    _pointsLabel.font = DEFAULT_FONT;
    _pointsLabel.textColor = [UIColor darkGrayColor];
    [self.graphView addSubview:_pointsLabel];
    
    self.graphView.animationGraphEntranceSpeed = 3;
    self.graphView.delegate = self;
    self.graphView.enableTouchReport = YES;
    self.graphView.colorBottom = [UIColor colorWithPatternImage:[UIImage imageNamed:@"iPhone5_4.png"]];
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
    return 10;
}

- (float)valueForIndex:(NSInteger)index
{
    int _defaultValues[] = {3, 8, 5, 7, 8, 10, 4, 10, 6, 4};
    return _defaultValues[index];
}

- (void)didTouchGraphWithClosestIndex:(int)index
{
    int _defaultValues[] = {3, 8, 5, 7, 8, 10, 4, 10, 6, 4};
    
    
    _pointsLabel.text = [NSString stringWithFormat:@"%i", _defaultValues[index]];
    
}

@end
