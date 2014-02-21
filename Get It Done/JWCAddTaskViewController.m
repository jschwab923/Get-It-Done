//
//  JWCAddTaskViewController.m
//  Get It Done
//
//  Created by Jeff Schwab on 1/30/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCTask.h"
#import "JWCTaskManager.h"
#import "JWCContactsLoader.h"

#import "JWCAddTaskViewController.h"
#import "JWCAddSubtaskCollectionViewFooter.h"
#import "JWCCollectionViewHeaderAddTask.h"
#import "JWCTaskDescriptionCollectionViewCell.h"
#import "JWCCollectionViewCellTitlePoints.h"
#import "JWCCollectionViewCellProof.h"
#import "JWCCollectionViewFooterAddPartner.h"

#import "KGModal.h"

@interface JWCAddTaskViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageViewBackground;

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
    
    if (CGRectGetHeight([UIScreen mainScreen].bounds) == 568) {
        self.imageViewBackground.image = [UIImage imageNamed:PORTRAIT_IMAGE];
    } else {
        self.imageViewBackground.image = [UIImage imageNamed:PORTRAIT_IMAGE4];
    }
    
    // Setup tap recognizer for dismissing keyboard
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCollectionView:)];
    
    [self.collectionViewAddTask addGestureRecognizer:tapGesture];
    
    // Register collection view supplementary views
    [self.collectionViewAddTask registerClass:[JWCCollectionViewHeaderAddTask class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:REUSE_TASK_INFO_HEADER];
     [self.collectionViewAddTask registerClass:[JWCAddSubtaskCollectionViewFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:REUSE_ADD_SUBTASK_FOOTER];
    [self.collectionViewAddTask registerClass:[JWCCollectionViewFooterAddPartner class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:REUSE_PARTNER_FOOTER];
    
    // Register collection view cells
    [self.collectionViewAddTask registerClass:[JWCCollectionViewCellTitlePoints class] forCellWithReuseIdentifier:REUSE_TITLE_POINTS];
    [self.collectionViewAddTask registerClass:[JWCTaskDescriptionCollectionViewCell class] forCellWithReuseIdentifier:REUSE_DESCRIPTION];
    
    // Load contacts array for use when Add Contact is pressed
    if (![JWCContactsLoader sharedController].contacts) {
        [[JWCContactsLoader sharedController] getContactsArray];
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    JWCCollectionViewCellProof *proofCell = (JWCCollectionViewCellProof *)[self.collectionViewAddTask cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    
    [proofCell.pickerViewProof selectRow:1 inComponent:0 animated:YES];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.collectionViewAddTask.collectionViewLayout invalidateLayout];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [JWCTaskManager sharedManager].pendingTask = [[JWCTask alloc] init];
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

#pragma mark - UICollectionViewDelegate Methods
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                return CGSizeMake(CGRectGetWidth(collectionView.frame), 30);
                break;
            }
            case 1:
            {
                return CGSizeMake(CGRectGetWidth(collectionView.frame), 40);
                break;
            }
            default:
                break;
        }
    } else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                return CGSizeMake(CGRectGetWidth(collectionView.frame), 80);
                break;
            default:
                break;
        }
    }
    return CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), 50);
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), 40);
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), 80);
    } else if (section == 1) {
        return CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), 80);
    }
    return CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), 50);
}

@end
