//
//  JWCCollectionViewFooterPartner.m
//  Get It Done
//
//  Created by Jeff Schwab on 2/4/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCCollectionViewFooterPartner.h"

@implementation JWCCollectionViewFooterPartner

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
    UILabel *partnerLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(rect)-10, 0, CGRectGetWidth(rect)*.6, CGRectGetHeight(rect))];
    
    partnerLabel.text = @"Who will help you?";
    partnerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:18];
    partnerLabel.backgroundColor = [UIColor clearColor];
    
    [self addSubview:partnerLabel];
    
    UIImageView *partnerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    partnerImage.center = CGPointMake(CGRectGetWidth(rect)-20, CGRectGetMidY(rect));
    
    partnerImage.contentMode = UIViewContentModeScaleAspectFill;
    partnerImage.image = [UIImage imageNamed:@"Group"];
    
    [self addSubview:partnerImage];
}

@end
