//
//  JWCTaskManager.m
//  Get It Done
//
//  Created by Jeff Schwab on 1/31/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCTaskManager.h"
#import "JWCStatsManager.h"
#import "NSDate+DateFormatter.h"

@interface JWCTaskManager ()
{
    JWCStatsManager *_statsManager;
    
    NSMutableArray *_tasks;
    
    NSString *_currentDateString;
}
@end

@implementation JWCTaskManager

+ (JWCTaskManager *)sharedManager
{
    static JWCTaskManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
        [sharedManager setUpDefaultTaskAndCurrentDateString];
    });
    return sharedManager;
}

- (void)setUpDefaultTaskAndCurrentDateString
{
    _currentDateString = [NSDate getCurrentMonthDayYearString];
    
    _defaultTask = [JWCTask new];
    _defaultTask.title = @"Something to get done today. Will reset each day. Tap for more info.";
    _defaultTask.taskDescription = @"Tasks will reset at the beginning of each day, so make sure you get everything done! When you enter a task the description will show up here.";
    for (int i = 1; i < 5; i++) {
        JWCSubtask *defaultSubtask = [JWCSubtask new];
        defaultSubtask.subTaskDescription = [NSString stringWithFormat:@"This is subtask #%i. Swipe right to mark it done, left to undo marking it done. Tap for details.", i];
        defaultSubtask.percent = @(100/4);
        [_defaultTask.subTasks addObject:defaultSubtask];
    }
    _defaultTask.points = @100;
    _defaultTask.proofType = PROOF_TYPE_QUESTIONS;
    _defaultTask.proofQuestions = [@[@"Question 1",@"Question 2",@"Question 3"] mutableCopy];
    _defaultTask.partner = [JWCTaskPartner new];
}

- (NSArray *)tasks
{
    if (!_tasks) {
        _tasks = [NSMutableArray new];
        [_tasks addObject:_defaultTask];
    } else if ([_tasks firstObject] == _defaultTask) {
        [_tasks removeObject:_defaultTask];
    } else if ([_tasks count] == 0) {
        [_tasks addObject:_defaultTask];
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

- (JWCTask *)currentTask
{
    if (!_currentTask) {
        _currentTask = [self.tasks firstObject];
    } else if ((_currentTask == _defaultTask) && [self.tasks firstObject] != _defaultTask) {
        _currentTask = [self.tasks firstObject];
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
    self.pendingTask = [JWCTask new];
}

- (void)currentTaskDone
{
    if ([_statsManager.datesAndPoints objectForKey:_currentDateString]) {
        NSNumber *pointsEarnedOnDate = [_statsManager.datesAndPoints objectForKey:_currentDateString];
        NSNumber *updatedPoints = [NSNumber numberWithInteger:pointsEarnedOnDate.integerValue + self.currentTask.points.integerValue];
        [_statsManager.datesAndPoints setObject:updatedPoints forKey:_currentDateString];
    } else {
        [_statsManager.datesAndPoints setObject:self.currentTask.points forKey:_currentDateString];
    }
    
    [self.doneTasks addObject:self.currentTask];
    [_tasks removeObjectAtIndex:0];
    self.currentTask = [_tasks firstObject];
}

- (NSMutableDictionary *)getStatsDictionary
{
    return _statsManager.datesAndPoints;
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
    } else {
        self.currentTask.progressPoints = [NSNumber numberWithInteger:(oldProgress + newProgress)];
    }
}

#pragma mark - Loading and saving methods
- (void)loadCurrentTasks
{
    if ([_currentDateString isEqualToString:[[_statsManager.datesAndPoints allKeys] firstObject]]) {
        _tasks = [[self loadObjectFromFile:@"CurrentTasks" fromFolder:@"CurrentTasksFolder"] mutableCopy];
    }
    
    self.pendingTask = [[JWCTask alloc] init];
    self.currentTask = [_tasks firstObject];
}

- (void)loadDoneTasks
{
    self.doneTasks = [[self loadObjectFromFile:@"DoneTasks" fromFolder:@"DoneTasksFolder"] mutableCopy];
}

- (BOOL)saveCurrentTasks
{
    if (!([self.currentTask.taskDescription isEqualToString:_defaultTask.taskDescription])) {
        return [self createFolder:@"CurrentTasksFolder" andFile:@"CurrentTasks" withObject:self.tasks];
    }
    return YES;
}

- (BOOL)saveDoneTasks
{
    return [self createFolder:@"DoneTasksFolder" andFile:@"DoneTasks" withObject:self.doneTasks];
}

- (BOOL)createFolder:(NSString *)folder andFile:(NSString *)file withObject:(id)objectToSave
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
        [NSKeyedArchiver archiveRootObject:objectToSave toFile:currentTasksFilePath];
        return YES;
    }
    return NO;
}

- (id)loadObjectFromFile:(NSString *)file fromFolder:(NSString *)folder
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    NSString *currentTasksDirectory = [documentsDirectory stringByAppendingPathComponent:folder];
    NSString *currentTasksFilePath = [currentTasksDirectory stringByAppendingPathComponent:file];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:currentTasksDirectory]) {
        return [NSKeyedUnarchiver unarchiveObjectWithFile:currentTasksFilePath];
    } else {
        return nil;
    }
}

- (void)loadStatsManager
{
    if (!(_statsManager = [self loadObjectFromFile:@"statsManager" fromFolder:@"StatsFolder"])) {
        _statsManager = [JWCStatsManager new];
    }
    _currentDateString = [NSDate getCurrentMonthDayYearString];
    if (![_statsManager.datesAndPoints objectForKey:_currentDateString]) {
        [_statsManager.datesAndPoints setObject:[NSNumber numberWithInt:0] forKey:_currentDateString];
    }
}

- (BOOL)saveStatsManager
{
    return [self createFolder:@"StatsFolder" andFile:@"statsManager" withObject:_statsManager];
}

@end
