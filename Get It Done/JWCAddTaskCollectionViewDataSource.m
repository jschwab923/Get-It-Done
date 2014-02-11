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
#import "JWCCollectionViewFooterAddPartner.h"
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
        {
            switch (indexPath.row) {
                case 0:
                {
                    currentCell = [collectionView dequeueReusableCellWithReuseIdentifier:REUSE_TITLE_POINTS forIndexPath:indexPath];
                    JWCCollectionViewCellTitlePoints *tempCell = (JWCCollectionViewCellTitlePoints *)currentCell;
                    tempCell.title.delegate = self;
                    tempCell.title.backgroundColor = [UIColor colorWithWhite:1.0 alpha:.6];
                    tempCell.title.text = [JWCTaskManager sharedManager].pendingTask.title ?: @"";
                    tempCell.points.delegate = self;
                    tempCell.points.backgroundColor = [UIColor colorWithWhite:1.0 alpha:.6];
                    NSInteger pendingPoints = [JWCTaskManager sharedManager].pendingTask.points.integerValue;
                    if (pendingPoints > 0) {
                        tempCell.points.text = [NSString stringWithFormat:@"%li", (long)pendingPoints];
                    }
                    
                    break;
                }
                case 1:
                {
                    currentCell = [collectionView dequeueReusableCellWithReuseIdentifier:REUSE_DESCRIPTION forIndexPath:indexPath];
                    JWCTaskDescriptionCollectionViewCell *tempCell = (JWCTaskDescriptionCollectionViewCell *)currentCell;
                    tempCell.textViewDescription.delegate = self;
                    tempCell.textViewDescription.backgroundColor = [UIColor colorWithWhite:1.0 alpha:.6];
                    tempCell.textViewDescription.text = [JWCTaskManager sharedManager].pendingTask.taskDescription ?: @"Describe what needs to get done";
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 1:
        {
            currentCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProofCell" forIndexPath:indexPath];
            JWCCollectionViewCellProof *tempCell = (JWCCollectionViewCellProof *)currentCell;
            if ([[JWCTaskManager sharedManager].pendingTask.proofType isEqualToString: PROOF_TYPE_PICTURE]) {
                [tempCell.pickerViewProof selectRow:0 inComponent:0 animated:YES];
            } else if ([[JWCTaskManager sharedManager].pendingTask.proofType isEqualToString:PROOF_TYPE_DESCRIBE]) {
                [tempCell.pickerViewProof selectRow:1 inComponent:0 animated:YES];
            } else if ([[JWCTaskManager sharedManager].pendingTask.proofType isEqualToString:PROOF_TYPE_QUESTIONS]) {
                [tempCell.pickerViewProof selectRow:2 inComponent:0 animated:YES];
            }
            break;
        }
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
            {
                header.headerLabel.text = @"What needs to get done?";
                JWCViewLine *titleUnderline = [[JWCViewLine alloc] initWithFrame:CGRectMake(5, CGRectGetHeight(header.frame)*.9, CGRectGetWidth(header.headerLabel.frame)*.7, 1)];
                titleUnderline.backgroundColor = [UIColor blackColor];
                [header addSubview:titleUnderline];
                reusableView = header;
                break;
            }
            case 1:
            {
                header.headerLabel.text = @"How will you prove it's done?";
                JWCViewLine *titleUnderline = [[JWCViewLine alloc] initWithFrame:CGRectMake(5, CGRectGetHeight(header.frame)*.9, CGRectGetWidth(header.headerLabel.frame)*.8, 1)];
                titleUnderline.backgroundColor = [UIColor blackColor];
                [header addSubview:titleUnderline];
                reusableView = header;
                break;
            }
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
                reusableView = (JWCCollectionViewFooterAddPartner *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:REUSE_PARTNER_FOOTER forIndexPath:indexPath];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (textView.tag == TAG_DESCRIPTION_TEXTFIELD &&
        [textView.text isEqualToString:@"Describe what needs to get done"]) {
        textView.text = @"";
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
