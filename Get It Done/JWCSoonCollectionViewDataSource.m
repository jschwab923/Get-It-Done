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

@interface JWCSoonCollectionViewDataSource ()

@end

@implementation JWCSoonCollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[[JWCTaskManager sharedManager] currentTask].subTasks count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JWCSoonCollectionViewCell *subTaskCell = (JWCSoonCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"SubtaskCell" forIndexPath:indexPath];
    
    // Properties based on current task
    JWCTask *currentTask = [[JWCTaskManager sharedManager] currentTask];
    NSMutableArray *subTasks = currentTask.subTasks;
    JWCSubtask *currentSubtask = (JWCSubtask *)subTasks[indexPath.row];
    
    subTaskCell.subTaskTextView.text = currentSubtask.subTaskDescription;
    //TODO: Display subtask percent
    return subTaskCell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *supplementaryElement;
    if (kind == UICollectionElementKindSectionHeader) {
        JWCSoonCollectionViewHeader *headerCell = (JWCSoonCollectionViewHeader *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderCell" forIndexPath:indexPath];
        
        // Default properties

        
        //TODO: Customize header cell based on current task
        // Properties based on current task
        headerCell.taskDescriptionTextView.text = [[JWCTaskManager sharedManager] currentTask].title;
        
        supplementaryElement = headerCell;
    }
    return supplementaryElement;
}

// TODO: Get cells resizing based on text view content
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    // Get height of text
//    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:20];
//    CGSize textSize = CGSizeMake(225.0, MAXFLOAT);
//    
//    JWCTask *currentTask = [[JWCTaskManager sharedManager] currentTask];
//    JWCSubtask *currentSubTask = (JWCSubtask *)[currentTask.subTasks objectAtIndex:indexPath.row];
    
//    CGRect boundingRect = [currentSubTask.subTaskDescription boundingRectWithSize:textSize
//                                                   options:NSStringDrawingUsesLineFragmentOrigin
//                                                attributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil]
//                                                   context:nil];
    
    CGFloat heightForOrientation;
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft ||
        [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft)
    {
        heightForOrientation = 40;
    } else {
        heightForOrientation = 40;
    }
    CGSize roundedSize = CGSizeMake(CGRectGetWidth(collectionView.frame)-15, heightForOrientation);
    
    return roundedSize;
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    [self.delegate scrollViewDidScroll:scrollView];
//}

- (void)    collectionView:(UICollectionView *)collectionView
  didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
