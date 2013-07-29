//
//  MBBillViewController.m
//  KichenCalender
//
//  Created by Swapnil Takalkar on 7/26/13.
//  Copyright (c) 2013 mobi. All rights reserved.
//

#import "MBBillViewController.h"
#define FRMTXTTAG 100
#define TOTXTTAG 200

@interface MBBillViewController ()

@end

@implementation MBBillViewController

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
	// Do any additional setup after loading the view.
/*    [self.frmDte setTag:FRMTXTTAG];
    [self.toDte setTag:TOTXTTAG];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)] ;
    [self.view addGestureRecognizer:tap]; */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker setDate:[NSDate date]];
    
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
        self.frmDte.text = [NSString stringWithFormat:@"%@",[dformat stringFromDate:datepicker.date]];
    }
    else
    {
        self.toDte.text = [NSString stringWithFormat:@"%@",[dformat stringFromDate:datepicker.date]];
    }
}

- (void)tapped
{
    if ([self.frmDte isEditing])
    {
        [self.frmDte resignFirstResponder];
    }
    
    if ([self.toDte isEditing])
    {
        [self.toDte resignFirstResponder];
    }
}
*/
@end
