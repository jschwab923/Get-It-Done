//
//  JWCCollectionViewDataSource.m
//  Get It Done
//
//  Created by Jeff Schwab on 1/31/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCSoonCollectionViewDataSource.h"
#import "JWCSoonCollectionViewCell.h"
#import "JWCSoonCollectionViewHeader.h"
#import "JWCTaskManager.h"
#import "JWCSubtask.h"
#import "KGModal.h"
#import "JWCViewLine.h"

@interface JWCSoonCollectionViewDataSource ()
{
    JWCSoonCollectionViewHeader *_currentHeader;
}
@end

@implementation JWCSoonCollectionViewDataSource

- (id)init
{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subtaskDone:) name:NOTIFICATION_SUBTASK_DONE object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[[JWCTaskManager sharedManager] currentTask].subTasks count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JWCSoonCollectionViewCell *subTaskCell = (JWCSoonCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"SubtaskCell" forIndexPath:indexPath];
    JWCViewLine *underline = [[JWCViewLine alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(subTaskCell.frame)-1, CGRectGetWidth(subTaskCell.frame), 1)];
    
    // Setup task done gesture recognier
    UISwipeGestureRecognizer *sideSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:collectionView.delegate action:@selector(collectionViewCellSwiped:)];
    [sideSwipeGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [subTaskCell addGestureRecognizer:sideSwipeGestureRecognizer];
    
    // Default properties
    if (subTaskCell.underLine) {
        [subTaskCell.underLine removeFromSuperview];
    }
    
    subTaskCell.underLine = underline;
    [subTaskCell addSubview:underline];
    
    // Properties based on current task
    JWCTask *currentTask = [[JWCTaskManager sharedManager] currentTask];
    NSMutableArray *subTasks = currentTask.subTasks;
    JWCSubtask *currentSubtask = (JWCSubtask *)subTasks[indexPath.row];
    
    subTaskCell.subTaskTextView.text = currentSubtask.subTaskDescription;
    
    subTaskCell.buttonSubtaskDone.selected = currentSubtask.done;
    
    subTaskCell.subTaskTextView.font = DEFAULT_FONT;
    subTaskCell.subTaskTextView.textColor = DEFAULT_TEXT_COLOR;
    //TODO: Display subtask percent
    return subTaskCell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *supplementaryElement;
    if (kind == UICollectionElementKindSectionHeader) {
    
        JWCSoonCollectionViewHeader *headerCell = (JWCSoonCollectionViewHeader *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderCell" forIndexPath:indexPath];
        
        UITapGestureRecognizer *tapGestureHeaderCell = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedHeader:)];
        [headerCell addGestureRecognizer:tapGestureHeaderCell];
        
        _currentHeader = headerCell;
        
        //TODO: Customize header cell based on current task
        // Properties based on current task
        headerCell.taskDescriptionTextView.text = [[JWCTaskManager sharedManager] currentTask].title;
        headerCell.taskDescriptionTextView.font = DEFAULT_FONT;
        headerCell.taskDescriptionTextView.textColor = DEFAULT_TEXT_COLOR;
        
        supplementaryElement = headerCell;
    }
    return supplementaryElement;
}

#pragma mark - Notification Center Methods
- (void)subtaskDone:(id)sender
{
    NSInteger subtasksDone = [[JWCTaskManager sharedManager].currentTask numberOfSubtasksDone];
    NSInteger numberOfTimesSubtasksChecked = [[JWCTaskManager sharedManager].currentTask numberOfTimesSubtasksChecked].integerValue;
    
    if (subtasksDone >= numberOfTimesSubtasksChecked - 4) {
        if (subtasksDone == [[JWCTaskManager sharedManager].currentTask.subTasks count]) {
            _currentHeader.imageViewSmiley.image = [UIImage imageNamed:@"Laughing"];
        } else if (subtasksDone > [[JWCTaskManager sharedManager].currentTask.subTasks count]/2){
            _currentHeader.imageViewSmiley.image = [UIImage imageNamed:@"Happy"];
        } else if (subtasksDone > [[JWCTaskManager sharedManager].currentTask.subTasks count]/3) {
            _currentHeader.imageViewSmiley.image = [UIImage imageNamed:@"Joyful"];
        }
    } else {
        if (numberOfTimesSubtasksChecked > subtasksDone*3) {
            _currentHeader.imageViewSmiley.image = [UIImage imageNamed:@"Bitter"];
        } else if (numberOfTimesSubtasksChecked > subtasksDone*2) {
            _currentHeader.imageViewSmiley.image = [UIImage imageNamed:@"Angry"];
        }
        if (subtasksDone == [[JWCTaskManager sharedManager].currentTask.subTasks count]) {
            _currentHeader.imageViewSmiley.image = [UIImage imageNamed:@"Happy"];
        }
    }
    [_currentHeader.imageViewSmiley setNeedsDisplay];
}

#pragma mark - Gesture Recognizer Methods
- (void)tappedHeader:(UITapGestureRecognizer *)tapGesture
{
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:18];
    CGSize textSize = CGSizeMake(225.0, MAXFLOAT);
    NSString *currentTaskDescription = [JWCTaskManager sharedManager].currentTask.taskDescription;

    CGRect boundingRect = [currentTaskDescription boundingRectWithSize:textSize
                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                           attributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil]
                                                              context:nil];
        
    CGSize roundedSize = CGSizeMake(225, ceil(boundingRect.size.height)+20);
    
    UILabel *detailsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, roundedSize.width, roundedSize.height)];
    
    detailsLabel.numberOfLines = 0;
    detailsLabel.font = DEFAULT_FONT;
    detailsLabel.textColor = [UIColor whiteColor];
    
    detailsLabel.text = currentTaskDescription;
    
    [[KGModal sharedInstance] showWithContentView:detailsLabel];
}

@end
