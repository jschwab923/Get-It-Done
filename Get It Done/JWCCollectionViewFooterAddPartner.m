//
//  JWCCollectionViewFooterPartner.m
//  Get It Done
//
//  Created by Jeff Schwab on 2/4/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCCollectionViewFooterAddPartner.h"
#import "JWCCollectionViewFooterContactTypeChooser.h"
#import "JWCSearchBar.h"
#import "JWCCollectionViewCellContact.h"
#import "JWCTaskPartner.h"
#import "JWCTaskManager.h"
#import "JWCTask.h"

#import "JWCContactsLoader.h"
#import "APContact.h"
#import "KGModal.h"

@interface JWCCollectionViewFooterAddPartner ()
{
    UITapGestureRecognizer *_buttonTouched;
    UICollectionView *_contactsCollectionView;
    JWCSearchBar *_contactsSearchBar;
    
    JWCCollectionViewFooterContactTypeChooser *_currentFooter;
}

@property (strong, nonatomic) APContact *selectedContact;
@end

@implementation JWCCollectionViewFooterAddPartner

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    self.partnerLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(rect)-10, 0, CGRectGetWidth(rect)*.6, CGRectGetHeight(rect))];
    
    self.partnerLabel.text = @"Who will help you?";
    self.partnerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:18];
    self.partnerLabel.textColor = DEFAULT_TEXT_COLOR;
    self.partnerLabel.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.partnerLabel];
    
    self.partnerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    self.partnerImage.center = CGPointMake(CGRectGetWidth(rect)-20, CGRectGetMidY(rect));
    
    self.partnerImage.contentMode = UIViewContentModeScaleAspectFill;
    self.partnerImage.image = [UIImage imageNamed:@"Group"];
    
    _buttonTouched = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                             action:@selector(pressedAddPartner:)];
    
    [self addGestureRecognizer:_buttonTouched];
    
    [self addSubview:self.partnerImage];

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Gesture Recognizer Methods
- (void)pressedAddPartner:(UIGestureRecognizer *)tapRecognizer
{
    
    UIView *contactsContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 275, 300)];
    
    UICollectionViewFlowLayout *contactLayout = [[UICollectionViewFlowLayout alloc] init];
    _contactsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 40, CGRectGetWidth(contactsContainerView.frame), CGRectGetHeight(contactsContainerView.frame)-40) collectionViewLayout:contactLayout];;
    
    _contactsCollectionView.backgroundColor = [UIColor clearColor];
    
    // Register classes for reuse
    [_contactsCollectionView registerClass:[JWCCollectionViewCellContact class] forCellWithReuseIdentifier:@"ContactsCell"];
//    [_contactsCollectionView registerClass:[JWCCollectionViewFooterContactTypeChooser class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"ContactsTypeChooserCell"];

    _contactsCollectionView.dataSource = self;
    _contactsCollectionView.delegate = self;
    
    _contactsSearchBar = [[JWCSearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(contactsContainerView.frame), 40)];
    _contactsSearchBar.barTintColor = [UIColor colorWithWhite:1.0 alpha:.8];
    _contactsSearchBar.delegate = self;
    
    [contactsContainerView addSubview:_contactsSearchBar];
    [contactsContainerView addSubview:_contactsCollectionView];
    
    
    // Register for KGModal view dismissed
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(kgModalWillDimissNotification:)
                                                 name:KGModalWillHideNotification object:nil];
    
    [[KGModal sharedInstance] showWithContentView:contactsContainerView andAnimated:YES];
}

- (void)prepareForReuse
{
    self.partnerImage.image = nil;
    [self.partnerLabel removeGestureRecognizer:_buttonTouched];
}

#pragma mark - UICollectionViewDataSource Methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.contactsWithName count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    JWCCollectionViewCellContact *contactCell = (JWCCollectionViewCellContact *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ContactsCell" forIndexPath:indexPath];
    
    APContact *currentContact = (APContact *)self.contactsWithName[indexPath.row];
    
    if (currentContact.thumbnail) {
        contactCell.contactsImage.image = currentContact.thumbnail;
    } else {
        contactCell.labelName.text = [NSString stringWithFormat:@"%@ %@", currentContact.firstName, currentContact.lastName];
    }
    
    return contactCell;
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionReusableView *reusableView;
//    if (kind == UICollectionElementKindSectionFooter) {
//        JWCCollectionViewFooterContactTypeChooser *footerCell = (JWCCollectionViewFooterContactTypeChooser *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"ContactsTypeChooserCell" forIndexPath:indexPath];
//        reusableView = footerCell;
//        
//      _currentFooter = footerCell;
//    }
//    return reusableView;
//}

#pragma mark - UICollectionViewDelegate Methods
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(80, 65);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(CGRectGetWidth(collectionView.frame), 50);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedContact = _contactsWithName[indexPath.row];
    JWCCollectionViewCellContact *selectedCell = (JWCCollectionViewCellContact *)[collectionView cellForItemAtIndexPath:indexPath];
    if (selectedCell.labelName.textColor == [UIColor whiteColor]) {
        selectedCell.labelName.textColor = [UIColor darkBlueColor];
    } else {
        selectedCell.labelName.textColor = [UIColor whiteColor];
    }
}


#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.contactsWithName = [[JWCContactsLoader sharedController] arrayOfPeopleWithName:searchText];
    [_contactsCollectionView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [_contactsSearchBar endEditing:YES];
}

#pragma mark - UIScrollViewDelegate methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_contactsSearchBar endEditing:YES];
}

#pragma mark - Notification Center methods
- (void)kgModalWillDimissNotification:(id)sender
{
    JWCTaskPartner *taskPartner = [JWCTaskPartner new];
    taskPartner.name = [NSString stringWithFormat:@"%@ %@", _selectedContact.firstName, _selectedContact.lastName];
    taskPartner.phoneNumbers = _selectedContact.phones;
    taskPartner.emails = _selectedContact.emails;
    taskPartner.partnerImage = _selectedContact.thumbnail ?: _selectedContact.photo;
    
    [JWCTaskManager sharedManager].pendingTask.partner = taskPartner;
}

@end
