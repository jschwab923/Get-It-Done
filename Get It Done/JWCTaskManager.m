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

- (NSArray *)tasks
{
    return [_tasks copy];
}

- (void)addTask:(JWCTask *)task
{
    [_tasks addObject:task];
}

@end
