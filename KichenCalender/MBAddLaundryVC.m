//
//  MBAddLaundryVC.m
//  KichenCalender
//
//  Created by Swapnil Takalkar on 8/20/13.
//  Copyright (c) 2013 mobi. All rights reserved.
//

#import "MBAddLaundryVC.h"

@interface MBAddLaundryVC ()

@end

@implementation MBAddLaundryVC

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
    
    self.ctdict = [[NSMutableDictionary alloc] init];
    
    self.isaddedflag = NO;
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)] ;
    [self.view addGestureRecognizer:tap];
    
    [self.ctdict setValue:@"0" forKey:@"returned"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tapped
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //Do it only for date field which has tag 1
    
    if (textField.tag == 1)
    {
        UIDatePicker *datePicker = [[UIDatePicker alloc]init];
        [datePicker setDatePickerMode:UIDatePickerModeDate];
        [datePicker setDate:[NSDate date]];
        
        [datePicker setTag:textField.tag];
        [datePicker addTarget:self action:@selector(getDate:) forControlEvents:UIControlEventValueChanged];
        [textField setInputView:datePicker];
    }

}

-(void) getDate:(id)sender
{
    UIDatePicker* datepicker = (UIDatePicker*) sender;
    NSDateFormatter* dformat = [[NSDateFormatter alloc] init];
    [dformat setDateFormat:@"MMM dd, yyyy"];
    
    self.txtfld.text = [NSString stringWithFormat:@"%@",[dformat stringFromDate:datepicker.date]];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{    
    switch (textField.tag)
    {
        case 1:
            [self.ctdict setValue:textField.text forKey:@"ondate"];
            break;
            
        case 2:
            [self.ctdict setValue:textField.text forKey:@"press"];
            self.isaddedflag = YES;
            [textField resignFirstResponder];
            break;
            
        case 3:
            [self.ctdict setValue:textField.text forKey:@"wash"];
            self.isaddedflag = YES;
            [textField resignFirstResponder];
            break;

        case 4:
            [self.ctdict setValue:textField.text forKey:@"dryclean"];
            self.isaddedflag = YES;
            [textField resignFirstResponder];
            break;
            
        case 5:
            [self.ctdict setValue:textField.text forKey:@"bleach"];
            self.isaddedflag = YES;
            [textField resignFirstResponder];
            break;
            
        default:
            break; 
    }
}
- (IBAction)isReturned:(UISegmentedControl *)sender
{
    NSString* str = [NSString stringWithFormat:@"%d",sender.selectedSegmentIndex];
    [self.ctdict setValue:str forKey:@"returned"];
}

- (IBAction)cencelAdd:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)AddLaundry:(UIButton *)sender
{
    [self.view endEditing:YES];
    
    if (self.isaddedflag == YES)
    {
        NSUInteger totalcloth = [[self.ctdict objectForKey:@"press"] integerValue] +
                                [[self.ctdict objectForKey:@"wash"] integerValue] +
                                [[self.ctdict objectForKey:@"dryclean"] integerValue] +
                                [[self.ctdict objectForKey:@"bleach"] integerValue] ;
        
        [self.ctdict setValue:[NSString stringWithFormat:@"%d",totalcloth] forKey:@"totalcloth"];
        
        [self.delegate addLaundry:self didFinishAddingException:self.ctdict];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter laundry details." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}
@end
