//
//  JWCAddTaskCollectionViewCell.m
//  Get It Done
//
//  Created by Jeff Schwab on 2/4/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCTaskDescriptionCollectionViewCell.h"

@implementation JWCTaskDescriptionCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.textViewDescription = [[UITextView alloc] init];
        self.textViewDescription.text = @"Describe what needs to get done";
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    self.textViewDescription.frame = CGRectMake(5, 0, CGRectGetWidth(rect)-11,CGRectGetHeight(rect));
    self.textViewDescription.layer.cornerRadius = 3;
    self.textViewDescription.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:15];
    [self.textViewDescription setReturnKeyType:UIReturnKeyDefault];
    self.textViewDescription.tag = TAG_DESCRIPTION_TEXTFIELD;
    [self addSubview:self.textViewDescription];
}


@end
