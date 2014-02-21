//
//  JWCTaskManager.m
//  Get It Done
//
//  Created by Jeff Schwab on 1/31/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCTaskManager.h"

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

- (NSMutableArray *)doneTasks
{
    if (!_doneTasks) {
        _doneTasks = [NSMutableArray new];
    }
    return _doneTasks;
}

- (NSArray *)stats
{
    if (!_stats) {
        _stats = [NSMutableArray new];
    }
    return _stats;
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
    [self.doneTasks addObject:self.currentTask];
    [_tasks removeObjectAtIndex:0];
    self.currentTask = [_tasks firstObject];
}

- (CGFloat)getProgressPercent
{
    return self.currentTask.progressPoints.floatValue/self.currentTask.points.floatValue;
}

- (void)updateTaskProgress:(NSNumber *)points withSubtask:(JWCSubtask *)subtask
{
    NSInteger newProgress = points.integerValue;
    NSInteger oldProgress = self.currentTask.progressPoints.integerValue;
    if (!subtask.done) {
        self.currentTask.progressPoints = [NSNumber numberWithInteger:(oldProgress-newProgress)];
        self.currentTask.numberOfTimesSubtasksUndone = [NSNumber numberWithInteger:self.currentTask.numberOfTimesSubtasksUndone.integerValue + 1];
    } else {
        self.currentTask.progressPoints = [NSNumber numberWithInteger:(oldProgress + newProgress)];
    }
}

#pragma mark - Loading and saving methods
- (void)loadCurrentTasks
{
    self.tasks = [self loadArrayFromFile:@"CurrentTasks" fromFolder:@"CurrentTasksFolder"];
    
    self.pendingTask = [[JWCTask alloc] init];
    self.currentTask = [self.tasks firstObject];
}

- (void)loadDoneTasks
{
    self.doneTasks = [self loadArrayFromFile:@"DoneTasks" fromFolder:@"DoneTasksFolder"];
}

- (BOOL)saveCurrentTasks
{
    return [self createFolder:@"CurrentTasksFolder" andFile:@"CurrentTasks"];
}

- (BOOL)saveDoneTasks
{
    return [self createFolder:@"DoneTasksFolder" andFile:@"DoneTasks"];
}

- (BOOL)createFolder:(NSString *)folder andFile:(NSString *)file
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    NSString *currentTasksDirectory = [documentsDirectory stringByAppendingPathComponent:folder];
    NSString *currentTasksFilePath = [currentTasksDirectory stringByAppendingPathComponent:file];
    
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

- (NSMutableArray *)loadArrayFromFile:(NSString *)file fromFolder:(NSString *)folder
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    NSString *currentTasksDirectory = [documentsDirectory stringByAppendingPathComponent:folder];
    NSString *currentTasksFilePath = [currentTasksDirectory stringByAppendingPathComponent:file];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:currentTasksDirectory]) {
        return [[NSKeyedUnarchiver unarchiveObjectWithFile:currentTasksFilePath] mutableCopy];
    } else {
        return [NSMutableArray new];
    }
}

@end
