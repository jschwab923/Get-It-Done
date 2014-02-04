//
//  JWCAddTaskCollectionViewCell.m
//  Get It Done
//
//  Created by Jeff Schwab on 2/4/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCTaskDescriptionCollectionViewCell.h"

@implementation JWCTaskDescriptionCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    self.textViewDescription = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(rect),CGRectGetHeight(rect))];
    self.textViewDescription.text = @"Describe what needs to get done";
    [self addSubview:self.textViewDescription];
}


@end