//
//  JWCTaskPartner.h
//  Get It Done
//
//  Created by Jeff Schwab on 2/5/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JWCTaskPartner : NSObject
<NSCoding>

@property (nonatomic) NSString *name;
@property (nonatomic) NSArray *emails;
@property (nonatomic) NSArray *phoneNumbers;
@property (nonatomic) UIImage *partnerImage;

@end
