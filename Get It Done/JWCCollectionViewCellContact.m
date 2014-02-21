//
//  JWCCollectionViewCellContact.m
//  Get It Done
//
//  Created by Jeff Schwab on 2/8/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCCollectionViewCellContact.h"

@implementation JWCCollectionViewCellContact

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contactsImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        self.contactsImage.image = [UIImage imageNamed:@"identification.png"];
        
        [self addSubview:self.contactsImage];
        
        self.labelName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame)-5, CGRectGetHeight(frame))];
        self.labelName.textAlignment = NSTextAlignmentCenter;
        self.labelName.font = DEFAULT_FONT;
        self.labelName.textColor = [UIColor whiteColor];
        self.labelName.numberOfLines = 0;
        self.labelName.layer.masksToBounds = YES;
        [self addSubview:self.labelName];
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
