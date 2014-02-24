//
//  JWCTaskManager.h
//  Get It Done
//
//  Created by Jeff Schwab on 1/31/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JWCTask.h"
#import "JWCSubtask.h"

@interface JWCTaskManager : NSObject 

@property (nonatomic) JWCTask *defaultTask;

@property (nonatomic) NSArray *tasks;
@property (nonatomic) JWCTask *currentTask;

@property (nonatomic) NSMutableArray *doneTasks;

// Used to persist temporary progress when adding a task
@property (nonatomic) JWCTask *pendingTask;

+ (JWCTaskManager *)sharedManager;

- (void)addTask:(JWCTask *)task;
- (void)commitPendingTask;
- (void)currentTaskDone;
- (CGFloat)getProgressPercent;
- (void)updateTaskProgress:(NSNumber *)points withSubtask:(JWCSubtask *)subtask;

- (void)loadCurrentTasks;
- (BOOL)saveCurrentTasks;

- (void)loadDoneTasks;
- (BOOL)saveDoneTasks;

- (void)loadStatsManager;
- (BOOL)saveStatsManager;
- (NSMutableDictionary *)getStatsDictionary;

@end
