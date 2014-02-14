//
//  JWCViewLine.m
//  Get It Done
//
//  Created by Jeff Schwab on 2/6/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCViewLine.h"

@implementation JWCViewLine

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = DEFAULT_PIE_TITLE_COLOR;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    self.backgroundColor = DEFAULT_PIE_TITLE_COLOR;
}


@end
