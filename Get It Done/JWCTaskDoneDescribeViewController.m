//
//  JWCTaskDoneViewController.m
//  Get It Done
//
//  Created by Jeff Schwab on 1/31/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCTaskDoneDescribeViewController.h"
#import "JWCTaskManager.h"
#import "JWCMessageController.h"
#import "KGModal.h"

@interface JWCTaskDoneDescribeViewController () <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>

{
    MFMessageComposeViewController *_messageViewController;
    MFMailComposeViewController *_mailComposeViewController;
}

@property (weak, nonatomic) IBOutlet UITextView *textViewDescription;
@property (nonatomic) BOOL proofSent;

@end

@implementation JWCTaskDoneDescribeViewController

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
    
    self.proofSent = NO;
	
    self.view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [self.view addGestureRecognizer:tapRecognizer];
    
    self.textViewDescription.layer.cornerRadius = 5;
    self.textViewDescription.alpha = .8;
    
    // Setup toolbar for keyboard dismissal
    UIToolbar *doneToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    doneToolbar.barStyle = UIBarStyleBlackTranslucent;
    doneToolbar.items = [NSArray arrayWithObjects:
                         [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyboardWithApplyButton)],
                         nil];
    [doneToolbar sizeToFit];
    
    self.textViewDescription.inputAccessoryView = doneToolbar;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)pressedSubmitProofButton:(id)sender
{
    if (self.proofSent) {
        [[JWCTaskManager sharedManager] currentTaskDone];
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    } else if ([self.textViewDescription.text isEqualToString:@""] ||
        [self.textViewDescription.text isEqualToString:@" "]) {
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 100)];
        messageLabel.font = DEFAULT_FONT;
        messageLabel.textColor = DEFAULT_TEXT_COLOR;
        messageLabel.text = @"You've got to describe what you got done!";
        messageLabel.numberOfLines = 0;
        messageLabel.backgroundColor = [UIColor clearColor];
        [[KGModal sharedInstance] showWithContentView:messageLabel];
    } else if ([JWCTaskManager sharedManager].currentTask.partner.name != nil){
        [JWCTaskManager sharedManager].currentTask.proofDescribe = self.textViewDescription.text;
        [self sendInfoToPartner];
    } else { // No task partner
        [JWCTaskManager sharedManager].currentTask.proofDescribe = self.textViewDescription.text;
        [[JWCTaskManager sharedManager] currentTaskDone];
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Gesture Recognizer Methods
- (void)dismissKeyboard:(UITapGestureRecognizer *)tapGesture
{
    [self.textViewDescription endEditing:YES];
}

-(void)dismissKeyboardWithApplyButton
{
    [self.textViewDescription endEditing:YES];
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
    NSArray *emails = (NSArray *)[JWCTaskManager sharedManager].currentTask.partner.emails;
    [_mailComposeViewController setToRecipients:emails];
    
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
            [self pressedSubmitProofButton:nil];
        }];
    }
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
        {
            [self dismissViewControllerAnimated:YES completion:nil];
            
            UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 100)];
            messageLabel.font = DEFAULT_FONT;
            messageLabel.textColor = DEFAULT_TEXT_COLOR;
            messageLabel.numberOfLines = 0;
            messageLabel.text = @"Can't mark the task as done until you send your proof!";
            messageLabel.backgroundColor = [UIColor clearColor];
            [[KGModal sharedInstance] showWithContentView:messageLabel];
            break;
        }
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            self.proofSent = YES;
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
        {
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            
            UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 100)];
            messageLabel.font = DEFAULT_FONT;
            messageLabel.textColor = DEFAULT_TEXT_COLOR;
            messageLabel.numberOfLines = 0;
            messageLabel.text = @"Something went wrong sending your message. Try again.";
            messageLabel.backgroundColor = [UIColor clearColor];
            [[KGModal sharedInstance] showWithContentView:messageLabel];
            break;
        }
        default:
            break;
    }
    
    // Close the Mail Interface
    [_mailComposeViewController.presentingViewController dismissViewControllerAnimated:YES completion:^{
        [self pressedSubmitProofButton:nil];
    }];
}

@end
