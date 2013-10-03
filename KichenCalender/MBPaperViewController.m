//
//  MBPaperViewController.m
//  KichenCalender
//
//  Created by Swapnil Takalkar on 8/12/13.
//  Copyright (c) 2013 09Apps. All rights reserved.
//

#import "MBPaperViewController.h"
#import "MBExceptionVC.h"

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
    
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"board_back.png"]];    
    
    UIImage *image = [UIImage imageNamed: @"NavBar-Wood.png"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics: UIBarMetricsDefault];

    self.title = @"Paper n Mags";
    
    self.model = [[MBKCModel alloc] init];
    
    NSArray* paperarr = [self.model getPaperDetails];
    
    self.currency = [paperarr objectAtIndex:0];
    
    NSString* sectstr = [paperarr objectAtIndex:1];
    self.sect = [sectstr integerValue];
    
    self.ischangedflag = NO;
    
    self.papers = [[NSMutableArray alloc] initWithArray:[paperarr objectAtIndex:2]];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCatSection)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveCatData)];
    self.navigationItem.leftBarButtonItem = saveButton;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    }
    else
    {
        self.navigationController.navigationBar.tintColor = [UIColor brownColor];
    }
    
    self.days = [[NSArray alloc] initWithObjects:@"Sunday", @"Monday", @"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday",nil];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return self.sect;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    NSMutableDictionary* paperdict = [[NSMutableDictionary alloc] init];

    paperdict = [self.papers objectAtIndex:[indexPath section]];
    
    NSString* freqstr = [paperdict objectForKey:@"frequency"];
    BOOL isdaily = YES;
    
    if ([freqstr compare:@"weekly"] == NSOrderedSame)
    {
        isdaily = NO;
    }

    int sectionCount = [indexPath section] *10; // This is to manage tags of the textfields
    // Configure the cell...

    switch ([indexPath row])
    {
        case 0:
            // Cell1 is re-usable cell for textfield based cells
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell1" forIndexPath:indexPath];
            self.txtField = [[UITextField alloc] initWithFrame:CGRectMake(160, 60, 120, 20)];
            self.txtField.delegate = self;
            
            if (isdaily == YES)
            {
                self.txtField.placeholder = @"e.g. Times of India";
            }
            else
            {
                self.txtField.placeholder = @"e.g. India Today";
            }
            
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
            self.txtField = [[UITextField alloc] initWithFrame:CGRectMake(170, 60, 110, 20)];
            self.txtField.textAlignment = NSTextAlignmentRight;
            self.txtField.tag = sectionCount + [indexPath row];
            self.txtField.adjustsFontSizeToFitWidth = YES;
            
            if (isdaily == YES)
            {
                self.txtField.delegate = self;
                self.txtField.placeholder = @"Mon-Thu rate Rs.";
                self.txtField.keyboardType = UIKeyboardTypeDecimalPad;
                self.txtField.returnKeyType = UIReturnKeyNext;
                [self.txtField setEnabled: YES];
                self.txtField.text = [paperdict objectForKey:@"weekdayprice"];
                cell.textLabel.text = @"Weekday Rate Rs.";
            }
            else
            {
                [self.txtField setEnabled:NO];
                cell.textLabel.text = @"Delivery frequency";                
                self.txtField.text = @"Weekly";
            }
            
            [cell setAccessoryView:self.txtField];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            break;

        case 2:
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell1"];
            self.txtField = [[UITextField alloc] initWithFrame:CGRectMake(160, 60, 120, 20)];
            self.txtField.textAlignment = NSTextAlignmentRight;
            self.txtField.tag = sectionCount + [indexPath row];
            
            self.txtField.adjustsFontSizeToFitWidth = YES;
            self.txtField.delegate = self;
            self.txtField.keyboardType = UIKeyboardTypeDecimalPad;
            self.txtField.returnKeyType = UIReturnKeyNext;
            
            if (isdaily == YES)
            {
                self.txtField.text = [paperdict objectForKey:@"fridayprice"];
                [self.txtField setEnabled: YES];
                self.txtField.placeholder = @"Friday rate Rs.";
                cell.textLabel.text = @"Friday Rate Rs.";
            }
            else
            {
                // This is just to fill, we are showing publisher with title
                self.txtField.text = [paperdict objectForKey:@"title"];
                self.txtField.placeholder = @"Publisher";
                [self.txtField setEnabled:NO];
                cell.textLabel.text = @"Updating...";
            }
            
            [cell setAccessoryView:self.txtField];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            break;
            
        case 3:
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell1"];
            self.txtField = [[UITextField alloc] initWithFrame:CGRectMake(160, 60, 120, 20)];
            self.txtField.textAlignment = NSTextAlignmentRight;
            self.txtField.tag = sectionCount + [indexPath row];

            self.txtField.adjustsFontSizeToFitWidth = YES;
            self.txtField.delegate = self;
            self.txtField.keyboardType = UIKeyboardTypeDecimalPad;
            self.txtField.returnKeyType = UIReturnKeyNext;
            self.txtField.text = [paperdict objectForKey:@"saturdayprice"];
            [self.txtField setEnabled: YES];
            
            if (isdaily == YES)
            {
                self.txtField.placeholder = @"Saturday rate Rs.";
                cell.textLabel.text = @"Saturday Rate Rs.";
            }
            else
            {
                self.txtField.placeholder = @"Weekly rate Rs.";
                cell.textLabel.text = @"Per week Rs.";
            }
            
            [cell setAccessoryView:self.txtField];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            break;

        case 4:
            self.txtField = [[UITextField alloc] initWithFrame:CGRectMake(160, 60, 120, 20)];
            self.txtField.delegate = self;
            self.txtField.textAlignment = NSTextAlignmentRight;
            self.txtField.tag = sectionCount + [indexPath row];
            self.txtField.adjustsFontSizeToFitWidth = YES;
            [self.txtField setEnabled: YES];
            
            if (isdaily == YES)
            {
                cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell1"];
                self.txtField.text = [paperdict objectForKey:@"sundayprice"];
                self.txtField.placeholder = @"Sunday rate Rs.";
                self.txtField.keyboardType = UIKeyboardTypeDecimalPad;
                self.txtField.returnKeyType = UIReturnKeyNext;
                cell.textLabel.text = @"Sunday Rate Rs.";
            }
            else
            {
                cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell2"];                
                
                NSUInteger dayind = 0;
                dayind = [[paperdict objectForKey:@"sundayprice"] integerValue];
                
                if (dayind > 0) {
                    dayind--;
                }
                
                self.txtField.text = [self.days objectAtIndex:dayind];
                
                UIPickerView* daypicker = [[UIPickerView alloc] init];
                self.txtField.inputView = daypicker;
                daypicker.delegate = self;
                daypicker.dataSource = self;
                daypicker.showsSelectionIndicator = YES;
                daypicker.tag = self.txtField.tag;
                cell.textLabel.text = @"Day of delivery";                
            }
            
            [cell setAccessoryView:self.txtField];            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            break;
            
        case 5:
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell1"];
            self.txtField = [[UITextField alloc] initWithFrame:CGRectMake(160, 60, 120, 20)];
            self.txtField.delegate = self;
            
            self.txtField.placeholder = @"Rs per month";
            self.txtField.keyboardType = UIKeyboardTypeNumberPad;
            self.txtField.returnKeyType = UIReturnKeyNext;
            self.txtField.textAlignment = NSTextAlignmentRight;
            self.txtField.adjustsFontSizeToFitWidth = YES;            
            self.txtField.tag = sectionCount + [indexPath row];
            
            self.txtField.text = [paperdict objectForKey:@"deliverycharge"];
            
            cell.textLabel.text = @"Delivery Charges";
            [cell setAccessoryView:self.txtField];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            break;
            
        case 6:
        {
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell2"];
            self.txtField = [[UITextField alloc] initWithFrame:CGRectMake(160, 60, 120, 20)];
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
            
        case 7:
        {
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell2"];
            self.txtField = [[UITextField alloc] initWithFrame:CGRectMake(160, 60, 120, 20)];
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
                [[self.papers objectAtIndex:indexPath.section] setValue:self.txtField.text forKey:@"todate"];
                [datePicker setDate:[NSDate date]];
            }
            else
            {
                if ([self.txtField.text compare:@"Dec 31, 2100"] == NSOrderedSame)
                {
                    [datePicker setDate:[NSDate date]];
                }
                else
                {
                    [datePicker setDate:date];
                }
            }

            [datePicker setTag:self.txtField.tag];
            [datePicker addTarget:self action:@selector(updateDateField:) forControlEvents:UIControlEventValueChanged];
            [self.txtField setInputView:datePicker];
            
            cell.textLabel.text = @"Till Date ";
            [cell setAccessoryView:self.txtField];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            break;
        }
            
        case 8:
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

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.ischangedflag = YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self saveTextField:textField];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    return [self.days count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.days objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

    self.txtField.text = [self.days objectAtIndex:[pickerView selectedRowInComponent:0]]; 
    self.txtField.tag = pickerView.tag;
    NSUInteger arrind = pickerView.tag/10;
    
    NSUInteger count = 1;
    
    for (NSString* daystr in self.days)
    {
        if ([daystr compare:self.txtField.text] == NSOrderedSame)
        {
            [[self.papers objectAtIndex:arrind] setValue:[NSString stringWithFormat:@"%d",count] forKey:@"sundayprice"];
            break;
        }
        count++;
    }
    
    self.ischangedflag = YES;  
    [self.tableView reloadData];
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
            [[self.papers objectAtIndex:arrind] setValue:textField.text forKey:@"fridayprice"];
            self.ischangedflag = YES;
            break;
        
        case 3:
            [[self.papers objectAtIndex:arrind] setValue:textField.text forKey:@"saturdayprice"];
            self.ischangedflag = YES;            
            break;
            
        case 4:
            if ([textField.text integerValue] != 0)
            {
                // Do only for daily.Weekly is handled in pickerview
                [[self.papers objectAtIndex:arrind] setValue:textField.text forKey:@"sundayprice"];
                self.ischangedflag = YES;
            }
            break;
            
        case 5:
            [[self.papers objectAtIndex:arrind] setValue:textField.text forKey:@"deliverycharge"];
            self.ischangedflag = YES;            
            break;

        case 6:
            [self.tableView reloadData];
            break;

        case 7:
            [self.tableView reloadData];
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
    
    if (tagind == 6)
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
//    [self.tableView reloadData];
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
        // User is saving data {currency, paper={sections,papers}}
        if (buttonIndex == 1)
        {
            NSArray* savearr = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%d",self.sect],
                                self.papers,
                                nil];
            
            NSArray* keyarr = [[NSArray alloc] initWithObjects:@"sections", @"papers", nil];
            
            NSDictionary* paperdict = [[NSDictionary alloc] initWithObjects:savearr forKeys:keyarr];
            
            NSArray* papersarr = [[NSArray alloc] initWithObjects:self.currency,
                                  paperdict,
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
    
    if (indexPath.row == 8)
    {
        NSMutableArray* excparr = [[self.papers objectAtIndex:[indexPath section]] objectForKey:@"exceptions"];
        
        self.ischangedflag = YES;
        
        if (excparr == nil) {
            excparr = [[NSMutableArray alloc] init];
            [[self.papers objectAtIndex:[indexPath section]] setObject:excparr forKey:@"exceptions"];
        }
        
        MBExceptionVC* exceptionVC = [[MBExceptionVC alloc] initWithException:excparr];
        exceptionVC.category = PAPERCAT;
        
        [self.navigationController pushViewController:exceptionVC animated:YES];
    }
}

@end
