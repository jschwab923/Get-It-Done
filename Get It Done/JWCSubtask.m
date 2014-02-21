//
//  JWCSubtask.m
//  Get It Done
//
//  Created by Jeff Schwab on 2/5/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCSubtask.h"

@implementation JWCSubtask

- (id)init
{
    if (self = [super init]) {
        _done = NO;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.subTaskDescription = [aDecoder decodeObjectForKey:@"subTaskDescription"];
        self.percent = [aDecoder decodeObjectForKey:@"percent"];
        self.done = [[aDecoder decodeObjectForKey:@"done"] integerValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.subTaskDescription forKey:@"subTaskDescription"];
    [aCoder encodeObject:self.percent forKey:@"percent"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.done] forKey:@"done"];
}

@end
