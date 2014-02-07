//
//  JWCContactsLoader.m
//  Get It Done
//
//  Created by Jeff Schwab on 2/5/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCContactsLoader.h"
#import "APAddressBook.h"



@implementation JWCContactsLoader

+ (JWCContactsLoader *)sharedController
{
    static JWCContactsLoader *sharedController = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedController = [[self alloc] init];
    });
    
    return sharedController;
}

- (void)getContactsArray
{
    APAddressBook *addressBook = [[APAddressBook alloc] init];
    [addressBook loadContacts:^(NSArray *contacts, NSError *error) {
        if (!error) {
            self.contacts = contacts;
        } else {
            self.contacts = nil;
        }
    }];
}

//- (NSArray *)arrayOfPeopleWithName:(NSString *)name
//{
//    
//}

@end
