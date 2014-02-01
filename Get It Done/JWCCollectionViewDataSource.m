//
//  JWCCollectionViewDataSource.m
//  Get It Done
//
//  Created by Jeff Schwab on 1/31/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCCollectionViewDataSource.h"
#import "JWCCollectionViewCell.h"
#import "JWCCollectionViewHeader.h"
#import "UIColor+GetItDoneColors.h"
#import "JWCTaskManager.h"

@interface JWCCollectionViewDataSource ()

@end

@implementation JWCCollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[[JWCTaskManager sharedManager] currentTask].subTasks count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JWCCollectionViewCell *subTaskCell = (JWCCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"SubtaskCell" forIndexPath:indexPath];
    
    //TODO: Customize cell based on current task
    // Properties based on current task
    JWCTask *currentTask = [[JWCTaskManager sharedManager] currentTask];
    NSMutableArray *subTasks = currentTask.subTasks;
    
    subTaskCell.subTaskTextView.text = [subTasks objectAtIndex:indexPath.row];;
    return subTaskCell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *supplementaryElement;
    if (kind == UICollectionElementKindSectionHeader) {
        JWCCollectionViewHeader *headerCell = (JWCCollectionViewHeader *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderCell" forIndexPath:indexPath];
        
        // Default properties
        headerCell.taskDescriptionTextView.textColor = [UIColor darkBlueColor];
        
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
 
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:20];
    CGSize textSize = CGSizeMake(225.0, MAXFLOAT);
    
    JWCTask *currentTask = [[JWCTaskManager sharedManager] currentTask];
    NSString *currentSubTaskString = [currentTask.subTasks objectAtIndex:indexPath.row];
    
    CGRect boundingRect = [currentSubTaskString boundingRectWithSize:textSize
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil]
                                                   context:nil];
    CGSize roundedSize = CGSizeMake(120, ceil(boundingRect.size.height));
    
    return roundedSize;
}

@end
