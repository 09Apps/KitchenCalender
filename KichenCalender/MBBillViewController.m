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
    
    [self.frmDte setDelegate:self];
    [self.toDte setDelegate:self];

    [self.frmDte setTag:FRMTXTTAG];
    [self.toDte setTag:TOTXTTAG];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)] ;
    [self.view addGestureRecognizer:tap];
    
    self.model = [[MBKCModel alloc] init];
    
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
    self.verified = NO;    
    
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

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSDateFormatter* dateformat = [[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"MMM dd, yyyy"];
    
    NSDate* fromDt = [dateformat dateFromString:self.frmDte.text];
    NSDate* toDt = [dateformat dateFromString:self.toDte.text];
    
    self.verified = NO;
    
    if (fromDt != nil && toDt != nil)
    {
        if([toDt compare:fromDt] == NSOrderedDescending) // if start is later in time than end
        {
            NSInteger days = [self getNumberOfDaysFrom:fromDt Till:toDt];
            self.dayslbl.text = [NSString stringWithFormat:@"%d",days];
            self.verified = YES;
            [self showBillFrom:fromDt Till:toDt];
        }
        else
        {
            textField.text = nil;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"TillDate should be after FromDate." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
}
- (IBAction)barSegmentChanged:(UISegmentedControl *)sender
{
    self.segment = sender.selectedSegmentIndex;

    NSDateFormatter* dateformat = [[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"MMM dd, yyyy"];
    
    NSDate* fromDt = [dateformat dateFromString:self.frmDte.text];
    NSDate* toDt = [dateformat dateFromString:self.toDte.text];
    
    [self showBillFrom:fromDt Till:toDt];
}

- (void) showBillFrom:(NSDate*)frmdt Till:(NSDate*)todt
{
    if (self.verified)
    {
        if (self.segment == 1)
        {
            // Means this is Laundry
            NSLog(@"Laundry");
        }
        else if (self.segment == 2)
        {
            // Means this is Newspaper
            NSLog(@"Newspaper");
        }
        else
        {
            NSLog(@"Milk");               
            [self.model getMilkBillFrom:frmdt Till:todt];
        }
    }
}

-(NSInteger)getNumberOfDaysFrom:(NSDate*)fromDt Till:(NSDate*)toDt
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSUInteger unitFlags = NSDayCalendarUnit;
    
    NSDateComponents *components = [gregorian components:unitFlags
                                                fromDate:fromDt
                                                  toDate:toDt options:0];
    return [components day];
}

@end
