//
//  JWCSubtask.m
//  Get It Done
//
//  Created by Jeff Schwab on 2/5/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCSubtask.h"

@implementation JWCSubtask

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.subTaskDescription = [aDecoder decodeObjectForKey:@"subTaskDescription"];
        self.percent = [aDecoder decodeObjectForKey:@"percent"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.subTaskDescription forKey:@"subTaskDescription"];
    [aCoder encodeObject:self.percent forKey:@"percent"];
}

@end
