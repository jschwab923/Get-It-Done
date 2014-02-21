//
//  JWCMessageController.h
//  Get It Done
//
//  Created by Jeff Schwab on 2/10/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MessageUI;

@interface JWCMessageController : NSObject

+ (MFMessageComposeViewController *)getTextViewController;
+ (MFMailComposeViewController *)getEmailViewController;
+ (NSString *)messageForText;
+ (NSString *)messageForEmail;


@end
