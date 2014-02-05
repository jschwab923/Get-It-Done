//
//  JWCContactsLoader.h
//  Get It Done
//
//  Created by Jeff Schwab on 2/5/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JWCContactsLoader : NSObject

@property (nonatomic) NSArray *contacts;

+ (JWCContactsLoader *)sharedController;

- (NSArray *)arrayOfPeopleWithName:(NSString *)name;

@end
