//
//  JWCCollectionViewCellProof.m
//  Get It Done
//
//  Created by Jeff Schwab on 2/4/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCCollectionViewCellProof.h"
#import "KGModal.h"
#import "JWCTaskDescriptionCollectionViewCell.h"
#import "JWCCollectionViewHeaderAddTask.h"
#import "JWCCollectionViewFooterAddPartner.h"
#import "JWCCollectionReusableFooterLabel.h"
#import "JWCTaskManager.h"
#import "JWCTask.h"

@interface JWCCollectionViewCellProof ()
{
    NSString *_proofQuestionsLabelText;
    UICollectionView *_proofQuestionsCollectionView;
    
    UITextView *_selectedTextView;
    CGPoint _keyboardOffset;
}
@end

@implementation JWCCollectionViewCellProof

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//- (void)drawRect:(CGRect)rect
//{
//
//}

#pragma mark - UIPickerViewDataSource Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 3;
}

#pragma mark - UIPickerViewDelegate Methods
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *pickerViewLabel = (UILabel *)view;
    
    if (!pickerViewLabel) {
        pickerViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        pickerViewLabel.font = DEFAULT_FONT;
        pickerViewLabel.textAlignment = NSTextAlignmentCenter;
        pickerViewLabel.textColor = DEFAULT_TEXT_COLOR;
    }
    
    if (row == 0) {
        pickerViewLabel.text = PROOF_TYPE_PICTURE;
    } else if (row == 1) {
        pickerViewLabel.text = PROOF_TYPE_DESCRIBE;
    } else if (row == 2) {
        pickerViewLabel.text = PROOF_TYPE_QUESTIONS;
    }
    return pickerViewLabel;
}

#pragma mark - UIPickerViewDelegate Methods
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (row) {
        case 0:
            [[[JWCTaskManager sharedManager] pendingTask] setProofType:PROOF_TYPE_PICTURE];
            break;
        case 1:
            [[[JWCTaskManager sharedManager] pendingTask] setProofType:PROOF_TYPE_DESCRIBE];
            break;
        case 2:
        {
            [[[JWCTaskManager sharedManager] pendingTask] setProofType:PROOF_TYPE_QUESTIONS];
            NSString *message = @"Enter in some questions that can only be answered once you've finished the task. Then answer them when you've gotten it done.";
            [self createModalCollectionViewWithMessage:message];
        }
            break;
        default:
            break;
    }
}

#pragma mark - IBOutlets
- (IBAction)pressedProofPickerInfo:(UIButton *)sender
{
    NSString *selectedTitle;
    NSString *message;
    switch ([self.pickerViewProof selectedRowInComponent:0]) {
        case 0:
            selectedTitle = @"Take a Picture";
            message = @"Take and upload a picture of something that proves you got it done.";
            break;
        case 1:
            selectedTitle = @"Describe Finished Task";
            message = @"When you've finished the task, write down a few sentences about it. Reflect on how it went, anything that was difficult, something you learned etc.";
            break;
        case 2:
            message = @"Enter in some questions that can only be answered once you've finished the task. Then answer them when you've gotten it done.";
        default:
            break;
    }
    
    if ([self.pickerViewProof selectedRowInComponent:0] == 2) {
        
        [self createModalCollectionViewWithMessage:message];
        
    } else {
        
        // Determine height of text
        UIFont *font = DEFAULT_FONT;
        CGSize textSize = CGSizeMake(225, MAXFLOAT);
        
        CGRect boundingRect = [message boundingRectWithSize:textSize
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil]
                                                    context:nil];
        
        CGRect roundedSizeRect = CGRectMake(0, 0, 250, ceil(boundingRect.size.height)+20);
        UIView *contentView = [[UIView alloc] initWithFrame:roundedSizeRect];
        UITextView *messageTextView = [[UITextView alloc] initWithFrame:roundedSizeRect];
        messageTextView.center = contentView.center;
        
        [contentView addSubview:messageTextView];
        
        messageTextView.editable = NO;
        messageTextView.backgroundColor = [UIColor clearColor];
        messageTextView.text = message;
        messageTextView.font = DEFAULT_FONT;
        messageTextView.textColor = [UIColor whiteColor];
        
        [[KGModal sharedInstance] showWithContentView:contentView];
    }
}


- (void)createModalCollectionViewWithMessage:(NSString *)message
{
    // Listen for modal view being dismissed and keyboard events
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(modalDismissed:)
                                                 name:KGModalWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardNotificationWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardNotificationDismissed:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    
    _proofQuestionsLabelText = message;
    
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    _proofQuestionsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 250, 300) collectionViewLayout:flowlayout];
    _proofQuestionsCollectionView.backgroundColor = [UIColor clearColor];
    
    // Register for reusable Collection View elements
    [_proofQuestionsCollectionView registerClass:[JWCTaskDescriptionCollectionViewCell class] forCellWithReuseIdentifier:REUSE_DESCRIPTION];
    [_proofQuestionsCollectionView registerClass:[JWCCollectionViewHeaderAddTask class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:REUSE_TASK_INFO_HEADER];
    [_proofQuestionsCollectionView registerClass:[JWCCollectionReusableFooterLabel class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:REUSE_FOOTER_LABEL];
    
    _proofQuestionsCollectionView.delegate = self;
    _proofQuestionsCollectionView.dataSource = self;
    
    // Setup keyboard dismissal gesture recognizer
    UITapGestureRecognizer *keyboardDismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCollectionView:)];
    [_proofQuestionsCollectionView addGestureRecognizer:keyboardDismiss];
    
    [[KGModal sharedInstance] showWithContentView:_proofQuestionsCollectionView];
}

#pragma mark - UICollectionViewDelegate/Datasource methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JWCTaskDescriptionCollectionViewCell *currentCell = [collectionView dequeueReusableCellWithReuseIdentifier:REUSE_DESCRIPTION forIndexPath:indexPath];
    
    if (indexPath.row < [[[JWCTaskManager sharedManager] pendingTask].proofQuestions count]) {
        currentCell.textViewDescription.text = [[[JWCTaskManager sharedManager] pendingTask].proofQuestions objectAtIndex:indexPath.row];
    } else {
        currentCell.textViewDescription.text = @"";
    }
    
    currentCell.textViewDescription.font = DEFAULT_FONT;
    currentCell.textViewDescription.delegate = self;
    
    return currentCell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        JWCCollectionViewHeaderAddTask *header = (JWCCollectionViewHeaderAddTask *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:REUSE_TASK_INFO_HEADER forIndexPath:indexPath];
        header.headerLabel.text = _proofQuestionsLabelText;
        header.headerLabel.textColor = [UIColor whiteColor];
        header.headerLabel.numberOfLines = 0;
        header.headerLabel.font = DEFAULT_FONT;
        return header;
    } else if (kind == UICollectionElementKindSectionFooter) {
        JWCCollectionReusableFooterLabel *footerLabelCell = (JWCCollectionReusableFooterLabel *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:REUSE_FOOTER_LABEL forIndexPath:indexPath];
        footerLabelCell.footerLabel.text = @"Questions saved when window closed. Can edit until task is submitted";
        footerLabelCell.footerLabel.font = DEFAULT_FONT;
        footerLabelCell.footerLabel.textColor = [UIColor whiteColor];
        return footerLabelCell;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(CGRectGetWidth(_proofQuestionsCollectionView.frame), 100);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return  CGSizeMake(CGRectGetWidth(_proofQuestionsCollectionView.frame), 90);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CGRectGetWidth(_proofQuestionsCollectionView.frame), 35);
}

#pragma mark - Gesture Recognizer Methods
- (void)tappedCollectionView:(UIGestureRecognizer *)tapGesture
{
    NSArray *indexPathsForVisibleItems = [_proofQuestionsCollectionView indexPathsForVisibleItems];
    for (NSIndexPath *currentIndexPath in indexPathsForVisibleItems) {
        UICollectionViewCell *currentCell = [_proofQuestionsCollectionView cellForItemAtIndexPath:currentIndexPath];
        for (UIView *subview in currentCell.subviews) {
            if ([subview isKindOfClass:[UITextField class]] ||
                [subview isKindOfClass:[UITextView class]]) {
                [subview resignFirstResponder];
            }
        }
    }
}

#pragma mark - TextView delegate methods
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    _selectedTextView = textView;
    return YES;
}

#pragma mark - Notification Center methods
- (void)modalDismissed:(id)sender
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSArray *visibleIndexPaths = [_proofQuestionsCollectionView indexPathsForVisibleItems];
    for (NSIndexPath *currentIndexPath in visibleIndexPaths) {
        JWCTaskDescriptionCollectionViewCell *currentCell = (JWCTaskDescriptionCollectionViewCell *)[_proofQuestionsCollectionView cellForItemAtIndexPath:currentIndexPath];
        
        if (currentIndexPath.row < [[[JWCTaskManager sharedManager] pendingTask].proofQuestions count])
        {
            [[[JWCTaskManager sharedManager] pendingTask].proofQuestions replaceObjectAtIndex:currentIndexPath.row withObject:currentCell.textViewDescription.text];
        } else {
            [[[JWCTaskManager sharedManager] pendingTask].proofQuestions addObject:currentCell.textViewDescription.text];
        }
    }
    //TODO: REMOVE AFTER TESTING
    NSLog(@"%@", [JWCTaskManager sharedManager].pendingTask.proofQuestions);
}

- (void)keyboardNotificationWillShow:(NSNotification *)note
{
    NSDictionary *userInfo = [note userInfo];
    
    NSValue *keyboardEndValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardEndFrame = keyboardEndValue.CGRectValue;
    
    CGFloat bottomOfSelectedTextField = CGRectGetMaxY(_selectedTextView.superview.frame);
    CGFloat keyboardEndHeight = CGRectGetHeight(keyboardEndFrame);
    
    if (bottomOfSelectedTextField >= keyboardEndHeight) {
        CGFloat difference = bottomOfSelectedTextField - keyboardEndHeight;
        _keyboardOffset = CGPointMake(0, difference);
        [_proofQuestionsCollectionView setContentOffset:_keyboardOffset animated:YES];
    }
    
}

- (void)keyboardNotificationDismissed:(NSNotification *)note
{
    CGPoint keyboardOffsetOpposite = CGPointMake(0, 0);
    [_proofQuestionsCollectionView setContentOffset:keyboardOffsetOpposite animated:YES];
}

@end
