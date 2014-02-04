//
//  JWCCollectionViewCell.h
//  Get It Done
//
//  Created by Jeff Schwab on 1/31/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JWCSoonCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UITextView *subTaskTextView;
@property (weak, nonatomic) IBOutlet UIButton *buttonSubtaskDone;

@end
