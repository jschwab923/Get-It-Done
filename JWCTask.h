//
//  JWCTask.h
//  Get It Done
//
//  Created by Jeff Schwab on 1/31/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JWCTask : NSObject

@property (nonatomic) NSUUID *taskID;

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *description;
@property (nonatomic) NSString *proofType;

// Either NSString or UIImage - depends on the proofType
@property (nonatomic) id proof;

@end
