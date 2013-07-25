//
//  MBAddExcepVC.m
//  KichenCalender
//
//  Created by Swapnil Takalkar on 7/25/13.
//  Copyright (c) 2013 mobi. All rights reserved.
//

#import "MBAddExcepVC.h"

#define FRMTXTTAG 100
#define TOTXTTAG 200

@interface MBAddExcepVC ()

@end

@implementation MBAddExcepVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.stepper setStepValue:0.25];
    [self.frmTxt setTag:FRMTXTTAG];
    [self.toTxt setTag:TOTXTTAG];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)qtyChanged:(UIStepper *)sender
{
    [self.qtylbl setText:[NSString stringWithFormat:@"%.2f",sender.value]];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker setDate:[NSDate date]];
    
    [datePicker setTag:textField.tag];
    [datePicker addTarget:self action:@selector(getDate:) forControlEvents:UIControlEventValueChanged];
    [textField setInputView:datePicker];
}

-(void) getDate:(id)sender
{
    UIDatePicker* datepicker = (UIDatePicker*) sender;
    NSDateFormatter* dformat = [[NSDateFormatter alloc] init];
    [dformat setDateFormat:@"MMM dd, yyyy"];

    if (datepicker.tag == FRMTXTTAG)
    {
        self.frmTxt.text = [NSString stringWithFormat:@"%@",[dformat stringFromDate:datepicker.date]];
    }
    else
    {         
        self.toTxt.text = [NSString stringWithFormat:@"%@",[dformat stringFromDate:datepicker.date]];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}
@end
