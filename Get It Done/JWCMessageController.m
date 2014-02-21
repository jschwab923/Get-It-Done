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

+ (NSString *)messageForText
{
    NSString *message;
    JWCTask *currentTask = [JWCTaskManager sharedManager].currentTask;
    if ([[JWCTaskManager sharedManager].currentTask.proofType isEqualToString:PROOF_TYPE_DESCRIBE])
    {
        message = [NSString stringWithFormat:@"Here's my description proving that I got this task done. Task: %@\n Description:%@", currentTask.title, currentTask.proofDescribe];
    } else if ([[JWCTaskManager sharedManager].currentTask.proofType isEqualToString:PROOF_TYPE_PICTURE])
    {
        message = [NSString stringWithFormat:@"I took a picture proving that I got this task done. Task: %@\n. I'll be sending it to you later. Bug me if you don't get it soon.", currentTask.title];
        
    } else if ([[JWCTaskManager sharedManager].currentTask.proofType isEqualToString:PROOF_TYPE_QUESTIONS])
    {
        NSString *firstQuestion = [currentTask.proofQuestions firstObject];
        NSString *firstAnswer = [currentTask.proofQuestionAnswers firstObject];
        NSString *secondQuestion;
        NSString *secondAnswer;
        NSString *thirdQuestion;
        NSString *thirdAnswer;
        
        if ([currentTask.proofQuestions count] > 1) {
            secondQuestion = currentTask.proofQuestions[1];
            secondAnswer = currentTask.proofQuestionAnswers[1];
            
            thirdQuestion = [currentTask.proofQuestions lastObject];
            thirdAnswer = [currentTask.proofQuestionAnswers lastObject];
        }
        
        message = [NSString stringWithFormat:@"Here are my answers to the questions proving that I got this task done. \nTask:\n%@\nQuestion1:\n%@\nAnswer:\n%@\n\nQuestion2:\n%@\nAnswer:\n%@\n\nQuestion3:\n%@\nAnswer:\n%@", currentTask.title, firstQuestion, firstAnswer, secondQuestion, secondAnswer, thirdQuestion, thirdAnswer];
    }
    return message;
}

+ (NSString *)messageForEmail
{
    NSString *message;
    JWCTask *currentTask = [JWCTaskManager sharedManager].currentTask;
    if ([[JWCTaskManager sharedManager].currentTask.proofType isEqualToString:PROOF_TYPE_DESCRIBE])
    {
        message = [NSString stringWithFormat:@"Here's my description proving that I got this task done. Task: %@\n Description:%@", currentTask.title, currentTask.proofDescribe];
    } else if ([[JWCTaskManager sharedManager].currentTask.proofType isEqualToString:PROOF_TYPE_PICTURE])
    {
        message = [NSString stringWithFormat:@"I took a picture proving that I got this task done. Task: %@\n. I've attached it.", currentTask.title];
        
    } else if ([[JWCTaskManager sharedManager].currentTask.proofType isEqualToString:PROOF_TYPE_QUESTIONS])
    {
        NSString *firstQuestion = [currentTask.proofQuestions firstObject];
        NSString *firstAnswer = [currentTask.proofQuestionAnswers firstObject];
        NSString *secondQuestion;
        NSString *secondAnswer;
        NSString *thirdQuestion;
        NSString *thirdAnswer;
        
        if ([currentTask.proofQuestions count] > 1) {
            secondQuestion = currentTask.proofQuestions[1];
            secondAnswer = currentTask.proofQuestionAnswers[1];
            
            thirdQuestion = [currentTask.proofQuestions lastObject];
            thirdAnswer = [currentTask.proofQuestionAnswers lastObject];
        }
        
        message = [NSString stringWithFormat:@"Here are my answers to the questions proving that I got this task done. Task: %@\n Question1:%@ Answer:%@\nQuestion2:%@ Answer:%@\nQuestion3:%@ Answer:%@", currentTask.title, firstQuestion, firstAnswer, secondQuestion, secondAnswer, thirdQuestion, thirdAnswer];
    }
    return message;
}


@end
