//
//  MBPaperViewController.m
//  KichenCalender
//
//  Created by Swapnil Takalkar on 8/12/13.
//  Copyright (c) 2013 mobi. All rights reserved.
//

#import "MBPaperViewController.h"

@interface MBPaperViewController ()

@end

@implementation MBPaperViewController

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
    
    NSArray* paperarr = [self.model getOtherDetails:PAPERCAT];
    
    self.currency = [paperarr objectAtIndex:0];
    
    NSString* sectstr = [paperarr objectAtIndex:1];
    self.sect = [sectstr integerValue];
    
    self.ischangedflag = NO;
    
    self.papers = [[NSMutableArray alloc] initWithArray:[paperarr objectAtIndex:2]];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCatSection)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveCatData)];
    self.navigationItem.leftBarButtonItem = saveButton;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
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
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    NSMutableDictionary* paperdict = [[NSMutableDictionary alloc] init];

    paperdict = [self.papers objectAtIndex:[indexPath section]];

    int sectionCount = [indexPath section] *10; // This is to manage tags of the textfields
    // Configure the cell...

    switch ([indexPath row])
    {
        case 0:
            // Cell1 is re-usable cell for textfield based cells
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell1" forIndexPath:indexPath];
            self.txtField = [[UITextField alloc] initWithFrame:CGRectMake(150, 60, 120, 20)];
            self.txtField.delegate = self;
            
            self.txtField.placeholder = @"e.g. Times of India";
            self.txtField.keyboardType = UIKeyboardTypeNamePhonePad;
            self.txtField.returnKeyType = UIReturnKeyNext;
            self.txtField.textAlignment = NSTextAlignmentRight;
            self.txtField.tag = sectionCount + [indexPath row];
            self.txtField.adjustsFontSizeToFitWidth = YES;
            
            self.txtField.text = [paperdict objectForKey:@"title"];
            
            cell.textLabel.text = @"Title ";
            [cell setAccessoryView:self.txtField];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;

        case 1:
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell1"];
            self.txtField = [[UITextField alloc] initWithFrame:CGRectMake(150, 60, 120, 20)];
            self.txtField.delegate = self;
            
            self.txtField.placeholder = @"Mon - Fri rate Rs.";
            self.txtField.keyboardType = UIKeyboardTypeDecimalPad;
            self.txtField.returnKeyType = UIReturnKeyNext;
            self.txtField.textAlignment = NSTextAlignmentRight;
            self.txtField.tag = sectionCount + [indexPath row];
            [self.txtField setEnabled: YES];
            self.txtField.adjustsFontSizeToFitWidth = YES;            
            
            self.txtField.text = [paperdict objectForKey:@"weekdayprice"];
            
            cell.textLabel.text = @"Weekday Rate Rs.";
            [cell setAccessoryView:self.txtField];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            break;

        case 2:
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell1"];
            self.txtField = [[UITextField alloc] initWithFrame:CGRectMake(150, 60, 120, 20)];
            self.txtField.delegate = self;
            
            self.txtField.placeholder = @"Saturday rate Rs.";
            self.txtField.keyboardType = UIKeyboardTypeDecimalPad;
            self.txtField.returnKeyType = UIReturnKeyNext;
            self.txtField.textAlignment = NSTextAlignmentRight;
            self.txtField.tag = sectionCount + [indexPath row];
            [self.txtField setEnabled: YES];
            self.txtField.adjustsFontSizeToFitWidth = YES;            
            
            self.txtField.text = [paperdict objectForKey:@"saturdayprice"];
            
            cell.textLabel.text = @"Saturday Rate Rs.";
            [cell setAccessoryView:self.txtField];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            break;

        case 3:
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell1"];
            self.txtField = [[UITextField alloc] initWithFrame:CGRectMake(150, 60, 120, 20)];
            self.txtField.delegate = self;
            
            self.txtField.placeholder = @"Sunday rate Rs.";
            self.txtField.keyboardType = UIKeyboardTypeDecimalPad;
            self.txtField.returnKeyType = UIReturnKeyNext;
            self.txtField.textAlignment = NSTextAlignmentRight;
            self.txtField.tag = sectionCount + [indexPath row];
            [self.txtField setEnabled: YES];
            self.txtField.adjustsFontSizeToFitWidth = YES;            
            
            self.txtField.text = [paperdict objectForKey:@"sundayprice"];
            
            cell.textLabel.text = @"Sunday Rate Rs.";
            [cell setAccessoryView:self.txtField];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            break;
            
        case 4:
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell1"];
            self.txtField = [[UITextField alloc] initWithFrame:CGRectMake(150, 60, 120, 20)];
            self.txtField.delegate = self;
            
            self.txtField.placeholder = @"Rs per month";
            self.txtField.keyboardType = UIKeyboardTypeNumberPad;
            self.txtField.returnKeyType = UIReturnKeyNext;
            self.txtField.textAlignment = NSTextAlignmentRight;
            self.txtField.tag = sectionCount + [indexPath row];
            
            self.txtField.text = [paperdict objectForKey:@"deliverycharge"];
            
            cell.textLabel.text = @"Delivery Charges";
            [cell setAccessoryView:self.txtField];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            break;
            
        case 5:
        {
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell2"];
            self.txtField = [[UITextField alloc] initWithFrame:CGRectMake(150, 60, 120, 20)];
            [self.txtField setDelegate:self];
            self.txtField.placeholder = @"effective from date";
            self.txtField.textAlignment = NSTextAlignmentRight;
            self.txtField.tag = sectionCount + [indexPath row];
            self.txtField.adjustsFontSizeToFitWidth = YES;
            
            UIDatePicker *datePicker = [[UIDatePicker alloc]init];
            [datePicker setDatePickerMode:UIDatePickerModeDate];
            
            NSDateFormatter* dateformat = [[NSDateFormatter alloc] init];
            [dateformat setDateFormat:@"MMM dd, yyyy"];
            
            self.txtField.text = [paperdict objectForKey:@"fromdate"];
            
            NSDate* date = [dateformat dateFromString:self.txtField.text];
            
            if (date == nil)
            {
                [datePicker setDate:[NSDate date]];
            }
            else
            {
                [datePicker setDate:date];
            }
            
            [datePicker setTag:self.txtField.tag];
            [datePicker addTarget:self action:@selector(updateDateField:) forControlEvents:UIControlEventValueChanged];
            [self.txtField setInputView:datePicker];
            
            cell.textLabel.text = @"From Date ";
            [cell setAccessoryView:self.txtField];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            break;
        }
            
        case 6:
        {
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell2"];
            self.txtField = [[UITextField alloc] initWithFrame:CGRectMake(150, 60, 120, 20)];
            [self.txtField setDelegate:self];
            self.txtField.textAlignment = NSTextAlignmentRight;
            self.txtField.tag = sectionCount + [indexPath row];
            self.txtField.adjustsFontSizeToFitWidth = YES;
            
            UIDatePicker *datePicker = [[UIDatePicker alloc]init];
            [datePicker setDatePickerMode:UIDatePickerModeDate];
            
            NSDateFormatter* dateformat = [[NSDateFormatter alloc] init];
            [dateformat setDateFormat:@"MMM dd, yyyy"];
            
            self.txtField.text = [paperdict objectForKey:@"todate"];
            NSDate* date = [dateformat dateFromString:self.txtField.text];
            
            if (date == nil)
            {
                self.txtField.text = @"Dec 31, 2100";
            }
            else
            {
                [datePicker setDate:date];
            }
            
            [datePicker setTag:self.txtField.tag];
            [datePicker addTarget:self action:@selector(updateDateField:) forControlEvents:UIControlEventValueChanged];
            [self.txtField setInputView:datePicker];
            
            cell.textLabel.text = @"Till Date ";
            [cell setAccessoryView:self.txtField];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            break;
        }
            
        case 7:
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell3"];
            cell.textLabel.text = @"No paper days ";
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
            [[self.papers objectAtIndex:arrind] setValue:textField.text forKey:@"title"];
            self.ischangedflag = YES;
            break;
            
        case 1:
            [[self.papers objectAtIndex:arrind] setValue:textField.text forKey:@"weekdayprice"];
            self.ischangedflag = YES;            
            break;
            
        case 2:
            [[self.papers objectAtIndex:arrind] setValue:textField.text forKey:@"saturdayprice"];
            self.ischangedflag = YES;            
            break;
            
        case 3:
            [[self.papers objectAtIndex:arrind] setValue:textField.text forKey:@"sundayprice"];
            self.ischangedflag = YES;            
            break;
            
        case 4:
            [[self.papers objectAtIndex:arrind] setValue:textField.text forKey:@"deliverycharge"];
            self.ischangedflag = YES;            
            break;
            
        default:
            break;
    }
}

- (void)addCatSection
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Subscription" message:@"Do you wish to add one more Subscription?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Daily Newspaper", @"Weekly Magazine", nil];
    [alert setTag:ADDSECTIONTAG];
    [alert show];
    
    // DO only if users says yes in alert. Check alert's method.
}

- (void)saveCatData
{
    if (self.ischangedflag == YES)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save changes" message:@"Do you wish to save the details?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alert setTag:SAVEDATAG];
        [alert show];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(void) updateDateField:(UIDatePicker*)sender
{
    NSUInteger arrind = sender.tag/10;
    NSUInteger tagind = sender.tag - (arrind * 10);
    
    NSDateFormatter* dformat = [[NSDateFormatter alloc] init];
    [dformat setDateFormat:@"MMM dd, yyyy"];
    
    self.txtField.text = [NSString stringWithFormat:@"%@",[dformat stringFromDate:sender.date]];
    
    if (tagind == 5)
    {
        [[self.papers objectAtIndex:arrind] setValue:self.txtField.text forKey:@"fromdate"];
        self.ischangedflag = YES;        
    }
    else
    {
        // Compare toDate with From Date
        NSString* frmtxt = [[self.papers objectAtIndex:arrind] objectForKey:@"fromdate"];
        
        NSDate* frmdate = [dformat dateFromString:frmtxt];
        
        if([frmdate compare:sender.date] == NSOrderedDescending)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"TillDate should be after FromDate." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            self.txtField.text = @"";
            [alert show];
        }
        else
        {
            [[self.papers objectAtIndex:arrind] setValue:self.txtField.text forKey:@"todate"];
            self.ischangedflag = YES;            
        }
    }
    
    [self.tableView reloadData];    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == ADDSECTIONTAG)
    {
        // This means user is adding one more section
        
        NSMutableDictionary* paperdict = [[NSMutableDictionary alloc] init];
        
        if (buttonIndex == 1)
        {
            //Means add daily
            self.sect++;
            [self.view endEditing:YES];
            [self saveTextField:self.txtField];
            self.ischangedflag = YES;
            
            [paperdict setObject:@"daily" forKey:@"frequency"];
            [self.papers addObject:paperdict];
            [self.tableView reloadData];
        }
        else if (buttonIndex == 2)
        {
            //Means add weekly
            self.sect++;
            [self.view endEditing:YES];
            [self saveTextField:self.txtField];
            self.ischangedflag = YES;
            
            [paperdict setObject:@"weekly" forKey:@"frequency"];
            [self.papers addObject:paperdict];
            [self.tableView reloadData];
        }
        // Do nothing if users says No to add paper
    }
    else
    {
        // User is saving data
        if (buttonIndex == 1)
        {
            NSArray* savearr = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%d",self.sect],
                                self.papers,
                                nil];
            
            NSArray* papersarr = [[NSArray alloc] initWithObjects:self.currency,
                                  savearr,
                                  nil];
                                  
            [self.view endEditing:YES];
            
            [self.model setPaperDetails:papersarr];
        }
 
        [self.navigationController popViewControllerAnimated:YES]; 
    } 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    
    if (indexPath.row == 7)
    {
        NSMutableArray* excparr = [[self.papers objectAtIndex:[indexPath section]] objectForKey:@"exceptions"];
        
        self.ischangedflag = YES;
        
        if (excparr == nil) {
            excparr = [[NSMutableArray alloc] init];
            [[self.papers objectAtIndex:[indexPath section]] setObject:excparr forKey:@"exceptions"];
        }
        
//        MBExceptionVC* exceptionVC = [[MBExceptionVC alloc] initWithException:excparr];
        
//        [self.navigationController pushViewController:exceptionVC animated:YES];
    }
}

@end
