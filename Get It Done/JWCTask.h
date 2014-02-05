//
//  JWCTask.h
//  Get It Done
//
//  Created by Jeff Schwab on 2/4/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JWCTask : NSObject

@property (nonatomic) NSUUID *taskID;

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *description;
@property (nonatomic) NSString *proofType;

// Depends on proof type - NSString/UIImage. Maybe Video
@property (nonatomic) id proof;

@property (nonatomic) NSDate *start;
@property (nonatomic) NSDate *due;

@property (nonatomic) NSMutableArray *subTasks;

@end
