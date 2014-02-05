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

@end
