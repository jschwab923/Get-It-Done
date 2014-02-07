//
//  JWCAddTaskViewController.m
//  Get It Done
//
//  Created by Jeff Schwab on 1/30/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCTask.h"
#import "JWCTaskManager.h"

#import "JWCAddTaskViewController.h"
#import "JWCAddSubtaskCollectionViewFooter.h"
#import "JWCCollectionViewHeaderAddTask.h"
#import "JWCTaskDescriptionCollectionViewCell.h"
#import "JWCCollectionViewCellTitlePoints.h"
#import "JWCAddTaskCollectionViewDataSource.h"
#import "JWCCollectionViewCellProof.h"
#import "JWCCollectionViewFooterPartner.h"

#import "KGModal.h"

@interface JWCAddTaskViewController ()

@end

@implementation JWCAddTaskViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Setup tap recognizer for dismissing keyboard
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self 
action:@selector(tappedCollectionView:)];
    
    [self.collectionViewAddTask addGestureRecognizer:tapGesture];
    
    // Register collection view supplementary views
    [self.collectionViewAddTask registerClass:[JWCCollectionViewHeaderAddTask class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:REUSE_TASK_INFO_HEADER];
     [self.collectionViewAddTask registerClass:[JWCAddSubtaskCollectionViewFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:REUSE_ADD_SUBTASK_FOOTER];
    [self.collectionViewAddTask registerClass:[JWCCollectionViewFooterPartner class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:REUSE_PARTNER_FOOTER];
    
    // Register collection view cells
    [self.collectionViewAddTask registerClass:[JWCCollectionViewCellTitlePoints class] forCellWithReuseIdentifier:REUSE_TITLE_POINTS];
    [self.collectionViewAddTask registerClass:[JWCTaskDescriptionCollectionViewCell class] forCellWithReuseIdentifier:REUSE_DESCRIPTION];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    JWCCollectionViewCellProof *proofCell = (JWCCollectionViewCellProof *)[self.collectionViewAddTask cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    
    [proofCell.pickerViewProof selectRow:1 inComponent:0 animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)pressedAddButton:(UIBarButtonItem *)sender
{
    UILabel *confirmationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    confirmationLabel.numberOfLines = 0;
    confirmationLabel.center = self.view.center;
    confirmationLabel.font = DEFAULT_FONT;
    CGSize fontSize = CGSizeMake(225, MAXFLOAT);
    confirmationLabel.textColor = [UIColor whiteColor];
    
   if ([[[JWCTaskManager sharedManager] pendingTask] containsNilProperties]) {
        confirmationLabel.text = @"Oops! Looks like something didn't get filled out.";
        CGRect boundingRect = [confirmationLabel.text
                               boundingRectWithSize:fontSize
                               options:NSStringDrawingUsesLineFragmentOrigin
                               attributes:[NSDictionary dictionaryWithObjectsAndKeys:confirmationLabel.font, NSFontAttributeName, nil] context:nil];
        CGRect roundedSizeFrame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds)*.8, ceil(boundingRect.size.height)+15);
        confirmationLabel.frame = roundedSizeFrame;
        [[KGModal sharedInstance] showWithContentView:confirmationLabel];
        return;
    }
    
    NSInteger oldTaskCount = [[[JWCTaskManager sharedManager] tasks] count];
    
    [[JWCTaskManager sharedManager] commitPendingTask];
    
    NSInteger newTaskCount = [[[JWCTaskManager sharedManager] tasks] count];
    
    if (newTaskCount == oldTaskCount+1) {
        confirmationLabel.text = @"Successfully Created New Task. Get it done!";
        CGRect boundingRect = [confirmationLabel.text
                               boundingRectWithSize:fontSize
                               options:NSStringDrawingUsesLineFragmentOrigin
                               attributes:[NSDictionary dictionaryWithObjectsAndKeys:confirmationLabel.font, NSFontAttributeName, nil] context:nil];
        CGRect roundedSizeFrame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds)*.8, ceil(boundingRect.size.height)+15);
        confirmationLabel.frame = roundedSizeFrame;
        [[KGModal sharedInstance] showWithContentView:confirmationLabel];
    } else {
        confirmationLabel.text = @"Pending task updated. Press back to commit to getting it done!";
        CGRect boundingRect = [confirmationLabel.text
                               boundingRectWithSize:fontSize
                               options:NSStringDrawingUsesLineFragmentOrigin
                               attributes:[NSDictionary dictionaryWithObjectsAndKeys:confirmationLabel.font, NSFontAttributeName, nil] context:nil];
        CGRect roundedSizeFrame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds)*.8, ceil(boundingRect.size.height)+15);
        confirmationLabel.frame = roundedSizeFrame;
        [[KGModal sharedInstance] showWithContentView:confirmationLabel];
    }
}

#pragma mark - Gesture Recognizer Methods
- (void)tappedCollectionView:(UIGestureRecognizer *)tapGesture
{
    NSArray *indexPathsForVisibleItems = [self.collectionViewAddTask indexPathsForVisibleItems];
    for (NSIndexPath *currentIndexPath in indexPathsForVisibleItems) {
        UICollectionViewCell *currentCell = [self.collectionViewAddTask cellForItemAtIndexPath:currentIndexPath];
        for (UIView *subview in currentCell.subviews) {
            [subview resignFirstResponder];
        }
    }
}

#pragma mark - Convenience Methods
//- (void)traverseCollectionViewAndSaveInfo
//{
//    NSArray *indexPathsForVisibleItems = [self.collectionViewAddTask indexPathsForVisibleItems];
//    for (NSIndexPath *currentIndexPath in indexPathsForVisibleItems) {
//        UICollectionViewCell *currentCell = [self.collectionViewAddTask cellForItemAtIndexPath:currentIndexPath];
//        for (UIView *subview in currentCell.subviews) {
//            switch (subview.tag) {
//                case TAG_TITLE_TEXTVIEW:
//                {
//                    UITextView *temp1 = (UITextView *)subview;
//                    [[JWCTaskManager sharedManager] pendingTask].title = temp1.text;
//                    break;
//                }
//                case TAG_POINTS_TEXTVIEW:
//                {
//                    UITextView *temp2 = (UITextView *)subview;
//                    [[JWCTaskManager sharedManager] pendingTask].points = [NSNumber numberWithInt:temp2.text.intValue];;
//                    break;
//                }
//                case TAG_PROOF_PICKER:
//                {
//                    UIPickerView *tempPicker = (UIPickerView *)subview;
//                    UILabel *pickerLabel = (UILabel *)[tempPicker viewForRow:[tempPicker selectedRowInComponent:0] forComponent:0];
//                    [[[JWCTaskManager sharedManager] pendingTask] setProofType:pickerLabel.text];
//                    break;
//                }
//                case TAG_DESCRIPTION_TEXTFIELD:
//                {
//                    UITextField *tempDescription = (UITextField *)subview;
//                    [[JWCTaskManager sharedManager] pendingTask].taskDescription = tempDescription.text;
//                }
//                default:
//                    break;
//            }
//        }
//    }
//}

@end
