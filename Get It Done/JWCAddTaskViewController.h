//
//  JWCAddTaskViewController.h
//  Get It Done
//
//  Created by Jeff Schwab on 1/30/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JWCAddSubtaskCollectionViewFooter.h"

@interface JWCAddTaskViewController : UIViewController
<UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewAddTask;

@end
