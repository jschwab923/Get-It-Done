//
//  JWCTaskDoneQuestionsViewController.m
//  Get It Done
//
//  Created by Jeff Schwab on 2/9/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCTaskDoneQuestionsViewController.h"
#import "JWCCollectionViewCellAnswerProofQuestions.h"
#import "JWCTaskManager.h"

@interface JWCTaskDoneQuestionsViewController ()
<UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewQuestionAnswers;

@end

@implementation JWCTaskDoneQuestionsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (CGRectGetHeight([UIScreen mainScreen].bounds) == 568) {
        self.imageViewBackground.image = [UIImage imageNamed:PORTRAIT_IMAGE];
    } else {
        self.imageViewBackground.image = [UIImage imageNamed:PORTRAIT_IMAGE4];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressedSubmitProof:(id)sender
{
    NSArray *visibleIndexPaths = [self.collectionViewQuestionAnswers indexPathsForVisibleItems];
    
    for (NSIndexPath *indexPath in visibleIndexPaths) {
        JWCCollectionViewCellAnswerProofQuestions *currentCell = (JWCCollectionViewCellAnswerProofQuestions *)[self.collectionViewQuestionAnswers cellForItemAtIndexPath:indexPath];
        if (indexPath.row > [[JWCTaskManager sharedManager].currentTask.proofQuestionAnswers count]) {
            [[JWCTaskManager sharedManager].currentTask.proofQuestionAnswers addObject:currentCell.textViewAnswer.text];
        }
    }
    
    [[JWCTaskManager sharedManager] currentTaskDone];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UICollectionViewDelegate Methods
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CGRectGetWidth(collectionView.frame), 100);
}



@end
