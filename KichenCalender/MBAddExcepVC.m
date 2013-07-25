//
//  MBAddExcepVC.m
//  KichenCalender
//
//  Created by Swapnil Takalkar on 7/25/13.
//  Copyright (c) 2013 mobi. All rights reserved.
//

#import "MBAddExcepVC.h"

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

- (IBAction)touchedDateFld:(UITextField *)sender
{
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    
    NSDateFormatter* dateformat = [[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"MMM dd, yyyy"];
    [datePicker setDate:[NSDate date]];
    [datePicker addTarget:self action:@selector(getDate:) forControlEvents:UIControlEventValueChanged];
    [sender setInputView:datePicker];

}

-(void) updateDateField:(id)sender
{
}

@end
