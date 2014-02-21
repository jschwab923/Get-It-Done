//
//  JWCCollectionViewDataSourceProofQuestions.m
//  Get It Done
//
//  Created by Jeff Schwab on 2/10/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCCollectionViewDataSourceProofQuestions.h"
#import "JWCCollectionViewCellAnswerProofQuestions.h"
#import "JWCTaskManager.h"

@implementation JWCCollectionViewDataSourceProofQuestions

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JWCCollectionViewCellAnswerProofQuestions *currentCell = (JWCCollectionViewCellAnswerProofQuestions *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ProofAnswerQuestionsCell" forIndexPath:indexPath];
    JWCTask *currentTask = [JWCTaskManager sharedManager].currentTask;
    
    if (currentTask.proofQuestions > 0) {
        switch (indexPath.row) {
            case 0:
                currentCell.labelQuestion.text = [currentTask.proofQuestions firstObject];
                break;
            case 1:
            {
                if ([currentTask.proofQuestions count] > 1) {
                    currentCell.labelQuestion.text = currentTask.proofQuestions[1];
                }
                break;
            }
            case 2:
            {
                if ([currentTask.proofQuestions count] > 2) {
                    currentCell.labelQuestion.text = currentTask.proofQuestions[2];
                }
                break;
            }
            default:
                break;
        }
    } else {
        currentCell.labelQuestion.text = [NSString stringWithFormat:@"Questions #%li", (long)indexPath.row];
    }
    return currentCell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

@end
