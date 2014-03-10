//
//  JWCAddTaskCollectionViewFooter.m
//  Get It Done
//
//  Created by Jeff Schwab on 2/4/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCAddSubtaskCollectionViewFooter.h"
#import "JWCCollectionViewHeaderAddTask.h"
#import "JWCReusableFooterAddSubtaskModalView.h"
#import "JWCCollectionViewCellTitlePoints.h"
#import "JWCTaskManager.h"
#import "JWCSubtask.h"
#import "KGModal.h"

@interface JWCAddSubtaskCollectionViewFooter ()
{
    UICollectionView *_subtasksCollectionView;
    UITextField *_selectedTextField;
    CGPoint _keyboardOffset;
    
    NSInteger _addSubtaskModalButtonPressedCount;
    
    NSInteger _totalPercentLeft;
    UILabel *_labelPercentLeft;
    
    JWCReusableFooterAddSubtaskModalView *_currentFooterCell;
    
    NSIndexPath *_selectedIndexPath;
}


@end

@implementation JWCAddSubtaskCollectionViewFooter

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)drawRect:(CGRect)rect
{
    UILabel *addSubtaskLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(rect)-130, 0,
                                                                         CGRectGetWidth(rect)/3, CGRectGetHeight(rect))];
    addSubtaskLabel.backgroundColor = [UIColor clearColor];
    addSubtaskLabel.text = @"Add Subtask *required";
    addSubtaskLabel.numberOfLines = 0;
    addSubtaskLabel.textColor = DEFAULT_TEXT_COLOR;
    addSubtaskLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:18];
    [self addSubview:addSubtaskLabel];
    
    UIButton *addSubtaskButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    addSubtaskButton.center = CGPointMake(CGRectGetWidth(rect)-20, CGRectGetHeight(rect)/2);
    
    addSubtaskButton.contentMode = UIViewContentModeScaleToFill;
    [addSubtaskButton setImage:[UIImage imageNamed:@"Add"] forState:UIControlStateNormal];
    addSubtaskButton.backgroundColor = [UIColor clearColor];
    addSubtaskButton.tintColor = DEFAULT_TEXT_COLOR;
    [self addSubview:addSubtaskButton];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedAddSubtask:)];
    [addSubtaskButton addTarget:self action:@selector(tappedAddSubtask:) forControlEvents:UIControlEventTouchUpInside];
    [self addGestureRecognizer:tapRecognizer];
}

- (void)tappedAddSubtask:(id)tapGesture
{
    if ([tapGesture isKindOfClass:[UITapGestureRecognizer class]]) {
        CGPoint tappedLocation = [tapGesture locationInView:self];
        if ((tappedLocation.x < CGRectGetWidth(self.frame)/2+5) &&
            tappedLocation.y < CGRectGetMaxY(self.frame)-50) {
            return;
        }
    }

    
    UICollectionViewFlowLayout *contactLayout = [[UICollectionViewFlowLayout alloc] init];
    _subtasksCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 275, 300) collectionViewLayout:contactLayout];
    _subtasksCollectionView.backgroundColor = [UIColor clearColor];
    
    _subtasksCollectionView.delegate = self;
    _subtasksCollectionView.dataSource = self;
    
    // Register reusable collection view cells and supplementary views
    [_subtasksCollectionView registerClass:[JWCCollectionViewHeaderAddTask class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:REUSE_TASK_INFO_HEADER];
    [_subtasksCollectionView registerClass:[JWCReusableFooterAddSubtaskModalView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"AddSubtaskModalFooter"];
    [_subtasksCollectionView registerClass:[JWCCollectionViewCellTitlePoints class]
                   forCellWithReuseIdentifier:REUSE_TITLE_POINTS];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCollectionView:)];
    [_subtasksCollectionView addGestureRecognizer:tapGestureRecognizer];
    
    
    // Setup notification center observers for keyboard showing and modal view being dismissed
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardNotificationWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    _addSubtaskModalButtonPressedCount = 1;
    _labelPercentLeft = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 50)];
    _labelPercentLeft.textAlignment = NSTextAlignmentCenter;
    
    NSInteger tempTotalPercent = 100;
    for (JWCSubtask *subtask in [JWCTaskManager sharedManager].pendingTask.subTasks) {
         tempTotalPercent -= subtask.percent.integerValue;
    }
    _totalPercentLeft = tempTotalPercent;
    
    [[KGModal sharedInstance] showWithContentView:_subtasksCollectionView andAnimated:YES];
    
}

#pragma mark - UICollectionViewDataSource/Delegate methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ((100-[self currentTotalPercent]) == 0) {
        return [[JWCTaskManager sharedManager].pendingTask.subTasks count];
    } else if ([[JWCTaskManager sharedManager].pendingTask.subTasks count]) {
        return [[JWCTaskManager sharedManager].pendingTask.subTasks count] + 1;
    }
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Setup toolbar for keyboard dismissal
    UIToolbar *doneToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    doneToolbar.barStyle = UIBarStyleBlackTranslucent;
    doneToolbar.items = [NSArray arrayWithObjects:
                         [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyboardWithApplyButton)],
                         nil];
    [doneToolbar sizeToFit];
    
    JWCCollectionViewCellTitlePoints *currentCell = (JWCCollectionViewCellTitlePoints *)[collectionView dequeueReusableCellWithReuseIdentifier:REUSE_TITLE_POINTS forIndexPath:indexPath];
    
    currentCell.title.placeholder = @"Subtask";
    currentCell.points.placeholder = @"%";
    
    currentCell.title.delegate = self;
    currentCell.points.delegate = self;
    
    currentCell.title.backgroundColor = [UIColor colorWithWhite:1.0 alpha:.8];
    currentCell.points.backgroundColor = [UIColor colorWithWhite:1.0 alpha:.8];
    
    currentCell.title.inputAccessoryView = doneToolbar;
    currentCell.points.inputAccessoryView = doneToolbar;
    
    if (indexPath.row < [[[JWCTaskManager sharedManager] pendingTask].subTasks count]) {
        JWCSubtask *currentSubtask = (JWCSubtask *)[[JWCTaskManager sharedManager] pendingTask].subTasks[indexPath.row];
        currentCell.title.text = currentSubtask.subTaskDescription;
        currentCell.points.text = [NSString stringWithFormat:@"%i", currentSubtask.percent.intValue];
    }
    return currentCell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *currentView;
    if (kind == UICollectionElementKindSectionHeader) {
        currentView = (JWCCollectionViewHeaderAddTask *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:REUSE_TASK_INFO_HEADER forIndexPath:indexPath];
        JWCCollectionViewHeaderAddTask *tempView = (JWCCollectionViewHeaderAddTask *)currentView;
        tempView.headerLabel.text = @"Description  |  % of Total";
        tempView.headerLabel.textColor = [UIColor whiteColor];
    } else if (kind == UICollectionElementKindSectionFooter) {
        currentView = (JWCReusableFooterAddSubtaskModalView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"AddSubtaskModalFooter" forIndexPath:indexPath];
        JWCReusableFooterAddSubtaskModalView *tempView = (JWCReusableFooterAddSubtaskModalView *)currentView;
        
        // Setup member variable so add button can be diabled when 100% reached
        _currentFooterCell = tempView;
        
        [_subtasksCollectionView addSubview:_labelPercentLeft];
        _labelPercentLeft.textColor = DEFAULT_TEXT_COLOR;
        _labelPercentLeft.frame = CGRectMake(0, CGRectGetMinY(currentView.frame) , 200, CGRectGetHeight(currentView.frame));
        _labelPercentLeft.text = [NSString stringWithFormat:@"Percent Left: %lu\n*Subtask percents must add up to 100",(long)(100 - [self currentTotalPercent])];
        _labelPercentLeft.numberOfLines = 0;
        
        [tempView.addButton addTarget:self
                               action:@selector(pressedAddSubtaskModalButton:)
                     forControlEvents:UIControlEventTouchUpInside];
        if (_totalPercentLeft < 1 || _totalPercentLeft == 100) {
            _currentFooterCell.addButton.enabled = NO;
        }
        
    }
    return currentView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CGRectGetWidth(collectionView.frame), 50);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(CGRectGetWidth(collectionView.frame), 50);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(CGRectGetWidth(collectionView.frame), 80);
}

#pragma mark - UITextFieldDelegate Methods
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _currentFooterCell.addButton.enabled = NO;
    _selectedTextField = textField;
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *attemptedEditPoints = [NSString stringWithFormat:@"%@%@", textField.text, string];
    if (textField.tag == TAG_POINTS_TEXTVIEW && attemptedEditPoints.length > textField.text.length) {
        NSRegularExpression *regularExpression = [[NSRegularExpression alloc] initWithPattern:@"[0-9]" options:NSRegularExpressionCaseInsensitive error:nil];
        
        NSString *regex = [regularExpression stringByReplacingMatchesInString:attemptedEditPoints options:0 range:NSMakeRange(0, attemptedEditPoints.length) withTemplate:@""];
        
        if((attemptedEditPoints.integerValue > _totalPercentLeft)
           || ![regex isEqualToString:@""])
        {
            regex = nil;
            return NO;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    NSMutableArray *pendingSubtasks = [[JWCTaskManager sharedManager] pendingTask].subTasks;
    NSArray *visibleIndexPaths = [_subtasksCollectionView indexPathsForVisibleItems];
    
    BOOL textFieldEmpty = NO;
    
    for (NSIndexPath *currentIndexPath in visibleIndexPaths) {
        JWCCollectionViewCellTitlePoints *currentCell = (JWCCollectionViewCellTitlePoints *)[_subtasksCollectionView cellForItemAtIndexPath:currentIndexPath];
        
        if ([currentCell.title.text isEqualToString:@""] ||
            [currentCell.points.text isEqualToString:@""])
        {
            textFieldEmpty = YES;
        }
        
        if (![currentCell.title.text isEqualToString:@""] &&
            ![currentCell.points.text isEqualToString:@""]) {
            if (currentIndexPath.row < [pendingSubtasks count]) {
                JWCSubtask *editedSubtask = (JWCSubtask *)pendingSubtasks[currentIndexPath.row];
                editedSubtask.subTaskDescription = currentCell.title.text;
                editedSubtask.percent = [NSNumber numberWithInt:currentCell.points.text.intValue];
            } else {
                JWCSubtask *newSubtask = [[JWCSubtask alloc] init];
                newSubtask.subTaskDescription = currentCell.title.text;
                newSubtask.percent = [NSNumber numberWithInteger:currentCell.points.text.integerValue];
                [pendingSubtasks addObject:newSubtask];
            }
        }
    }
    
    NSInteger currentTotalPercent = [self currentTotalPercent];
    if (currentTotalPercent == 100) {
        _currentFooterCell.addButton.enabled = NO;
        _labelPercentLeft.text = [NSString stringWithFormat:@"Percent left: %lu\n*Subtask percents must add up to 100", (long)(100 - currentTotalPercent)];
        [KGModal sharedInstance].tapOutsideToDismiss = YES;
        [KGModal sharedInstance].closeButtonType = KGModalCloseButtonTypeLeft;
    } else if (currentTotalPercent != 0){
        if (!textFieldEmpty) {
            [KGModal sharedInstance].tapOutsideToDismiss = YES;
            [KGModal sharedInstance].closeButtonType = KGModalCloseButtonTypeLeft;
            _currentFooterCell.addButton.enabled = YES;
        }
        _labelPercentLeft.text = [NSString stringWithFormat:@"Percent left: %lu\n*Subtask percents must add up to 100", (long)(100 - currentTotalPercent)];
    }
    
    return YES;
}

#pragma mark - Gesture Recognizer Methods
- (void)tappedCollectionView:(UIGestureRecognizer *)tapGesture
{
    NSArray *indexPathsForVisibleItems = [_subtasksCollectionView indexPathsForVisibleItems];
    for (NSIndexPath *currentIndexPath in indexPathsForVisibleItems) {
        UICollectionViewCell *currentCell = [_subtasksCollectionView cellForItemAtIndexPath:currentIndexPath];
        for (UIView *subview in currentCell.subviews) {
            if ([subview isKindOfClass:[UITextField class]] ||
                [subview isKindOfClass:[UITextView class]]) {
                [subview resignFirstResponder];
            }
        }
    }
}

#pragma mark - Notification Center Methods
- (void)keyboardNotificationWillShow:(NSNotification *)note
{
    JWCCollectionViewCellTitlePoints *selectedCell;
    for (NSIndexPath *ip in [_subtasksCollectionView indexPathsForVisibleItems]) {
        JWCCollectionViewCellTitlePoints *cell = (JWCCollectionViewCellTitlePoints *)[_subtasksCollectionView cellForItemAtIndexPath:ip];
        if (cell.title == _selectedTextField) {
            selectedCell = cell;
        }
    }
    
    NSDictionary *userInfo = [note userInfo];
    
    
    NSValue *keyboardEndValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardEndFrame = keyboardEndValue.CGRectValue;
    
    CGFloat bottomCurrentFooter = CGRectGetMaxY(_currentFooterCell.frame);
 
    CGRect convertedKeyboardRect = [_subtasksCollectionView convertRect:keyboardEndFrame fromView:self.superview];
    CGFloat convertedKeyboardY = CGRectGetMinY(convertedKeyboardRect) - 50;
    
    CGRect convertedSelectedTextFieldRect = [_subtasksCollectionView convertRect:_selectedTextField.frame fromView:selectedCell];
    CGFloat convertedTextFieldY = CGRectGetMaxY(convertedSelectedTextFieldRect);
    
    if (convertedTextFieldY >= convertedKeyboardY && bottomCurrentFooter >= convertedKeyboardY) {
        CGFloat difference = bottomCurrentFooter - convertedKeyboardY;
        _keyboardOffset = CGPointMake(0, difference+30+_subtasksCollectionView.contentOffset.y);
        [_subtasksCollectionView setContentOffset:_keyboardOffset animated:YES];
    }
}

- (void)dismissKeyboardWithApplyButton
{
    if (_selectedTextField) {
        [_selectedTextField endEditing:YES];
    }
}

#pragma mark - Touch Handling
- (void)pressedAddSubtaskModalButton:(UIButton *)button
{
    NSInteger tempTotalPercent = 100;
    for (JWCSubtask *subtask in [JWCTaskManager sharedManager].pendingTask.subTasks) {
        tempTotalPercent -= subtask.percent.integerValue;
    }
    _totalPercentLeft = tempTotalPercent;
    
    _addSubtaskModalButtonPressedCount++;
    [_subtasksCollectionView reloadData];
}

#pragma mark - Convenience Methods
- (NSInteger)currentTotalPercent
{
    NSInteger totalPercent = 0;
    for (JWCSubtask *subtask in [JWCTaskManager sharedManager].pendingTask.subTasks) {
        totalPercent += subtask.percent.integerValue;
    }
    
    return totalPercent;
}

@end
