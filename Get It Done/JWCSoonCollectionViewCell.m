//
//  JWCCollectionViewCell.m
//  Get It Done
//
//  Created by Jeff Schwab on 1/31/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCSoonCollectionViewCell.h"
#import "UIColor+GetItDoneColors.h"
@implementation JWCSoonCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.subTaskTextView.textColor = DEFAULT_TEXT_COLOR;
        self.subTaskTextView.font = DEFAULT_FONT;
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    self.subTaskTextView.textColor = DEFAULT_TEXT_COLOR;
    self.subTaskTextView.font = DEFAULT_FONT;
}

@end
