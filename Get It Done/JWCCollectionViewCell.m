//
//  JWCCollectionViewCell.m
//  Get It Done
//
//  Created by Jeff Schwab on 1/31/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCCollectionViewCell.h"
#import "UIColor+GetItDoneColors.h"
@implementation JWCCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    self.subTaskTextView.textColor = [UIColor darkBlueColor];
    self.layer.cornerRadius = 5;
}


@end
