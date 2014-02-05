//
//  JWCAddTaskCollectionViewFooter.m
//  Get It Done
//
//  Created by Jeff Schwab on 2/4/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCAddSubtaskCollectionViewFooter.h"
#import "KGModal.h"

@implementation JWCAddSubtaskCollectionViewFooter

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
    UILabel *addSubtaskLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(rect)-130, 0,
                                                                         CGRectGetWidth(rect)/3, CGRectGetHeight(rect))];
    addSubtaskLabel.backgroundColor = [UIColor clearColor];
    addSubtaskLabel.text = @"Add Subtask";
    addSubtaskLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:18];
    [self addSubview:addSubtaskLabel];
    
    UIButton *addSubtaskButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    addSubtaskButton.center = CGPointMake(CGRectGetWidth(rect)-20, CGRectGetHeight(rect)/2);
    
    addSubtaskButton.contentMode = UIViewContentModeScaleToFill;
    [addSubtaskButton setImage:[UIImage imageNamed:@"Add"] forState:UIControlStateNormal];
    addSubtaskButton.backgroundColor = [UIColor clearColor];
    [self addSubview:addSubtaskButton];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedAddSubtask:)];
    [addSubtaskButton addGestureRecognizer:tapRecognizer];
}

- (void)tappedAddSubtask:(UITapGestureRecognizer *)tapGesture
{
    UICollectionViewFlowLayout *contactLayout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *contactsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 275, 300) collectionViewLayout:contactLayout];
    contactsCollectionView.backgroundColor = [UIColor clearColor];
    
    [[KGModal sharedInstance] showWithContentView:contactsCollectionView andAnimated:YES];
}


@end
