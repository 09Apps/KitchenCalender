//
//  MilkViewController.m
//  KichenCalender
//
//  Created by Swapnil Takalkar on 7/16/13.
//  Copyright (c) 2013 09Apps. All rights reserved.
//

#import "MilkViewController.h"
#import "MBExceptionVC.h"


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
    
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"board_back.png"]];
    
    UIImage *image = [UIImage imageNamed: @"NavBar-Wood.png"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics: UIBarMetricsDefault];

    self.navigationController.navigationBar.tintColor = [UIColor brownColor];
    
    self.model = [[MBKCModel alloc] init];
    
    NSArray* milkarr = [self.model getMilkDetails];
    
    NSString* sectstr = [milkarr objectAtIndex:0];
    self.sect = [sectstr integerValue];
    
    self.ischangedflag = NO;
    
    self.currency = [milkarr objectAtIndex:1];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    self.milk = [[NSMutableArray alloc] initWithArray:[milkarr objectAtIndex:2]];
    
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
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    UIStepper *stepper;
    UILabel *quantitylbl;
    NSMutableDictionary* milkdict = [[NSMutableDictionary alloc] init];

    milkdict = [self.milk objectAtIndex:[indexPath section]];
    
    int sectionCount = [indexPath section] *10; // This is to manage tags of the textfields
    
    switch ([indexPath row])
    {
        case 0:
            // Cell1 is re-usable cell for textfield based cells
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell1" forIndexPath:indexPath];
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
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell1" forIndexPath:indexPath];            
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
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell2" forIndexPath:indexPath];
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
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell1" forIndexPath:indexPath];            
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
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell4" forIndexPath:indexPath];
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
            
            [datePicker setTag:self.txtField.tag];
            [datePicker addTarget:self action:@selector(updateDateField:) forControlEvents:UIControlEventValueChanged];
            [self.txtField setInputView:datePicker];
             
            cell.textLabel.text = @"From Date ";
            [cell setAccessoryView:self.txtField];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            break;
        }
        case 5:
        {
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell4" forIndexPath:indexPath];
            self.txtField = [[UITextField alloc] initWithFrame:CGRectMake(135, 60, 130, 20)];
            [self.txtField setDelegate:self];
            self.txtField.textAlignment = NSTextAlignmentRight;
            self.txtField.tag = sectionCount + [indexPath row];
            self.txtField.adjustsFontSizeToFitWidth = YES;
            
            UIDatePicker *datePicker = [[UIDatePicker alloc]init];
            [datePicker setDatePickerMode:UIDatePickerModeDate];
            
            NSDateFormatter* dateformat = [[NSDateFormatter alloc] init];
            [dateformat setDateFormat:@"MMM dd, yyyy"];            
            
            self.txtField.text = [milkdict objectForKey:@"toDate"];
            NSDate* date = [dateformat dateFromString:self.txtField.text];
            
            if (date == nil)
            {
                self.txtField.text = @"Dec 31, 2100";
                [[self.milk objectAtIndex:indexPath.section] setValue:self.txtField.text forKey:@"toDate"];
                //self.ischangedflag = YES;
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
            
        case 6:
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell3" forIndexPath:indexPath];            
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

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.ischangedflag = YES;
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
            self.ischangedflag = YES;
            break;
            
        case 1:
            [[self.milk objectAtIndex:arrind] setValue:textField.text forKey:@"rate"];
            self.ischangedflag = YES;            
            break;
            
        case 3:
            [[self.milk objectAtIndex:arrind] setValue:textField.text forKey:@"deliveryCharge"];
            self.ischangedflag = YES;            
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
    self.ischangedflag = YES;
    
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == ADDSECTIONTAG)
    {
        // This means user is adding one more section
        if (buttonIndex == 1)
        {
            self.sect++;
            NSMutableDictionary* milkdict = [[NSMutableDictionary alloc] init];
            [self.milk addObject:milkdict];

            [self.view endEditing:YES];
            [self saveTextField:self.txtField];
            self.ischangedflag = YES;
            [self.tableView reloadData];
        }
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
    
    if (indexPath.row == 6)
    {
        NSMutableArray* excparr = [[self.milk objectAtIndex:[indexPath section]] objectForKey:@"exceptions"];

        self.ischangedflag = YES;
        
        if (excparr == nil) {
            excparr = [[NSMutableArray alloc] init];
            [[self.milk objectAtIndex:[indexPath section]] setObject:excparr forKey:@"exceptions"];
        }
        
        MBExceptionVC* exceptionVC = [[MBExceptionVC alloc] initWithException:excparr];
        exceptionVC.category = MILKCAT;
        [self.navigationController pushViewController:exceptionVC animated:YES];
    }
}

-(void) updateDateField:(UIDatePicker*)sender
{
    NSUInteger arrind = sender.tag/10;
    NSUInteger tagind = sender.tag - (arrind * 10);
    
    NSDateFormatter* dformat = [[NSDateFormatter alloc] init];
    [dformat setDateFormat:@"MMM dd, yyyy"];
    
    self.txtField.text = [NSString stringWithFormat:@"%@",[dformat stringFromDate:sender.date]];
    
    if (tagind == 4)
    {
        [[self.milk objectAtIndex:arrind] setValue:self.txtField.text forKey:@"fromDate"];
        self.ischangedflag = YES;        
    }
    else
    {
       // Compare toDate with From Date
        NSString* frmtxt = [[self.milk objectAtIndex:arrind] objectForKey:@"fromDate"];
        
        NSDate* frmdate = [dformat dateFromString:frmtxt];
        
        if([frmdate compare:sender.date] == NSOrderedDescending)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"TillDate should be after FromDate." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            self.txtField.text = @"";
            [alert show];
        }
        else
        {
            [[self.milk objectAtIndex:arrind] setValue:self.txtField.text forKey:@"toDate"];
            self.ischangedflag = YES;                    
        }
    }
    
    [self.tableView reloadData];
   
}


@end
