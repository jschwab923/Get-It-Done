//
//  JWCCollectionViewCellTitlePoints.m
//  Get It Done
//
//  Created by Jeff Schwab on 2/4/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCCollectionViewCellTitlePoints.h"

@implementation JWCCollectionViewCellTitlePoints

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.title = [[UITextField alloc] init];
        self.points = [[UITextField alloc] init];
        
        self.frame = CGRectMake(0, 0, CGRectGetWidth(self.superview.frame), CGRectGetHeight(frame));
        
        self.title.placeholder = @"Title";
        self.points.placeholder = @"Points";
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    self.title.frame = CGRectMake(5, 0, CGRectGetWidth(rect)*.7, 30);
    self.title.center = CGPointMake(self.title.center.x, CGRectGetMidY(rect));
    self.title.layer.cornerRadius = 3;
    self.title.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:17];
    self.title.tag = TAG_TITLE_TEXTVIEW;
    [self addSubview:self.title];

    self.points.frame = CGRectMake(CGRectGetWidth(self.title.frame)+10, 0, CGRectGetWidth(rect)*.25, 30);
    self.points.center = CGPointMake(self.points.center.x, CGRectGetMidY(rect));
    self.points.keyboardType = UIKeyboardTypeNumberPad;
    self.points.layer.cornerRadius = 3;
    self.points.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:17];
    self.points.tag = TAG_POINTS_TEXTVIEW;
    [self addSubview:self.points];
    
}

- (void)prepareForReuse
{
    self.title.text = @"";
    self.points.text = @"";
}

@end
