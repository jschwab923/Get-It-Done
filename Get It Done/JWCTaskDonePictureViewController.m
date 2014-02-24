//
//  JWCTaskDonePictureViewController.m
//  Get It Done
//
//  Created by Jeff Schwab on 2/9/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCTaskDonePictureViewController.h"
#import "JWCTaskManager.h"
#import "KGModal.h"
#import "JWCMessageController.h"
@import AssetsLibrary;

@interface JWCTaskDonePictureViewController ()
<UIImagePickerControllerDelegate, UINavigationControllerDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate>
{
    UIImagePickerController *_imagePicker;
    MFMessageComposeViewController *_messageViewController;
    MFMailComposeViewController *_mailComposeViewController;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageViewProofPicture;
@property (weak, nonatomic) IBOutlet UIButton *buttonCamera;
@property (weak, nonatomic) IBOutlet UIButton *buttonPhotoLibrary;
@property (weak, nonatomic) IBOutlet UIButton *buttonSubmitProof;

@property (nonatomic) JWCMessageController *messageController;
@property (nonatomic) BOOL proofSent;

@end

@implementation JWCTaskDonePictureViewController

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
    
    self.imageViewProofPicture.layer.cornerRadius = 10;
    self.imageViewProofPicture.layer.masksToBounds = YES;
    self.imageViewProofPicture.contentMode = UIViewContentModeScaleAspectFill;
    
    self.buttonSubmitProof.enabled = NO;
    
    UIAlertView *photoOptionsAlertView;
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        photoOptionsAlertView = [[UIAlertView alloc] initWithTitle:@"Photo Options" message:@"No camera available" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        self.buttonCamera.enabled = NO;
        [self.buttonCamera setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        // If no camera check for photo library access
        if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied ||
            [ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusRestricted) {
            self.buttonPhotoLibrary.enabled = NO;
            photoOptionsAlertView = [[UIAlertView alloc] initWithTitle:@"Photo Options" message:@"No photo options available" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        }
        [photoOptionsAlertView show];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)pressedCamera:(id)sender
{
    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.allowsEditing = YES;
    _imagePicker.delegate = self;
    _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:_imagePicker animated:YES completion:nil];
}

- (IBAction)pressedPhotoLibrary:(id)sender
{
    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.allowsEditing = YES;
    _imagePicker.delegate = self;
    _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied ||
        [ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusRestricted) {
        self.buttonPhotoLibrary.enabled = NO;
    } else {
        [self presentViewController:_imagePicker animated:YES completion:nil];
    }
}

- (IBAction)pressedSubmitProof:(id)sender
{
    if (self.proofSent) {
        [[JWCTaskManager sharedManager] currentTaskDone];
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    } else if ([JWCTaskManager sharedManager].currentTask.proofImage) {
        if ([JWCTaskManager sharedManager].currentTask.partner.name != nil) {
            [self sendInfoToPartner];
        } else {
            [[JWCTaskManager sharedManager] currentTaskDone];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } else {
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        messageLabel.font = DEFAULT_FONT;
        messageLabel.textColor = DEFAULT_TEXT_COLOR;
        messageLabel.numberOfLines = 0;
        messageLabel.text = @"You've got to prove you got it done first!";
        messageLabel.backgroundColor = [UIColor clearColor];
        [[KGModal sharedInstance] showWithContentView:messageLabel];
    }
}

#pragma mark - UIImagePickerDelegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (info[UIImagePickerControllerEditedImage]) {
        UIImage *editedImageData = info[UIImagePickerControllerEditedImage];
        
        NSData *compressedImage = UIImageJPEGRepresentation(editedImageData, .80);
        UIImage *image = [UIImage imageWithData:compressedImage];
        
        [JWCTaskManager sharedManager].currentTask.proofImage = image;
        self.imageViewProofPicture.image = [UIImage imageWithData:UIImagePNGRepresentation(image)];
        [_imagePicker dismissViewControllerAnimated:YES completion:nil];
        self.buttonSubmitProof.enabled = YES;
    } else if (info[UIImagePickerControllerOriginalImage]) {
        UIImage *originalImageData = info[UIImagePickerControllerEditedImage];
        
        NSData *compressedOriginalImage = UIImageJPEGRepresentation(originalImageData, .80);
        UIImage *image = [UIImage imageWithData:compressedOriginalImage];
        
        self.imageViewProofPicture.image = [UIImage imageWithData:UIImagePNGRepresentation(image)];
        [_imagePicker dismissViewControllerAnimated:YES completion:nil];
        self.buttonSubmitProof.enabled = YES;
    } else {
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 100)];
        messageLabel.font = DEFAULT_FONT;
        messageLabel.textColor = DEFAULT_TEXT_COLOR;
        messageLabel.numberOfLines = 0;
        messageLabel.text = @"Hmm, did you select a picture? Try again";
        messageLabel.backgroundColor = [UIColor clearColor];
        [[KGModal sharedInstance] showWithContentView:messageLabel];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [_imagePicker dismissViewControllerAnimated:YES completion:nil];
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
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            self.proofSent = YES;
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [_mailComposeViewController.presentingViewController dismissViewControllerAnimated:YES completion:^{
        [self pressedSubmitProof:nil];
    }];
}
@end
