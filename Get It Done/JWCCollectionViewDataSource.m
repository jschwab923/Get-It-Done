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

@implementation JWCCollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JWCCollectionViewCell *subTaskCell = (JWCCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"SubtaskCell" forIndexPath:indexPath];
    
    // Default properties
    subTaskCell.subTaskTextView.textColor = [UIColor darkBlueColor];
    
    //TODO: Customize cell based on current task
    // Properties based on current task
    subTaskCell.subTaskTextView.text = @"Work on design and now see if this thing gets bigger";
    
    CGFloat textViewContentHeight = subTaskCell.subTaskTextView.contentSize.height;
    CGFloat cellHeight = CGRectGetHeight(subTaskCell.frame);
    if (textViewContentHeight > cellHeight) {
        subTaskCell.frame = CGRectMake(0, 0, CGRectGetWidth(subTaskCell.frame), subTaskCell.subTaskTextView.contentSize.height);
    }
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
        headerCell.taskDescriptionTextView.text = @"Work on Code Fellows app and now more of this";
        
        CGFloat textViewContentHeight = headerCell.taskDescriptionTextView.contentSize.height;
        CGFloat cellHeight = CGRectGetHeight(headerCell.frame);
        if (textViewContentHeight > cellHeight) {
            headerCell.frame = CGRectMake(0, 0, CGRectGetWidth(headerCell.frame), headerCell.taskDescriptionTextView.contentSize.height);
        }
        
        supplementaryElement = headerCell;
    }
    return supplementaryElement;
}

@end
