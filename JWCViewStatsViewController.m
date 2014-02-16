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
@property (weak, nonatomic) IBOutlet UIImageView *imageViewBackground;

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
    
    self.view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
  
    _pointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 20, 20)];
    
    _pointsLabel.font = DEFAULT_FONT;
    _pointsLabel.textColor = [UIColor darkGrayColor];
    [self.graphView addSubview:_pointsLabel];
    
    
    self.graphView.animationGraphEntranceSpeed = 3;
    self.graphView.delegate = self;
    self.graphView.enableTouchReport = YES;
    self.graphView.colorBottom = DEFAULT_PIE_TITLE_COLOR;
    self.graphView.alpha = .5;
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
    NSLog(@"%i", [[[JWCTaskManager sharedManager] getStatsDictionary] count]);
    return [[[JWCTaskManager sharedManager] getStatsDictionary] count] > 4 ?: 4;
}

- (float)valueForIndex:(NSInteger)index
{
    NSArray *pointsArray = [[[JWCTaskManager sharedManager] getStatsDictionary] allValues];
    if ([pointsArray count] > index) {
        NSNumber *points = (NSNumber *)pointsArray[index];
        return points.floatValue;
    } else {
        return 5;
    }
}

- (void)didTouchGraphWithClosestIndex:(int)index
{
    NSMutableDictionary *datesAndPoints = [[JWCTaskManager sharedManager] getStatsDictionary];
    if ([datesAndPoints count] > index) {
        NSArray *datesArray = [datesAndPoints allKeys];
        NSArray *pointsArray = [datesAndPoints allValues];
        NSNumber *pointForDate = (NSNumber *)pointsArray[index];
        _pointsLabel.text = [NSString stringWithFormat:@"Date:%@ Points:%i", (NSString *)datesArray[index], pointForDate.integerValue];
    }
}

@end
