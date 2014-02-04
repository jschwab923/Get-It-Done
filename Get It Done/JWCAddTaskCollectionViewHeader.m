//
//  JWCAddTaskCollectionViewHeader.m
//  Get It Done
//
//  Created by Jeff Schwab on 2/4/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCAddTaskCollectionViewHeader.h"

@implementation JWCAddTaskCollectionViewHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    UILabel *taskInfoHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, CGRectGetWidth(rect), CGRectGetHeight(rect))];
    taskInfoHeaderLabel.text = @"What needs to get done?";
    taskInfoHeaderLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:20];
    [self addSubview:taskInfoHeaderLabel];
}


@end
