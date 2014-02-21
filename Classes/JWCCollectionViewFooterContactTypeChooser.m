//
//  JWCCollectionViewCellContactInfo.m
//  Get It Done
//
//  Created by Jeff Schwab on 2/9/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCCollectionViewFooterContactTypeChooser.h"

@implementation JWCCollectionViewFooterContactTypeChooser

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.buttonChoosePhone = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame)/2 + 10, 30)];
        self.buttonChooseEmail = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame)-CGRectGetWidth(frame)/3, 0, CGRectGetWidth(frame)/3, 30)];
        
        [self.buttonChoosePhone setTitle:@"Use phone number" forState:UIControlStateNormal];
        [self.buttonChooseEmail setTitle:@"Use email" forState:UIControlStateNormal];
        
        [self.buttonChoosePhone setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:.8]];
        [self.buttonChooseEmail setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:.8]];
         
        self.buttonChoosePhone.titleLabel.textColor = DEFAULT_TEXT_COLOR;
        self.buttonChooseEmail.titleLabel.textColor = DEFAULT_TEXT_COLOR;
        
        self.buttonChoosePhone.titleLabel.font = DEFAULT_FONT;
        self.buttonChooseEmail.titleLabel.font = DEFAULT_FONT;
        
        self.buttonChoosePhone.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.buttonChooseEmail.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:self.buttonChoosePhone];
        [self addSubview:self.buttonChooseEmail];
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
