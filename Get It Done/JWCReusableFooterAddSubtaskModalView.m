//
//  JWCReusableFooterAddSubtaskModalView.m
//  Get It Done
//
//  Created by Jeff Schwab on 2/9/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCReusableFooterAddSubtaskModalView.h"

@implementation JWCReusableFooterAddSubtaskModalView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
        self.addButton.frame = CGRectMake(CGRectGetWidth(frame)-25, 0, 20, 20);
        self.addButton.tintColor = DEFAULT_TEXT_COLOR;
        [self addSubview:self.addButton];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
