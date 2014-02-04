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
    UILabel *addSubtaskLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(rect), 0, CGRectGetWidth(rect)/2, CGRectGetHeight(rect))];
    
    addSubtaskLabel.backgroundColor = [UIColor clearColor];
    addSubtaskLabel.text = @"Add Subtask";
    addSubtaskLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:17];
    [self addSubview:addSubtaskLabel];
    
    NSLog(@"%f %f", addSubtaskLabel.frame.origin.x, addSubtaskLabel.frame.origin.y);
    
    UIButton *addSubtaskButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(addSubtaskLabel.frame)+5, 0, 15, 15)];
    
    addSubtaskButton.contentMode = UIViewContentModeScaleToFill;
    [addSubtaskButton setImage:[UIImage imageNamed:@"Add"] forState:UIControlStateNormal];
    addSubtaskButton.backgroundColor = [UIColor clearColor];
    [self addSubview:addSubtaskButton];
    
     NSLog(@"%f %f", addSubtaskButton.frame.origin.x, addSubtaskButton.frame.origin.y);
}


@end
