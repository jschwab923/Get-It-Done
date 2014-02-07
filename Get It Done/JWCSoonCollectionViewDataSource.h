//
//  JWCCollectionViewDataSource.h
//  Get It Done
//
//  Created by Jeff Schwab on 1/31/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CollectionScrollViewDelegate <NSObject>

@optional
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

@end

@interface JWCSoonCollectionViewDataSource : NSObject
<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, unsafe_unretained) IBOutlet id <CollectionScrollViewDelegate> delegate;

@end
