//
//  MBBillViewController.m
//  KichenCalender
//
//  Created by Swapnil Takalkar on 7/26/13.
//  Copyright (c) 2013 mobi. All rights reserved.
//

#import "MBBillViewController.h"
#import "MBShowBillVC.h"
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
    
    [self.frmDte setDelegate:self];
    [self.toDte setDelegate:self];

    [self.frmDte setTag:FRMTXTTAG];
    [self.toDte setTag:TOTXTTAG];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)] ;
    [self.view addGestureRecognizer:tap];
    
    self.segment = 0; // By default milk is selected on segment bar
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)barSegmentChanged:(UISegmentedControl *)sender
{
    self.segment = sender.selectedSegmentIndex;
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showbill"])
    {
        MBShowBillVC *nextVC = (MBShowBillVC *)[segue destinationViewController];
        nextVC.billtype = self.segment;
        
        nextVC.frmdt = self.nsdatefrm;
        nextVC.todt = self.nsdateto;
    }
}

- (IBAction)getBillPressed:(id)sender
{
    NSDateFormatter* dateformat = [[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"MMM dd, yyyy"];
    [dateformat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    self.nsdatefrm = [dateformat dateFromString:self.frmDte.text];
    self.nsdateto = [dateformat dateFromString:self.toDte.text];
    
    if([self.nsdatefrm compare:self.nsdateto] == NSOrderedDescending)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"TillDate should be after FromDate." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if(self.nsdateto == nil || self.nsdatefrm ==nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please select dates." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        [self performSegueWithIdentifier:@"showbill" sender:nil];
    }
}

@end
