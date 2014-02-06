//
//  JWCAddTaskCollectionViewFooter.m
//  Get It Done
//
//  Created by Jeff Schwab on 2/4/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCAddSubtaskCollectionViewFooter.h"
#import "JWCCollectionViewHeaderAddTask.h"
#import "JWCCollectionViewCellTitlePoints.h"
#import "JWCTaskManager.h"
#import "JWCSubtask.h"
#import "KGModal.h"

@interface JWCAddSubtaskCollectionViewFooter ()
{
    UICollectionView *_subtasksCollectionView;
}
@end

@implementation JWCAddSubtaskCollectionViewFooter

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    UILabel *addSubtaskLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(rect)-130, 0,
                                                                         CGRectGetWidth(rect)/3, CGRectGetHeight(rect))];
    addSubtaskLabel.backgroundColor = [UIColor clearColor];
    addSubtaskLabel.text = @"Add Subtask";
    addSubtaskLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:18];
    [self addSubview:addSubtaskLabel];
    
    UIButton *addSubtaskButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    addSubtaskButton.center = CGPointMake(CGRectGetWidth(rect)-20, CGRectGetHeight(rect)/2);
    
    addSubtaskButton.contentMode = UIViewContentModeScaleToFill;
    [addSubtaskButton setImage:[UIImage imageNamed:@"Add"] forState:UIControlStateNormal];
    addSubtaskButton.backgroundColor = [UIColor clearColor];
    [self addSubview:addSubtaskButton];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedAddSubtask:)];
    //TODO: Add gesture to both label and button
    [addSubtaskButton addGestureRecognizer:tapRecognizer];
}

- (void)tappedAddSubtask:(UITapGestureRecognizer *)tapGesture
{
    UICollectionViewFlowLayout *contactLayout = [[UICollectionViewFlowLayout alloc] init];
    _subtasksCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 275, 300) collectionViewLayout:contactLayout];
    _subtasksCollectionView.backgroundColor = [UIColor clearColor];
    
    _subtasksCollectionView.delegate = self;
    _subtasksCollectionView.dataSource = self;
    
    // Register reusable collection view cells and supplementary views
    [_subtasksCollectionView registerClass:[JWCCollectionViewHeaderAddTask class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:REUSE_TASK_INFO_HEADER];
    [_subtasksCollectionView registerClass:[JWCCollectionViewCellTitlePoints class]
                   forCellWithReuseIdentifier:REUSE_TITLE_POINTS];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCollectionView:)];
    [_subtasksCollectionView addGestureRecognizer:tapGestureRecognizer];
    
    [[KGModal sharedInstance] showWithContentView:_subtasksCollectionView andAnimated:YES];
}

#pragma mark - UICollectionViewDataSource/Delegate methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[[JWCTaskManager sharedManager] pendingTask].subTasks count] + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    JWCCollectionViewCellTitlePoints *currentCell = (JWCCollectionViewCellTitlePoints *)[collectionView dequeueReusableCellWithReuseIdentifier:REUSE_TITLE_POINTS forIndexPath:indexPath];
    
    currentCell.title.placeholder = @"Subtask";
    currentCell.points.placeholder = @"%";
    
    currentCell.title.delegate = self;
    currentCell.points.delegate = self;
    
    if (indexPath.row < [[[JWCTaskManager sharedManager] pendingTask].subTasks count]) {
        JWCSubtask *currentSubtask = (JWCSubtask *)[[JWCTaskManager sharedManager] pendingTask].subTasks[indexPath.row];
        currentCell.title.text = currentSubtask.subTaskDescription;
        currentCell.points.text = [NSString stringWithFormat:@"%i", currentSubtask.percent.intValue];
    }
    return currentCell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *currentView;
    if (kind == UICollectionElementKindSectionHeader) {
        currentView = (JWCCollectionViewHeaderAddTask *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:REUSE_TASK_INFO_HEADER forIndexPath:indexPath];
        JWCCollectionViewHeaderAddTask *tempView = (JWCCollectionViewHeaderAddTask *)currentView;
        tempView.headerLabel.text = @"Description | % of Total";
        tempView.headerLabel.textColor = [UIColor whiteColor];
    }
    return currentView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CGRectGetWidth(collectionView.frame), 50);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(CGRectGetWidth(collectionView.frame), 50);
}

#pragma mark - UITextFieldDelegate Methods
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    NSMutableArray *pendingSubtasks = [[JWCTaskManager sharedManager] pendingTask].subTasks;
    NSArray *visibleIndexPaths = [_subtasksCollectionView indexPathsForVisibleItems];
    for (NSIndexPath *currentIndexPath in visibleIndexPaths) {
        JWCCollectionViewCellTitlePoints *currentCell = (JWCCollectionViewCellTitlePoints *)[_subtasksCollectionView cellForItemAtIndexPath:currentIndexPath];
        //TODO: Verify if it should be < or <=
        if (currentIndexPath.row < [pendingSubtasks count]) {
            JWCSubtask *editedSubtask = (JWCSubtask *)pendingSubtasks[currentIndexPath.row];
            editedSubtask.subTaskDescription = currentCell.title.text;
            editedSubtask.percent = [NSNumber numberWithInt:currentCell.points.text.intValue];
        } else {
            JWCSubtask *newSubtask = [[JWCSubtask alloc] init];
            newSubtask.subTaskDescription = currentCell.title.text;
            newSubtask.percent = [NSNumber numberWithInt:currentCell.points.text.intValue];
            [pendingSubtasks addObject:newSubtask];
        }
    }
    return YES;
}

#pragma mark - Gesture Recognizer Methods
- (void)tappedCollectionView:(UIGestureRecognizer *)tapGesture
{
    NSArray *indexPathsForVisibleItems = [_subtasksCollectionView indexPathsForVisibleItems];
    for (NSIndexPath *currentIndexPath in indexPathsForVisibleItems) {
        UICollectionViewCell *currentCell = [_subtasksCollectionView cellForItemAtIndexPath:currentIndexPath];
        for (UIView *subview in currentCell.subviews) {
            if ([subview isKindOfClass:[UITextField class]] ||
                [subview isKindOfClass:[UITextView class]]) {
                [subview resignFirstResponder];
            }
        }
    }
}

@end
