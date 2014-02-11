//
//  JWCCollectionViewCellAnswerProofQuestions.h
//  Get It Done
//
//  Created by Jeff Schwab on 2/10/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JWCCollectionViewCellAnswerProofQuestions : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelQuestion;

@property (weak, nonatomic) IBOutlet UITextView *textViewAnswer;

@end
