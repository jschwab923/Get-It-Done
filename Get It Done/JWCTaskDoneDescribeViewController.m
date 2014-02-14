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

@interface JWCTaskDoneDescribeViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textViewDescription;

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
	if (CGRectGetHeight([UIScreen mainScreen].bounds) == 568) {
        self.imageViewBackground.image = [UIImage imageNamed:PORTRAIT_IMAGE];
    } else {
        self.imageViewBackground.image = [UIImage imageNamed:PORTRAIT_IMAGE4];
    }
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [self.view addGestureRecognizer:tapRecognizer];
    
    self.textViewDescription.layer.cornerRadius = 5;
    self.textViewDescription.alpha = .8;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)pressedSubmitProofButton:(id)sender
{
    [JWCTaskManager sharedManager].currentTask.proofDescribe = self.textViewDescription.text;
    if ([[JWCTaskManager sharedManager].currentTask.proofDescribe isEqualToString:@""]) {
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 100)];
        messageLabel.font = DEFAULT_FONT;
        messageLabel.textColor = DEFAULT_TEXT_COLOR;
        messageLabel.text = @"You've got to describe what you got done!";
        messageLabel.backgroundColor = [UIColor clearColor];
        [[KGModal sharedInstance] showWithContentView:messageLabel];
    } else {
        [[JWCTaskManager sharedManager] currentTaskDone];
        //TODO: Put some more stuff in here, like twitter posting, messaging partner etc.
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Gesture Recognizer Methods
- (void)dismissKeyboard:(UITapGestureRecognizer *)tapGesture
{
    [self.textViewDescription endEditing:YES];
}

@end
