//
//  JWCCollectionViewFooterPartner.m
//  Get It Done
//
//  Created by Jeff Schwab on 2/4/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCCollectionViewFooterPartner.h"
#import "JWCTaskPartner.h"
#import "JWCTaskManager.h"
#import "JWCTask.h"
#import "KGModal.h"

@interface JWCCollectionViewFooterPartner ()
{
    UITapGestureRecognizer *_buttonTouched;
}
@end

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
    self.partnerLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(rect)-10, 0, CGRectGetWidth(rect)*.6, CGRectGetHeight(rect))];
    
    self.partnerLabel.text = @"Who will help you?";
    self.partnerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:18];
    self.partnerLabel.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.partnerLabel];
    
    self.partnerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    self.partnerImage.center = CGPointMake(CGRectGetWidth(rect)-20, CGRectGetMidY(rect));
    
    self.partnerImage.contentMode = UIViewContentModeScaleAspectFill;
    self.partnerImage.image = [UIImage imageNamed:@"Group"];
    
    _buttonTouched = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                             action:@selector(pressedAddPartner:)];
    
    [self addGestureRecognizer:_buttonTouched];
    
    [self addSubview:self.partnerImage];

}

#pragma mark - Gesture Recognizer Methods
- (void)pressedAddPartner:(UIGestureRecognizer *)tapRecognizer
{
    UICollectionViewFlowLayout *contactLayout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *contactsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 275, 300) collectionViewLayout:contactLayout];
    contactsCollectionView.backgroundColor = [UIColor clearColor];

    [[KGModal sharedInstance] showWithContentView:contactsCollectionView andAnimated:YES];
}

- (void)prepareForReuse
{
    self.partnerImage.image = nil;
    [self.partnerLabel removeGestureRecognizer:_buttonTouched];
}

@end
