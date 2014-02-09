//
//  JWCCollectionViewFooterPartner.h
//  Get It Done
//
//  Created by Jeff Schwab on 2/4/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JWCCollectionViewFooterAddPartner : UICollectionReusableView
<UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UISearchBarDelegate>

@property (nonatomic) UIImageView *partnerImage;
@property (nonatomic) UILabel *partnerLabel;

@property (nonatomic) NSArray *contactsWithName;

@end
