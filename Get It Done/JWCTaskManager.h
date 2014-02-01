//
//  JWCTaskManager.h
//  Get It Done
//
//  Created by Jeff Schwab on 1/31/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JWCTask.h"

@interface JWCTaskManager : NSObject

@property (nonatomic) NSArray *tasks;
@property (nonatomic) JWCTask *currentTask;

- (void)addTask:(JWCTask *)task;

@end
