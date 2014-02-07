//
//  JWCCollectionReusableFooterLabel.m
//  Get It Done
//
//  Created by Jeff Schwab on 2/6/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCCollectionReusableFooterLabel.h"

@implementation JWCCollectionReusableFooterLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 90)];
        self.footerLabel.numberOfLines = 0;
        self.footerLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.footerLabel];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{

}


@end
