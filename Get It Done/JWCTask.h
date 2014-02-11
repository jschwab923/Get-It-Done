//
//  JWCTask.h
//  Get It Done
//
//  Created by Jeff Schwab on 2/4/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JWCTaskPartner.h"

@interface JWCTask : NSObject <NSCoding>

- (BOOL)containsNilProperties;
- (NSInteger)numberOfSubtasksDone;

@property (nonatomic) NSUUID *taskID;

@property (nonatomic) NSString *title;
@property (nonatomic) NSNumber *points;
@property (nonatomic) NSNumber *progressPoints;
@property (nonatomic) NSString *taskDescription;
@property (nonatomic) NSString *proofType;

// Depends on proof type which of these will not be nil
@property (nonatomic) NSString *proofDescribe;
@property (nonatomic) NSMutableArray *proofQuestions;
@property (nonatomic) NSMutableArray *proofQuestionAnswers;
@property (nonatomic) UIImage *proofImage;

@property (nonatomic) NSDate *start;
@property (nonatomic) NSDate *due;

@property (nonatomic) NSMutableArray *subTasks;
@property (nonatomic) NSNumber *numberOfTimesSubtasksChecked;

@property (nonatomic) JWCTaskPartner *partner;

@end
