//
//  JWCMessageController.m
//  Get It Done
//
//  Created by Jeff Schwab on 2/10/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCMessageController.h"
#import "JWCTaskManager.h"

@implementation JWCMessageController

+ (MFMailComposeViewController *)getEmailViewController
{
    MFMailComposeViewController *emailViewController = [[MFMailComposeViewController alloc] init];
    [emailViewController setToRecipients:[JWCTaskManager sharedManager].currentTask.partner.emails];
    return emailViewController;
}

+ (MFMessageComposeViewController *)getTextViewController
{
    MFMessageComposeViewController *messageViewController = [[MFMessageComposeViewController alloc] init];
    [messageViewController setRecipients:[JWCTaskManager sharedManager].currentTask.partner.phoneNumbers];
    return messageViewController;
}

@end
