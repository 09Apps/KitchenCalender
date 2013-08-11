//
//  MilkViewController.m
//  KichenCalender
//
//  Created by Swapnil Takalkar on 7/16/13.
//  Copyright (c) 2013 mobi. All rights reserved.
//

#import "MilkViewController.h"
#import "MBExceptionVC.h"

#define ADDSECTIONTAG 100
#define SAVEDATAG 200

@interface MilkViewController ()

@end

@implementation MilkViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.model = [[MBKCModel alloc] init];
    
    NSArray* milkarr = [self.model getMilkDetails];
    
    NSString* sectstr = [milkarr objectAtIndex:0];
    self.sect = [sectstr integerValue];
    
    self.currency = [milkarr objectAtIndex:1];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    self.milk = [[NSMutableArray alloc] initWithArray:[milkarr objectAtIndex:2]];
    
        // Show add button only if currently there is 1 section. As we support only two sections
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addSection)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveData)];
    self.navigationItem.leftBarButtonItem = saveButton;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return self.sect;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    UIStepper *stepper;
    UILabel *quantitylbl;
    NSMutableDictionary* milkdict = [[NSMutableDictionary alloc] init];
    
    NSUInteger bounds = [self.milk count];
    
    if (bounds > [indexPath section])
    {
        milkdict = [self.milk objectAtIndex:[indexPath section]];
    }
    else
    {
        [self.milk addObject:milkdict];
    }
    
    int sectionCount = [indexPath section] *10; // This is to manage tags of the textfields
    
    switch ([indexPath row])
    {
        case 0:
            // Cell1 is re-usable cell for textfield based cells
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell1"];            
            self.txtField = [[UITextField alloc] initWithFrame:CGRectMake(135, 60, 130, 20)];
            self.txtField.delegate = self;
            
            self.txtField.placeholder = @"e.g. Amul milk";
            self.txtField.keyboardType = UIKeyboardTypeNamePhonePad;
            self.txtField.returnKeyType = UIReturnKeyNext;
            self.txtField.textAlignment = NSTextAlignmentRight;
            self.txtField.tag = sectionCount + [indexPath row];
            self.txtField.adjustsFontSizeToFitWidth = YES;
            
            self.txtField.text = [milkdict objectForKey:@"title"];

            cell.textLabel.text = @"Title ";
            [cell setAccessoryView:self.txtField];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        
        case 1:
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell1"];            
            self.txtField = [[UITextField alloc] initWithFrame:CGRectMake(135, 60, 130, 20)];
            self.txtField.delegate = self;
            
            self.txtField.placeholder = @"Rs per ltr";
            self.txtField.keyboardType = UIKeyboardTypeDecimalPad;
            self.txtField.returnKeyType = UIReturnKeyNext;
            self.txtField.textAlignment = NSTextAlignmentRight;            
            self.txtField.tag = sectionCount + [indexPath row];
            [self.txtField setEnabled: YES];
            
            self.txtField.text = [milkdict objectForKey:@"rate"];
            
            cell.textLabel.text = @"Rate per ltr";
            [cell setAccessoryView:self.txtField];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            break;

        case 2:
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell2"];
            cell.textLabel.text = @"Quantity per day";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            stepper =[[UIStepper alloc] initWithFrame:CGRectMake(200, 60, 40, 20)];
            [stepper setStepValue:0.25];
            [stepper addTarget:self action:@selector(stepperPressed:) forControlEvents:UIControlEventValueChanged];
            stepper.tag = indexPath.section;
            
            quantitylbl = [[UILabel alloc] initWithFrame:CGRectMake(160, 12, 40, 20)];
            //quantitylbl.backgroundColor = [UIColor clearColor];
            
            quantitylbl.text = [milkdict objectForKey:@"quantity"];

            [stepper setValue:[quantitylbl.text doubleValue]];

            [cell addSubview:quantitylbl];            
            [cell setAccessoryView:stepper];
            
            break;

        case 3:
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell1"];            
            self.txtField = [[UITextField alloc] initWithFrame:CGRectMake(135, 60, 130, 20)];
            self.txtField.delegate = self;
            
            self.txtField.placeholder = @"Rs per month";
            self.txtField.keyboardType = UIKeyboardTypeNumberPad;
            self.txtField.returnKeyType = UIReturnKeyNext;
            self.txtField.textAlignment = NSTextAlignmentRight;            
            self.txtField.tag = sectionCount + [indexPath row];
            
            self.txtField.text = [milkdict objectForKey:@"deliveryCharge"];
            
            cell.textLabel.text = @"Delivery Charges";
            [cell setAccessoryView:self.txtField];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            break;

        case 4:
        {
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell4"];
            self.txtField = [[UITextField alloc] initWithFrame:CGRectMake(135, 60, 130, 20)];
            [self.txtField setDelegate:self];
            self.txtField.placeholder = @"effective from date";
            self.txtField.textAlignment = NSTextAlignmentRight;            
            self.txtField.tag = sectionCount + [indexPath row];
            self.txtField.adjustsFontSizeToFitWidth = YES;

            UIDatePicker *datePicker = [[UIDatePicker alloc]init];
            [datePicker setDatePickerMode:UIDatePickerModeDate];
            
            NSDateFormatter* dateformat = [[NSDateFormatter alloc] init];
            [dateformat setDateFormat:@"MMM dd, yyyy"];
            
            self.txtField.text = [milkdict objectForKey:@"fromDate"];

            NSDate* date = [dateformat dateFromString:self.txtField.text];
            
            if (date == nil)
            {
                [datePicker setDate:[NSDate date]];
            }
            else
            {
                [datePicker setDate:date];
            }
            
            [datePicker setTag:[indexPath section]];
            [datePicker addTarget:self action:@selector(updateDateField:) forControlEvents:UIControlEventValueChanged];
            [self.txtField setInputView:datePicker];
             
            cell.textLabel.text = @"From Date ";
            [cell setAccessoryView:self.txtField];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            break;
        }
        case 5:
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell3"];            
            cell.textLabel.text = @"Exceptions ";
            [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            break;

        default:
            break;
    }
    
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{            
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self saveTextField:textField];
}

- (void)saveTextField:(UITextField *)textField
{
    // Save the values from textfields.
    NSUInteger arrind = textField.tag/10;
    NSUInteger tagind = textField.tag - (arrind * 10);
    
    switch (tagind)
    {
        case 0:
            [[self.milk objectAtIndex:arrind] setValue:textField.text forKey:@"title"];
            break;
            
        case 1:
            [[self.milk objectAtIndex:arrind] setValue:textField.text forKey:@"rate"];
            break;
            
        case 3:
            [[self.milk objectAtIndex:arrind] setValue:textField.text forKey:@"deliveryCharge"];                        
            break;
            
        default:
            break;
    }
}

- (IBAction)stepperPressed:(UIStepper *)sender
{
//    double stepval = sender.value + sender.stepValue;
    NSString* strval = [NSString stringWithFormat:@"%.2f",sender.value];
    
    [[self.milk objectAtIndex:sender.tag] setValue:strval forKey:@"quantity"];
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:2 inSection:sender.tag]] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)addSection
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Milk" message:@"Do you wish to add one more milk details?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert setTag:ADDSECTIONTAG];
    [alert show];
    
    // DO only if users says yes in alert. Check alert's method.
}

- (void)saveData
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save changes" message:@"Do you wish to save the details?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert setTag:SAVEDATAG];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == ADDSECTIONTAG)
    {
        // This means user is adding one more section
        
        self.sect++;
            
        [self.view endEditing:YES];
        [self saveTextField:self.txtField];
        
        [self.tableView reloadData];
        
        // Do nothing if users says No to add milk
    }
    else
    {
        // User is saving data
        if (buttonIndex == 1)
        {
            NSArray* savearr = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%d",self.sect],
                                                                self.currency,
                                                                self.milk,
                                                                nil];
            [self.view endEditing:YES];
            
            [self.model setMilkDetails:savearr];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    
    if (indexPath.row == 5)
    {
        NSMutableArray* excparr = [[self.milk objectAtIndex:[indexPath section]] objectForKey:@"exceptions"];
        
        MBExceptionVC* exceptionVC = [[MBExceptionVC alloc] initWithException:excparr];
        
        [self.navigationController pushViewController:exceptionVC animated:YES];
    }
}

-(void) updateDateField:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)sender;
    
    NSDateFormatter* dformat = [[NSDateFormatter alloc] init];
    [dformat setDateFormat:@"MMM dd, yyyy"];
    
    self.txtField.text = [NSString stringWithFormat:@"%@",[dformat stringFromDate:picker.date]];
    
    [[self.milk objectAtIndex:picker.tag] setValue:self.txtField.text forKey:@"fromDate"];
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:4 inSection:picker.tag]] withRowAnimation:UITableViewRowAnimationNone];
    
}


@end
