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

// Used to persist temporary progress when adding a task
@property (nonatomic) JWCTask *pendingTask;

@property (nonatomic) NSNumber *progress;
@property (nonatomic) NSMutableArray *stats;

//TODO: Make this depend on the actual subtask percent values
@property (nonatomic, readwrite) CGFloat numberOfSubtasksDone;


+ (JWCTaskManager *)sharedManager;

- (void)addTask:(JWCTask *)task;
- (void)commitPendingTask;
- (void)currentTaskDone;

- (void)loadCurrentTasks;
- (BOOL)saveCurrentTasks;

- (CGFloat)getProgressFloatValue;
@end
