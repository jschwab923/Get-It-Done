//
//  JWCAddTaskCollectionViewFooter.m
//  Get It Done
//
//  Created by Jeff Schwab on 2/4/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCAddSubtaskCollectionViewFooter.h"

@implementation JWCAddSubtaskCollectionViewFooter

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
    UILabel *addSubtaskLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(rect), 0,
                                                                         CGRectGetWidth(rect)/3, CGRectGetHeight(rect))];
    
    addSubtaskLabel.backgroundColor = [UIColor clearColor];
    addSubtaskLabel.text = @"Add Subtask";
    addSubtaskLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:17];
    [self addSubview:addSubtaskLabel];
    
    UIButton *addSubtaskButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    addSubtaskButton.center = CGPointMake(CGRectGetMidX(addSubtaskLabel.frame)+CGRectGetWidth(addSubtaskLabel.frame)/1.5, CGRectGetHeight(rect)/2);
    
    addSubtaskButton.contentMode = UIViewContentModeScaleToFill;
    [addSubtaskButton setImage:[UIImage imageNamed:@"Add"] forState:UIControlStateNormal];
    addSubtaskButton.backgroundColor = [UIColor clearColor];
    [self addSubview:addSubtaskButton];
    
}


@end
