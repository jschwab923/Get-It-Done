//
//  JWCTaskPartner.m
//  Get It Done
//
//  Created by Jeff Schwab on 2/5/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCTaskPartner.h"

@implementation JWCTaskPartner

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.emails = [aDecoder decodeObjectForKey:@"email"];
        self.phoneNumbers = [aDecoder decodeObjectForKey:@"phoneNumber"];
        self.partnerImage = [aDecoder decodeObjectForKey:@"partnerImage"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.emails forKey:@"email"];
    [aCoder encodeObject:self.phoneNumbers forKey:@"phoneNumber"];
    [aCoder encodeObject:self.partnerImage forKey:@"partnerImage"];
}

- (NSArray *)emails
{
    if (!_emails) {
        _emails = [NSArray new];
    }
    return _emails;
}

- (NSArray *)phoneNumbers
{
    if (!_phoneNumbers) {
        _phoneNumbers = [NSArray new];
    }
    return _phoneNumbers;
}

@end
