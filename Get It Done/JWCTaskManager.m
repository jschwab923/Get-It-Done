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

- (NSArray *)stats
{
    if (!_stats) {
        _stats = [NSMutableArray new];
    }
    return _stats;
}

- (CGFloat)getProgressFloatValue
{
    return self.progress.floatValue;
}

- (NSNumber *)progress
{
    if (!_progress) {
        _progress = [NSNumber numberWithFloat:0];
    }
    return _progress;
}

- (JWCTask *)currentTask
{
    if (!_currentTask) {
        _currentTask = [_tasks firstObject];
    }
    return _currentTask;
}

- (void)addTask:(JWCTask *)task
{
    if (!_tasks) {
        _tasks = [NSMutableArray new];
    }
    [_tasks addObject:task];
}

#pragma mark - Task action methods
- (void)commitPendingTask
{
    if ([[_tasks lastObject] isEqual:self.pendingTask]) {
        [_tasks replaceObjectAtIndex:[_tasks count]-1 withObject:self.pendingTask];
    } else {
        [_tasks addObject:self.pendingTask];
    }
}

- (void)currentTaskDone
{
    [_tasks removeObjectAtIndex:0];
    self.currentTask = [_tasks firstObject];
}

#pragma mark - Loading and saving methods
- (void)loadCurrentTasks
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    NSString *currentTasksDirectory = [documentsDirectory stringByAppendingPathComponent:@"CurrentTasksFolder"];
    NSString *currentTasksFilePath = [currentTasksDirectory stringByAppendingPathComponent:@"CurrentTasks"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:currentTasksDirectory]) {
        self.tasks = [[NSKeyedUnarchiver unarchiveObjectWithFile:currentTasksFilePath] mutableCopy];
    }
    self.pendingTask = [[JWCTask alloc] init];
    self.currentTask = [_tasks firstObject];
}

- (BOOL)saveCurrentTasks
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    NSString *currentTasksDirectory = [documentsDirectory stringByAppendingPathComponent:@"CurrentTasksFolder"];
    NSString *currentTasksFilePath = [currentTasksDirectory stringByAppendingPathComponent:@"CurrentTasks"];
    
    NSError *directoryCreateError;
    if (![[NSFileManager defaultManager] fileExistsAtPath:currentTasksDirectory]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:currentTasksDirectory withIntermediateDirectories:NO attributes:Nil error:&directoryCreateError];
    }
    
    if (directoryCreateError) {
        NSLog(@"Error creating save directory");
    } else {
        [NSKeyedArchiver archiveRootObject:self.tasks toFile:currentTasksFilePath];
        return YES;
    }
    return NO;
}

@end
