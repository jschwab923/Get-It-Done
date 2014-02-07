//
//  JWCAddTaskCollectionViewDataSource.m
//  Get It Done
//
//  Created by Jeff Schwab on 2/4/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCTask.h"
#import "JWCTaskManager.h"

#import "JWCAddTaskCollectionViewDataSource.h"
#import "JWCAddSubtaskCollectionViewFooter.h"
#import "JWCCollectionViewHeaderAddTask.h"
#import "JWCTaskDescriptionCollectionViewCell.h"
#import "JWCCollectionViewCellTitlePoints.h"
#import "JWCCollectionViewCellProof.h"
#import "JWCCollectionViewFooterPartner.h"
#import "JWCViewLine.h"

@interface JWCAddTaskCollectionViewDataSource ()

@end

@implementation JWCAddTaskCollectionViewDataSource

#pragma mark - UICollectionViewDataSource Methods
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
                {
                    currentCell = (JWCCollectionViewCellTitlePoints *)[collectionView dequeueReusableCellWithReuseIdentifier:REUSE_TITLE_POINTS forIndexPath:indexPath];
                    JWCCollectionViewCellTitlePoints *tempCell = (JWCCollectionViewCellTitlePoints *)currentCell;
                    tempCell.title.delegate = self;
                    tempCell.points.delegate = self;
                    break;
                }
                case 1:
                {
                    currentCell = (JWCTaskDescriptionCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:REUSE_DESCRIPTION forIndexPath:indexPath];
                    JWCTaskDescriptionCollectionViewCell *tempCell = (JWCTaskDescriptionCollectionViewCell *)currentCell;
                    tempCell.textViewDescription.delegate = self;
                    break;
                }
                default:
                    break;
            }
            break;
        case 1:
            currentCell = (JWCCollectionViewCellProof *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ProofCell" forIndexPath:indexPath];
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
                reusableView = header;
                break;
            case 1:
                header.headerLabel.text = @"How will you prove it's done?";
                reusableView = header;
                break;
            default:
                break;
        }
    } else if (kind == UICollectionElementKindSectionFooter) {
        switch (indexPath.section) {
            case 0:
            {
                reusableView = (JWCAddSubtaskCollectionViewFooter *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:REUSE_ADD_SUBTASK_FOOTER forIndexPath:indexPath];
            }
                break;
            case 1:
                reusableView = (JWCCollectionViewFooterPartner *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:REUSE_PARTNER_FOOTER forIndexPath:indexPath];
            default:
                break;
        }
    }
    
    return reusableView;
}

#pragma mark - UITextView/Field Delegate Methods
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField.tag == TAG_TITLE_TEXTVIEW) {
        [[JWCTaskManager sharedManager] pendingTask].title = textField.text;
    } else if (textField.tag == TAG_POINTS_TEXTVIEW) {
        [[JWCTaskManager sharedManager] pendingTask].points = [NSNumber numberWithInteger:[textField.text integerValue]];
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if (textView.tag == TAG_DESCRIPTION_TEXTFIELD) {
        [[JWCTaskManager sharedManager] pendingTask].taskDescription = textView.text;
    }
    return YES;
}

@end
