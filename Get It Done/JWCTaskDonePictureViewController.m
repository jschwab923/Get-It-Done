//
//  JWCTaskDonePictureViewController.m
//  Get It Done
//
//  Created by Jeff Schwab on 2/9/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCTaskDonePictureViewController.h"
#import "JWCTaskManager.h"
@import AssetsLibrary;

@interface JWCTaskDonePictureViewController ()
<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIImagePickerController *_imagePicker;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageViewProofPicture;
@property (weak, nonatomic) IBOutlet UIButton *buttonCamera;
@property (weak, nonatomic) IBOutlet UIButton *buttonPhotoLibrary;
@property (weak, nonatomic) IBOutlet UIButton *buttonSubmitProof;

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
    if (CGRectGetHeight([UIScreen mainScreen].bounds) == 568) {
        self.imageViewBackground.image = [UIImage imageNamed:PORTRAIT_IMAGE];
    } else {
        self.imageViewBackground.image = [UIImage imageNamed:PORTRAIT_IMAGE4];
    }
    
    self.imageViewProofPicture.layer.cornerRadius = 10;
    self.imageViewProofPicture.layer.masksToBounds = YES;
    self.imageViewProofPicture.contentMode = UIViewContentModeScaleAspectFill;
    
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
    
    [self presentViewController:_imagePicker animated:YES completion:nil];
}

- (IBAction)pressedSubmitProof:(id)sender
{
    [[JWCTaskManager sharedManager] currentTaskDone];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIImagePickerDelegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *editedImageData = info[UIImagePickerControllerEditedImage];
    
    NSData *compressedImage = UIImageJPEGRepresentation(editedImageData, .80);
    UIImage *image = [UIImage imageWithData:compressedImage];
    
    [JWCTaskManager sharedManager].currentTask.proofImage = image;
    
    self.imageViewProofPicture.image = [UIImage imageWithData:UIImagePNGRepresentation(image)];
    [self dismissViewControllerAnimated:_imagePicker completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:_imagePicker completion:nil];
}

@end
