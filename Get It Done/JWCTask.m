//
//  JWCTask.m
//  Get It Done
//
//  Created by Jeff Schwab on 2/4/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCTask.h"
#import "JWCSubtask.h"

@implementation JWCTask

- (instancetype)init
{
    if (self = [super init]) {
        self.taskID = [NSUUID UUID];
    }
    return self;
}

- (NSMutableArray *)subTasks
{
    if (!_subTasks) {
        _subTasks = [NSMutableArray new];
    }
    return _subTasks;
}

- (NSMutableArray *)proofQuestions
{
    if (!_proofQuestions) {
        _proofQuestions = [NSMutableArray new];
    }
    return _proofQuestions;
}

- (NSMutableArray *)proofQuestionAnswers
{
    if (!_proofQuestionAnswers) {
        _proofQuestionAnswers = [NSMutableArray new];
    }
    return _proofQuestionAnswers;
}

- (JWCTaskPartner *)partner
{
    if (!_partner) {
        _partner = [JWCTaskPartner new];
    }
    return _partner;
}

- (BOOL)containsNilProperties
{
    for (JWCSubtask *currentSubtask in self.subTasks) {
        if (currentSubtask.percent < 0) {
            return YES;
        }
            
    }
    
    return
        self.title == nil ||
        self.taskDescription == nil ||
        self.proofType == nil ||
        self.subTasks == nil ||
        self.points <= 0;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.taskID = [aDecoder decodeObjectForKey:@"taskID"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.taskDescription = [aDecoder decodeObjectForKey:@"taskDescription"];
        self.proofType = [aDecoder decodeObjectForKey:@"proofType"];
        self.proofQuestions = [aDecoder decodeObjectForKey:@"proofQuestions"];
        self.proofDescribe = [aDecoder decodeObjectForKey:@"proofDescribe"];
        self.proofImage = [aDecoder decodeObjectForKey:@"proofImage"];
        self.start = [aDecoder decodeObjectForKey:@"start"];
        self.due = [aDecoder decodeObjectForKey:@"due"];
        self.subTasks = [aDecoder decodeObjectForKey:@"subTasks"];
        self.partner = [aDecoder decodeObjectForKey:@"partner"];
        self.points = [aDecoder decodeObjectForKey:@"points"];
        self.progressPoints = [aDecoder decodeObjectForKey:@"progressPoints"];
        self.numberOfTimesSubtasksChecked = [aDecoder decodeObjectForKey:@"numberOfTimesSubtasksChecked"];
        self.proofQuestionAnswers = [aDecoder decodeObjectForKey:@"proofQuestionAnswers"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.taskID forKey:@"taskID"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.taskDescription forKey:@"taskDescription"];
    [aCoder encodeObject:self.proofType forKey:@"proofType"];
    [aCoder encodeObject:self.proofQuestions forKey:@"proofQuestions"];
    [aCoder encodeObject:self.proofImage forKey:@"proofImage"];
    [aCoder encodeObject:self.proofDescribe forKey:@"proofDescribe"];
    [aCoder encodeObject:self.start forKey:@"start"];
    [aCoder encodeObject:self.due forKey:@"due"];
    [aCoder encodeObject:self.subTasks forKey:@"subTasks"];
    [aCoder encodeObject:self.partner forKey:@"partner"];
    [aCoder encodeObject:self.points forKey:@"points"];
    [aCoder encodeObject:self.progressPoints forKey:@"progressPoints"];
    [aCoder encodeObject:self.numberOfTimesSubtasksChecked forKey:@"numberOfTimesSubtasksChecked"];
    [aCoder encodeObject:self.proofQuestionAnswers forKey:@"proofQuestionAnswers"];
}

- (void)setProofType:(NSString *)proofType
{
    _proofType = proofType;
    if ([proofType isEqualToString:PROOF_TYPE_QUESTIONS]) {
        if (!self.proofQuestions) {
            self.proofQuestions = [[NSMutableArray alloc] init];
        }
    } else if ([proofType isEqualToString:PROOF_TYPE_PICTURE]) {
        if (!self.proofImage) {
            self.proofImage = [[UIImage alloc] init];
        }
    } else if ([proofType isEqualToString:PROOF_TYPE_DESCRIBE]) {
        if (!self.proofDescribe) {
            self.proofDescribe = [[NSString alloc] init];
        }
    }
    
}

- (NSInteger)numberOfSubtasksDone
{
    NSInteger subtasksDone = 0;
    for (JWCSubtask *currentSubtask in self.subTasks) {
        if (currentSubtask.done) {
            subtasksDone++;
        }
    }
    return subtasksDone;
}

@end
