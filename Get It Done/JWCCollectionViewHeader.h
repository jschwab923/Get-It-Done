//
//  JWCCollectionViewHeader.h
//  Get It Done
//
//  Created by Jeff Schwab on 1/31/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JWCCollectionViewHeader : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UITextView *taskDescriptionTextView;
@property (weak, nonatomic) IBOutlet UIImageView *taskImageView;

@end
