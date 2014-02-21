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
#import "JWCViewLine.h"

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
    JWCViewLine *underline = [[JWCViewLine alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(subTaskCell.frame)-1, CGRectGetWidth(subTaskCell.frame), 1)];
    
    // Default properties
    [subTaskCell addSubview:underline];
    
    // Properties based on current task
    JWCTask *currentTask = [[JWCTaskManager sharedManager] currentTask];
    NSMutableArray *subTasks = currentTask.subTasks;
    JWCSubtask *currentSubtask = (JWCSubtask *)subTasks[indexPath.row];
    
    subTaskCell.buttonSubtaskDone.selected = currentSubtask.done;
    
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
 
@end
