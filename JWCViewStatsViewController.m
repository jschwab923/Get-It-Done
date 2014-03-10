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
#import "NSDate+DateFormatter.h"

@interface JWCViewStatsViewController () <BEMSimpleLineGraphDelegate, BEMAnimationDelegate>
{
    UILabel *_pointsLabel;
    
    NSMutableDictionary *_datesAndPoints;
    NSSortDescriptor *_dateSort;
    NSArray *_datesArray;

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
  
    _pointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 250, 150)];
    
    _pointsLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:30];
    _pointsLabel.textColor = DEFAULT_TEXT_COLOR;
    _pointsLabel.numberOfLines = 0;
    [self.view addSubview:_pointsLabel];
    
    
    self.graphView.animationGraphEntranceSpeed = 3;
    self.graphView.delegate = self;
    self.graphView.enableTouchReport = YES;
    self.graphView.colorBottom = DEFAULT_PIE_TITLE_COLOR;
    self.graphView.colorLine = [UIColor clearColor];
    [self performSegueWithIdentifier:@"SoonViewSegue" sender:self];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.graphView reloadGraph];
    
    NSMutableDictionary *datesAndPoints = [[JWCTaskManager sharedManager] getStatsDictionary];
    NSString *currentDate = [NSDate getCurrentMonthDayYearString];
   
    if ([datesAndPoints objectForKey:currentDate]) {
        NSNumber *points = [datesAndPoints objectForKey:currentDate];
        _pointsLabel.text = [NSString stringWithFormat:@"Date:%@ Points:%i", currentDate, points.intValue];
    } else {
        [datesAndPoints setObject:@0 forKey:currentDate];
        _pointsLabel.text = [NSString stringWithFormat:@"Date:%@ Points:%i", currentDate, 0];
    }
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
    if([[[JWCTaskManager sharedManager] getStatsDictionary] count] > 1) {
        return [[[JWCTaskManager sharedManager] getStatsDictionary] count];
    } else {
        return 4;
    }
}

- (float)valueForIndex:(NSInteger)index
{
    _datesAndPoints = [[JWCTaskManager sharedManager] getStatsDictionary];
    _dateSort = [[NSSortDescriptor alloc] initWithKey:@"description" ascending:YES];
    _datesArray = [[_datesAndPoints allKeys] sortedArrayUsingDescriptors:@[_dateSort]];
    
    if ([_datesArray count] > index) {
        NSNumber *points = (NSNumber *)[_datesAndPoints objectForKey:_datesArray[index]];
        return points.floatValue;
    } else {
        return 0;
    }
}

- (void)didTouchGraphWithClosestIndex:(int)index
{
    
    if ([_datesAndPoints count] > index) {
        NSNumber *pointForDate = (NSNumber *)[_datesAndPoints objectForKey:_datesArray[index]];
        _pointsLabel.text = [NSString stringWithFormat:@"Date:%@ Points:%li",(NSString *)_datesArray[index], (long)pointForDate.integerValue];
    } else {
        _pointsLabel.text = [NSString stringWithFormat:@"Date:\nPoints:"];
    }
}

@end
