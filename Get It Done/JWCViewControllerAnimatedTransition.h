//
//  JWCViewControllerAnimatedTransition.h
//  Get It Done
//
//  Created by Jeff Schwab on 1/31/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JWCViewControllerAnimatedTransition : NSObject
<UIViewControllerAnimatedTransitioning>

@property (nonatomic) BOOL presenting;

@end
