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
<UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate, UITextViewDelegate>

{
    MFMessageComposeViewController *_messageViewController;
    MFMailComposeViewController *_mailComposeViewController;
    
    UITextView *_selectedTextView;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewQuestionAnswers;
@property (nonatomic) BOOL proofSent;

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
    
    self.view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCollectionView:)];
    [self.collectionViewQuestionAnswers addGestureRecognizer:tapGesture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotificationWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotificationDismissed:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressedSubmitProof:(id)sender
{
    NSArray *visibleIndexPaths = [self.collectionViewQuestionAnswers indexPathsForVisibleItems];

    if (self.proofSent) {
        [[JWCTaskManager sharedManager] currentTaskDone];
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    } else {
        for (NSIndexPath *indexPath in visibleIndexPaths) {
            JWCCollectionViewCellAnswerProofQuestions *currentCell = (JWCCollectionViewCellAnswerProofQuestions *)[self.collectionViewQuestionAnswers cellForItemAtIndexPath:indexPath];
            if (![currentCell.textViewAnswer.text isEqualToString:@""] &&
                ![currentCell.textViewAnswer.text isEqualToString:@" "]) {
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
        } else if ([JWCTaskManager sharedManager].currentTask.partner.name != nil) { // All info filled out and ready to send to partner
            [self sendInfoToPartner];
        } else { // No partner for current task
            [[JWCTaskManager sharedManager] currentTaskDone];
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
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
- (void)sendInfoToPartner
{
    UIView *modalView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 100)];
    modalView.backgroundColor = [UIColor clearColor];
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 50)];
    messageLabel.font = DEFAULT_FONT;
    messageLabel.textColor = DEFAULT_TEXT_COLOR;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.numberOfLines = 0;
    messageLabel.text = @"Send info to partner";
    messageLabel.backgroundColor = [UIColor clearColor];
    
    UIButton *sendTextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 55, 50, 50)];
    [sendTextButton setTitle:@"Text" forState:UIControlStateNormal];
    sendTextButton.titleLabel.font = DEFAULT_FONT;
    [sendTextButton setTitleColor:DEFAULT_TEXT_COLOR forState:UIControlStateNormal];
    [sendTextButton addTarget:self action:@selector(sendTextMessage:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *sendEmailButton = [[UIButton alloc] initWithFrame:CGRectMake(60, 55, 50, 50)];
    [sendEmailButton setTitle:@"Email" forState:UIControlStateNormal];
    sendEmailButton.titleLabel.font = DEFAULT_FONT;
    [sendEmailButton setTitleColor:DEFAULT_TEXT_COLOR forState:UIControlStateNormal];
    [sendEmailButton addTarget:self action:@selector(sendEmail:) forControlEvents:UIControlEventTouchUpInside];
    
    [modalView addSubview:messageLabel];
    [modalView addSubview:sendEmailButton];
    [modalView addSubview:sendTextButton];
    
    [[KGModal sharedInstance] showWithContentView:modalView];
}

- (void)sendTextMessage:(id)sender
{
    [[KGModal sharedInstance] hideAnimated:YES];
    
    if(![MFMessageComposeViewController canSendText]) {
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 100)];
        messageLabel.font = DEFAULT_FONT;
        messageLabel.textColor = DEFAULT_TEXT_COLOR;
        messageLabel.numberOfLines = 0;
        messageLabel.text = @"Can't send a text";
        messageLabel.backgroundColor = [UIColor clearColor];
        [[KGModal sharedInstance] showWithContentView:messageLabel];
    } else {
        _messageViewController = [JWCMessageController getTextViewController];
        [_messageViewController setMessageComposeDelegate:self];
        [_messageViewController setBody:[JWCMessageController messageForText]];
        [self presentViewController:_messageViewController animated:YES completion:nil];
    }
}

- (void)sendEmail:(id)sender
{
    [[KGModal sharedInstance] hideAnimated:YES];
    
    _mailComposeViewController = [JWCMessageController getEmailViewController];
    _mailComposeViewController.mailComposeDelegate = self;
    [_mailComposeViewController setSubject:@"Proof that I got my task done!"];
    [_mailComposeViewController setMessageBody:[JWCMessageController messageForEmail] isHTML:NO];
    [_mailComposeViewController setToRecipients:[JWCTaskManager sharedManager].currentTask.partner.emails];
    
    NSData *imageData = UIImagePNGRepresentation([JWCTaskManager sharedManager].currentTask.proofImage);
    [_mailComposeViewController addAttachmentData:imageData mimeType:@"image/png" fileName:@"ProofImage"];
    
    [self presentViewController:_mailComposeViewController animated:YES completion:nil];
}

#pragma mark - MFMessage/Mail Delegate methods
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    if (result == MessageComposeResultFailed) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 100)];
        messageLabel.font = DEFAULT_FONT;
        messageLabel.textColor = DEFAULT_TEXT_COLOR;
        messageLabel.numberOfLines = 0;
        messageLabel.text = @"Something went wrong sending your message. Try again.";
        messageLabel.backgroundColor = [UIColor clearColor];
        [[KGModal sharedInstance] showWithContentView:messageLabel];
    } else if (result == MessageComposeResultCancelled) {
        [self dismissViewControllerAnimated:YES completion:nil];
        
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 100)];
        messageLabel.font = DEFAULT_FONT;
        messageLabel.textColor = DEFAULT_TEXT_COLOR;
        messageLabel.numberOfLines = 0;
        messageLabel.text = @"Can't mark the task as done until you send your proof!";
        messageLabel.backgroundColor = [UIColor clearColor];
        [[KGModal sharedInstance] showWithContentView:messageLabel];
    } else {
        self.proofSent = YES;
        [self dismissViewControllerAnimated:YES completion:^{
            [self pressedSubmitProof:nil];
        }];
    }
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultSent:
            self.proofSent = YES;
            NSLog(@"Mail sent");
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [_mailComposeViewController.presentingViewController dismissViewControllerAnimated:YES completion:^{
        [self pressedSubmitProof:nil];
    }];
}

#pragma mark - NSNotificationCenter Methods
- (void)keyboardNotificationWillShow:(NSNotification *)note
{
    // TODO: GET THIS WORKING PROPERLY
    NSDictionary *userInfo = [note userInfo];
    
    NSValue *keyboardEndValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardEndFrame = keyboardEndValue.CGRectValue;
    
    NSArray *visibleIndexPaths = [_collectionViewQuestionAnswers indexPathsForVisibleItems];
    for (NSIndexPath *indexPath in visibleIndexPaths) {
        JWCCollectionViewCellAnswerProofQuestions *currentCell = (JWCCollectionViewCellAnswerProofQuestions *)[_collectionViewQuestionAnswers cellForItemAtIndexPath:indexPath];
        UITextView *textView = currentCell.textViewAnswer;
        if ([textView isFirstResponder]) {
            CGRect bottomOfSelectedTextField = [currentCell convertRect:textView.frame toView:self.collectionViewQuestionAnswers.superview];
            
            CGFloat keyboardEndHeight = CGRectGetHeight(keyboardEndFrame);
            
            if (CGRectGetMaxY(bottomOfSelectedTextField) >= keyboardEndHeight) {
                if ([UIScreen mainScreen].bounds.size.height == 480) {
                    CGFloat _keyboardOffset = CGRectGetMaxY(bottomOfSelectedTextField) - keyboardEndHeight;
                    [self.collectionViewQuestionAnswers setContentOffset:CGPointMake(0, _keyboardOffset+20) animated:YES];
                } else {
                    CGFloat _keyboardOffset = CGRectGetMaxY(bottomOfSelectedTextField) - keyboardEndHeight;
                    [self.collectionViewQuestionAnswers setContentOffset:CGPointMake(0, _keyboardOffset) animated:YES];
                }
            }
        }
    }
}

- (void)dismissKeyboardWithApply
{
    if (_selectedTextView) {
        [_selectedTextView endEditing:YES];
    }
}

- (void)keyboardNotificationDismissed:(NSNotification *)note
{
    CGPoint keyboardOffsetOpposite = CGPointMake(0, 0);
    [self.collectionViewQuestionAnswers setContentOffset:keyboardOffsetOpposite animated:YES];
}

#pragma mark - UITextViewDelegate Methods
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    _selectedTextView = textView;
}

@end
