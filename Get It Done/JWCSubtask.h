//
//  JWCSubtask.h
//  Get It Done
//
//  Created by Jeff Schwab on 2/5/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JWCSubtask : NSObject <NSCoding>
@property (nonatomic) NSString *subTaskDescription;
@property (nonatomic) NSNumber *percent;

@property (nonatomic) NSInteger done;
@end
