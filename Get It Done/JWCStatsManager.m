//
//  JWCStatsManager.m
//  Get It Done
//
//  Created by Jeff Schwab on 2/16/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCStatsManager.h"

@implementation JWCStatsManager

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.datesAndPoints = [aDecoder decodeObjectForKey:@"datesAndPoints"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.datesAndPoints forKey:@"datesAndPoints"];
}

- (NSMutableDictionary *)datesAndPoints
{
    if (!_datesAndPoints) {
        _datesAndPoints = [NSMutableDictionary new];
    }
    return _datesAndPoints;
}

@end
