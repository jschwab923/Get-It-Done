//
//  JWCCollectionViewCellAnswerProofQuestions.m
//  Get It Done
//
//  Created by Jeff Schwab on 2/10/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCCollectionViewCellAnswerProofQuestions.h"

@implementation JWCCollectionViewCellAnswerProofQuestions

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textViewAnswer.layer.cornerRadius = 5;
        self.textViewAnswer.alpha = .6;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    self.textViewAnswer.layer.cornerRadius = 5;
    self.textViewAnswer.alpha = .6;
}


@end
