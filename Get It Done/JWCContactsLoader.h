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

/**
 * Method to search and sort an array of contacts based on a string
 * @param name Name string to search the list of contacts for
 * @return Returns an array of people with names that 'begin with' name
 **/
- (NSArray *)arrayOfPeopleWithName:(NSString *)name;

- (void)getContactsArray;

@end
