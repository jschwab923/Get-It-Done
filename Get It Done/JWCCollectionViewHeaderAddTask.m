//
//  JWCAddTaskCollectionViewHeader.m
//  Get It Done
//
//  Created by Jeff Schwab on 2/4/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCCollectionViewHeaderAddTask.h"

@implementation JWCCollectionViewHeaderAddTask

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        [self addSubview:self.headerLabel];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    self.headerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:20];
}


@end
