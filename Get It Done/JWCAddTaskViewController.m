//
//  JWCAddTaskViewController.m
//  Get It Done
//
//  Created by Jeff Schwab on 1/30/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCAddTaskViewController.h"
#import "JWCAddSubtaskCollectionViewFooter.h"
#import "JWCAddTaskCollectionViewHeader.h"
#import "JWCTaskDescriptionCollectionViewCell.h"
#import "JWCCollectionViewCellTitlePoints.h"
#import "JWCAddTaskCollectionViewDataSource.h"

@interface JWCAddTaskViewController ()

@end

@implementation JWCAddTaskViewController

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
    
    // Register collection view supplementary views
    [self.collectionViewAddTask registerClass:[JWCAddTaskCollectionViewHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:REUSE_TASK_INFO_HEADER];
     [self.collectionViewAddTask registerClass:[JWCAddSubtaskCollectionViewFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:REUSE_ADD_SUBTASK_FOOTER];
    // Register collection view cells
    [self.collectionViewAddTask registerClass:[JWCCollectionViewCellTitlePoints class] forCellWithReuseIdentifier:REUSE_TITLE_POINTS];
    [self.collectionViewAddTask registerClass:[JWCTaskDescriptionCollectionViewCell class] forCellWithReuseIdentifier:REUSE_DESCRIPTION];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressedAddSubtask:(id)sender
{
    
}

@end
