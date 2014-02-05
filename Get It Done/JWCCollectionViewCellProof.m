//
//  JWCCollectionViewCellProof.m
//  Get It Done
//
//  Created by Jeff Schwab on 2/4/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCCollectionViewCellProof.h"

@implementation JWCCollectionViewCellProof

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

//- (void)drawRect:(CGRect)rect
//{
//
//}

#pragma mark - UIPickerViewDataSource Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 3;
}

#pragma mark - UIPickerViewDelegate Methods
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *pickerViewLabel = (UILabel *)view;
    
    if (!pickerViewLabel) {
        pickerViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        pickerViewLabel.font = DEFAULT_FONT;
        pickerViewLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    if (row == 0) {
        pickerViewLabel.text = @"Describe Finished Task";
    } else if (row == 1) {
        pickerViewLabel.text = @"Take a picture";
    } else if (row == 2) {
        pickerViewLabel.text = @"Answer question/s";
    }
    return pickerViewLabel;
}

#pragma mark - IBOutlets
- (IBAction)pressedProofPickerInfo:(UIButton *)sender
{
    NSString *selectedTitle;
    NSString *message;
    switch ([self.pickerViewProof selectedRowInComponent:0]) {
        case 0:
            selectedTitle = @"Describe Finished Task";
            message = @"When you've finished the task, write down a few sentences about it. Reflect on how it went, anything that was difficult, something you learned etc.";
            break;
        case 1:
            selectedTitle = @"Take a Picture";
            message = @"Take and upload a picture of something that proves you got it done.";
            break;
        case 2:
            selectedTitle = @"Answer question/s";
            message = @"Enter in some questions that can only be answered once you've finished the task. Then answer them when you've gotten it done.";
        default:
            break;
    }
    UIAlertView *proofInfoAlertView;
    
    if ([self.pickerViewProof selectedRowInComponent:0] == 2) {
        proofInfoAlertView = [[UIAlertView alloc] initWithTitle:selectedTitle
                                                        message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Submit questions", nil];
        [proofInfoAlertView setAlertViewStyle:UIAlertViewStylePlainTextInput];

    } else {
        proofInfoAlertView = [[UIAlertView alloc] initWithTitle:selectedTitle
                                                        message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    }
    
    [proofInfoAlertView show];
}

#pragma mark - UIAlertView Delegate 
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

@end
