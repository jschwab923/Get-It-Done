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
#import "JWCMessageController.h"
#import "KGModal.h"

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
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCollectionView:)];
    [self.collectionViewQuestionAnswers addGestureRecognizer:tapGesture];
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
        if (![currentCell.labelQuestion.text isEqualToString:@""] ||
            ![currentCell.labelQuestion.text isEqualToString:@" "]) {
            if (indexPath.row >= [[JWCTaskManager sharedManager].currentTask.proofQuestionAnswers count])
            {
                [[JWCTaskManager sharedManager].currentTask.proofQuestionAnswers addObject:currentCell.textViewAnswer.text];
            } else {
                [[JWCTaskManager sharedManager].currentTask.proofQuestionAnswers replaceObjectAtIndex:indexPath.row withObject:currentCell.textViewAnswer.text];
            }
        }
    }
    
    if ([[JWCTaskManager sharedManager].currentTask.proofQuestionAnswers count] != [[JWCTaskManager sharedManager].currentTask.proofQuestions count]) {
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 100)];
        messageLabel.font = DEFAULT_FONT;
        messageLabel.textColor = DEFAULT_TEXT_COLOR;
        messageLabel.numberOfLines = 0;
        messageLabel.text = @"Looks like you didn't answer one of the questions!";
        messageLabel.backgroundColor = [UIColor clearColor];
        [[KGModal sharedInstance] showWithContentView:messageLabel];
    } else {
        
        
        [[JWCTaskManager sharedManager] currentTaskDone];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UICollectionViewDelegate Methods
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CGRectGetWidth(collectionView.frame), 100);
}

#pragma mark - Gesture Recognizer Methods
- (void)tappedCollectionView:(UIGestureRecognizer *)tapGesture
{
    NSArray *indexPathsForVisibleItems = [self.collectionViewQuestionAnswers indexPathsForVisibleItems];
    for (NSIndexPath *currentIndexPath in indexPathsForVisibleItems) {
        UICollectionViewCell *currentCell = [self.collectionViewQuestionAnswers cellForItemAtIndexPath:currentIndexPath];
        for (UIView *subview in currentCell.subviews) {
            [subview endEditing:YES];
            for (UIView *subSubView in subview.subviews) {
                [subview endEditing:YES];
            }
        }
    }
}

#pragma mark - Convenience Methods
 
@end
