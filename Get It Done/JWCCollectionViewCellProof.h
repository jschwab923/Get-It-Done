//
//  JWCCollectionViewCellProof.h
//  Get It Done
//
//  Created by Jeff Schwab on 2/4/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JWCCollectionViewCellProof : UICollectionViewCell
<UIPickerViewDataSource, UIPickerViewDelegate,
UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerViewProof;

@end
