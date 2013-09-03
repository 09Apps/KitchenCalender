//
//  MBAddExcepVC.m
//  KichenCalender
//
//  Created by Swapnil Takalkar on 7/25/13.
//  Copyright (c) 2013 09Apps. All rights reserved.
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
    
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"board_back.png"]];
    
    if (self.category == MILKCAT)
    {
        [self.stepper setStepValue:0.25];
        [self.qtylbl setText:@"0.00"];
    }
    else
    {
        self.stepper.hidden = YES;
        [self.qtylbl setText:@"None"];
    }
    
    [self.frmTxt setTag:FRMTXTTAG];
    [self.toTxt setTag:TOTXTTAG];
    
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)] ;
    [self.view addGestureRecognizer:tap];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)qtyChanged:(UIStepper *)sender
{
    if (self.category == MILKCAT)
    {
        [self.qtylbl setText:[NSString stringWithFormat:@"%.2f",sender.value]];
    }
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

- (void)tapped
{
    if ([self.frmTxt isEditing])
    {
        [self.frmTxt resignFirstResponder];
    }
    
    if ([self.toTxt isEditing])
    {
        [self.toTxt resignFirstResponder];
    }
}

- (IBAction)cencelAdd:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)AddException:(UIButton *)sender
{
    NSDateFormatter* dateformat = [[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"MMM dd, yyyy"];
    [dateformat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    NSDate* fromDt = [dateformat dateFromString:self.frmTxt.text];
    NSDate* toDt = [dateformat dateFromString:self.toTxt.text];
    
    if([fromDt compare:toDt] == NSOrderedDescending) // if start is later in time than end
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"TillDate should be after FromDate." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        NSDictionary* dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                              self.frmTxt.text, @"fromDate",
                              self.toTxt.text, @"toDate",
                              self.qtylbl.text, @"quantity",
                              nil];
        
        [self.delegate addExceptionVC:self didFinishAddingException:dict];
        [self dismissViewControllerAnimated:YES completion:nil];        
    }
}

@end
