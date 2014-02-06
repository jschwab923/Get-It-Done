//
//  JWCTaskManager.m
//  Get It Done
//
//  Created by Jeff Schwab on 1/31/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCTaskManager.h"
#import "JWCSubtask.h"

@implementation JWCTaskManager
{
    NSMutableArray *_tasks;
}

+ (JWCTaskManager *)sharedManager
{
    static JWCTaskManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
        sharedManager.currentTask = [[JWCTask alloc] init];
        sharedManager.pendingTask = [[JWCTask alloc] init];
        [sharedManager setUpTasksArray];
    });
    
    return sharedManager;
}

- (NSArray *)tasks
{
    if (!_tasks) {
        _tasks = [NSMutableArray new];
    }
    return [_tasks copy];
}

- (void)addTask:(JWCTask *)task
{
    if (!_tasks) {
        _tasks = [NSMutableArray new];
    }
    [_tasks addObject:task];
}

// TODO: Delete default tasks and get this info from storage of some kind.
- (void)setUpTasksArray
{
    for (int i = 0; i < 3; i++) {
        JWCTask *newTask = [JWCTask new];
        
        newTask.title = [NSString stringWithFormat:@"Task #%i", i];
        newTask.taskDescription = [NSString stringWithFormat:@"This is task #%i and it needs to get done", i];
        newTask.proofType = @"Describe";
        newTask.proof = nil;
        newTask.start = [NSDate date];
        newTask.due = [NSDate dateWithTimeInterval:2000 sinceDate:newTask.start];
        
        for (int j = 0; j < i+3; j++) {
            NSString *subTaskDescription = [NSString stringWithFormat:@"Here is a subtask and it is #%i", j + i];
            NSNumber *taskPercent = [NSNumber numberWithInt:(j*40)%100];
            JWCSubtask *newSubtask = [[JWCSubtask alloc] init];
            newSubtask.subTaskDescription = subTaskDescription;
            newSubtask.percent = taskPercent;
            
            [[newTask subTasks] addObject:newSubtask];
        }
        
        [self addTask:newTask];
    }
    
// TODO: Figure out how to set current task dynamically
    self.currentTask = [self.tasks objectAtIndex:0];
}

- (void)commitPendingTask
{
    //TODO:REMOVE THIS LINE
    self.currentTask = self.pendingTask;
    
    [_tasks addObject:self.pendingTask];
    self.pendingTask = [[JWCTask alloc] init];
}


@end
