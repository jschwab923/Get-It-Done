//
//  JWCTask.m
//  Get It Done
//
//  Created by Jeff Schwab on 2/4/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCTask.h"

@implementation JWCTask

- (instancetype)init
{
    if (self = [super init]) {
        self.taskID = [NSUUID UUID];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.taskID = [aDecoder decodeObjectForKey:@"taskID"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.taskDescription = [aDecoder decodeObjectForKey:@"taskDescription"];
        self.proofType = [aDecoder decodeObjectForKey:@"proofType"];
        self.proof = [aDecoder decodeObjectForKey:@"proof"];
        self.start = [aDecoder decodeObjectForKey:@"start"];
        self.due = [aDecoder decodeObjectForKey:@"due"];
        self.subTasks = [aDecoder decodeObjectForKey:@"subTasks"];
        self.partner = [aDecoder decodeObjectForKey:@"partner"];
        self.points = [aDecoder decodeObjectForKey:@"points"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.taskID forKey:@"taskID"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.taskDescription forKey:@"taskDescription"];
    [aCoder encodeObject:self.proofType forKey:@"proofType"];
    [aCoder encodeObject:self.proof forKey:@"proof"];
    [aCoder encodeObject:self.start forKey:@"start"];
    [aCoder encodeObject:self.due forKey:@"due"];
    [aCoder encodeObject:self.subTasks forKey:@"subTasks"];
    [aCoder encodeObject:self.partner forKey:@"partner"];
    [aCoder encodeObject:self.points forKey:@"points"];
}

@end
