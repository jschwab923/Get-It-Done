//
//  JWCAddTaskCollectionViewDataSource.m
//  Get It Done
//
//  Created by Jeff Schwab on 2/4/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCAddTaskCollectionViewDataSource.h"
#import "JWCAddSubtaskCollectionViewFooter.h"
#import "JWCCollectionViewHeaderAddTask.h"
#import "JWCTaskDescriptionCollectionViewCell.h"
#import "JWCCollectionViewCellTitlePoints.h"
#import "JWCCollectionViewCellProof.h"
#import "JWCCollectionViewFooterPartner.h"

@implementation JWCAddTaskCollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    UICollectionViewCell *currentCell;
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    currentCell = (JWCCollectionViewCellTitlePoints *)[collectionView dequeueReusableCellWithReuseIdentifier:REUSE_TITLE_POINTS forIndexPath:indexPath];
                    currentCell.backgroundColor = [UIColor blueColor];
                    break;
                case 1:
                    currentCell = (JWCTaskDescriptionCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:REUSE_DESCRIPTION forIndexPath:indexPath];
                    currentCell.backgroundColor = [UIColor blueColor];
                    break;
                default:
                    break;
            }
            break;
        case 1:
            currentCell = (JWCCollectionViewCellProof *)[collectionView dequeueReusableCellWithReuseIdentifier:REUSE_PROOF forIndexPath:indexPath];
            break;
        default:
            break;
    }
    
    return currentCell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView;
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        JWCCollectionViewHeaderAddTask *header = (JWCCollectionViewHeaderAddTask *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:REUSE_TASK_INFO_HEADER forIndexPath:indexPath];
        
        switch (indexPath.section) {
            case 0:
                header.headerLabel.text = @"What needs to get done?";
                //TODO: Remove
                header.backgroundColor = [UIColor blueColor];
                reusableView = header;
                break;
            case 1:
                header.headerLabel.text = @"How will you prove it's done?";
                //TODO: Remove
                header.backgroundColor = [UIColor purpleColor];
                reusableView = header;
                break;
            default:
                break;
        }
    } else if (kind == UICollectionElementKindSectionFooter) {
        switch (indexPath.section) {
            case 0:
                reusableView = (JWCAddSubtaskCollectionViewFooter *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:REUSE_ADD_SUBTASK_FOOTER forIndexPath:indexPath];
                reusableView.backgroundColor = [UIColor blueColor];
                break;
            case 1:
                reusableView = (JWCCollectionViewFooterPartner *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:REUSE_PARTNER_FOOTER forIndexPath:indexPath];
                reusableView.backgroundColor = [UIColor blueColor];
            default:
                break;
        }
    }

    return reusableView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(250, 50);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(250, 50);
}

@end
