//
//  NSDate+DateFormatter.m
//  Get It Done
//
//  Created by Jeff Schwab on 2/16/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "NSDate+DateFormatter.h"

@implementation NSDate (DateFormatter)

+ (NSString *)getCurrentMonthDayYearString
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"MM/dd/yyyy";
    
    return [format stringFromDate:[NSDate new]];
}

@end

