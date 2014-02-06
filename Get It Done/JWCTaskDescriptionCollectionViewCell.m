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
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    self.textViewDescription.frame = CGRectMake(0, 0, CGRectGetWidth(rect),CGRectGetHeight(rect));
    self.textViewDescription.layer.cornerRadius = 3;
    self.textViewDescription.text = @"Describe what needs to get done";
    self.textViewDescription.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:15];
    [self.textViewDescription setReturnKeyType:UIReturnKeyDone];
    self.textViewDescription.tag = TAG_DESCRIPTION_TEXTFIELD;
    [self addSubview:self.textViewDescription];
}


@end
