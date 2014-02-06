//
//  JWCAddTaskViewController.m
//  Get It Done
//
//  Created by Jeff Schwab on 1/30/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCTask.h"
#import "JWCTaskManager.h"

#import "JWCAddTaskViewController.h"
#import "JWCAddSubtaskCollectionViewFooter.h"
#import "JWCCollectionViewHeaderAddTask.h"
#import "JWCTaskDescriptionCollectionViewCell.h"
#import "JWCCollectionViewCellTitlePoints.h"
#import "JWCAddTaskCollectionViewDataSource.h"
#import "JWCCollectionViewCellProof.h"
#import "JWCCollectionViewFooterPartner.h"

@interface JWCAddTaskViewController ()

@end

@implementation JWCAddTaskViewController

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
    
    // Setup tap recognizer for dismissing keyboard
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self 
action:@selector(tappedCollectionView:)];
    
    [self.collectionViewAddTask addGestureRecognizer:tapGesture];
    
    // Register collection view supplementary views
    [self.collectionViewAddTask registerClass:[JWCCollectionViewHeaderAddTask class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:REUSE_TASK_INFO_HEADER];
     [self.collectionViewAddTask registerClass:[JWCAddSubtaskCollectionViewFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:REUSE_ADD_SUBTASK_FOOTER];
    [self.collectionViewAddTask registerClass:[JWCCollectionViewFooterPartner class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:REUSE_PARTNER_FOOTER];
    
    // Register collection view cells
    [self.collectionViewAddTask registerClass:[JWCCollectionViewCellTitlePoints class] forCellWithReuseIdentifier:REUSE_TITLE_POINTS];
    [self.collectionViewAddTask registerClass:[JWCTaskDescriptionCollectionViewCell class] forCellWithReuseIdentifier:REUSE_DESCRIPTION];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)pressedAddButton:(UIBarButtonItem *)sender
{

}

#pragma mark - Gesture Recognizer Methods
- (void)tappedCollectionView:(UIGestureRecognizer *)tapGesture
{
    NSArray *indexPathsForVisibleItems = [self.collectionViewAddTask indexPathsForVisibleItems];
    for (NSIndexPath *currentIndexPath in indexPathsForVisibleItems) {
        UICollectionViewCell *currentCell = [self.collectionViewAddTask cellForItemAtIndexPath:currentIndexPath];
        for (UIView *subview in currentCell.subviews) {
            if ([subview isKindOfClass:[UITextField class]] ||
                [subview isKindOfClass:[UITextView class]]) {
                [subview resignFirstResponder];
            }
        }
    }
}

@end
