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
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    self.title = [[UITextField alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(rect)/2, CGRectGetWidth(rect)*.7, 30)];
    self.points = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.title.bounds)+5, CGRectGetHeight(rect)/2, CGRectGetWidth(rect)*.25, 30)];
    
    self.points.keyboardType = UIKeyboardTypeNumberPad;
    self.points.backgroundColor = [UIColor whiteColor];
    self.points.layer.cornerRadius = 3;
    self.points.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:17];
    self.points.placeholder = @"Points";
    [self addSubview:self.points];
    
    self.title.backgroundColor = [UIColor whiteColor];
    self.title.layer.cornerRadius = 3;
    self.title.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:17];
    self.title.placeholder = @"Title";
    [self addSubview:self.title];
    
}


@end
