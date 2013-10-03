//
//  MBSetLaundryVC.m
//  KichenCalender
//
//  Created by Swapnil Takalkar on 8/19/13.
//  Copyright (c) 2013 09Apps. All rights reserved.
//

#import "MBSetLaundryVC.h"
#import "MBKCModel.h"

@interface MBSetLaundryVC ()

@end

@implementation MBSetLaundryVC

- (id)initWithRates:(NSMutableArray*) ratearr
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        self.rates = ratearr;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"board_back.png"]];    
    
    UIImage *image = [UIImage imageNamed: @"NavBar-Wood.png"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics: UIBarMetricsDefault];

    self.navigationItem.title = @"Laundry Setup";

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addSection)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveData)];
    self.navigationItem.leftBarButtonItem = saveButton;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    }
    else
    {
        self.navigationController.navigationBar.tintColor = [UIColor brownColor];
    }
    
    self.sect = [self.rates count];
    self.ischangedflag = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addSection
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Set New Rate" message:@"Only one rate can be active at one time. End previous rate by setting To Date and start new rate with From Date as at least a day later than To Date of earlier rate. Use From Date and To Date to manage active rates" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alert setTag:ADDSECTIONTAG];
    [alert show];
    
    // DO only if users says yes in alert. Check alert's method.
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == ADDSECTIONTAG)
    {
        // This means user is adding one more section
        if (buttonIndex == 1)
        {
            self.sect++;
            NSMutableDictionary* ratedict = [[NSMutableDictionary alloc] init];
            [self.rates addObject:ratedict];
            
            [self.view endEditing:YES];
            [self saveTextField:self.txtField];
            self.ischangedflag = YES;
            [self.tableView reloadData];
        }
    }
    else
    {
        // means user is trying to exit without entering from date and rates
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)saveData
{
    if ( ([[self.rates objectAtIndex:0] objectForKey:@"fromDate"] == nil) ||
         ([[self.rates objectAtIndex:0] objectForKey:@"press"] == 0) )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Set Details" message:@"Please atleast set From Date & Press rate." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        // Save and exit
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (self.sect == 0)
    {
        return 1;
    }
    else
    {
        return self.sect;
    }
}

/*
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *customTitleView = [ [UIView alloc] initWithFrame:CGRectMake(10, 0, 100, 44)];
    
    UILabel *titleLabel = [ [UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    
    titleLabel.text = @"  Set Rates ";
    
    titleLabel.textColor = [UIColor whiteColor];
    
    titleLabel.backgroundColor = [UIColor clearColor];
    
    [customTitleView addSubview:titleLabel];
    
    return customTitleView;
}
 */

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    NSMutableDictionary* ratedict = [[NSMutableDictionary alloc] init];
    
    ratedict = [self.rates objectAtIndex:[indexPath section]];
    
    int sectionCount = [indexPath section] *10; // This is to manage tags of the textfields
    
    switch ([indexPath row])
    {
        case 0:
        {
            // Cell1 is re-usable cell for textfield based cells
            static NSString *CellIdentifier = @"Cell1";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }

            self.txtField = [[UITextField alloc] initWithFrame:CGRectMake(180, 60, 90, 20)];
            self.txtField.delegate = self;
            
            self.txtField.placeholder = @"Rs. per cloth";
            self.txtField.keyboardType = UIKeyboardTypeDecimalPad;
            self.txtField.returnKeyType = UIReturnKeyNext;
            self.txtField.textAlignment = NSTextAlignmentRight;
            self.txtField.tag = sectionCount + [indexPath row];
            self.txtField.adjustsFontSizeToFitWidth = YES;
            
            self.txtField.text = [ratedict objectForKey:@"press"];
            
            cell.textLabel.text = @"Press                    : ";
            [cell setAccessoryView:self.txtField];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        }
            
        case 1:
        {
            // Cell1 is re-usable cell for textfield based cells
            static NSString *CellIdentifier = @"Cell1";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            self.txtField = [[UITextField alloc] initWithFrame:CGRectMake(180, 60, 90, 20)];
            self.txtField.delegate = self;
            
            self.txtField.placeholder = @"Rs. per cloth";
            self.txtField.keyboardType = UIKeyboardTypeDecimalPad;
            self.txtField.returnKeyType = UIReturnKeyNext;
            self.txtField.textAlignment = NSTextAlignmentRight;
            self.txtField.tag = sectionCount + [indexPath row];
            self.txtField.adjustsFontSizeToFitWidth = YES;
            
            self.txtField.text = [ratedict objectForKey:@"wash"];
            
            cell.textLabel.text = @"Wash & Press      : ";
            [cell setAccessoryView:self.txtField];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        }
            
        case 2:
        {
            // Cell1 is re-usable cell for textfield based cells
            static NSString *CellIdentifier = @"Cell1";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            self.txtField = [[UITextField alloc] initWithFrame:CGRectMake(180, 60, 90, 20)];
            self.txtField.delegate = self;
            
            self.txtField.placeholder = @"Rs. per cloth";
            self.txtField.keyboardType = UIKeyboardTypeDecimalPad;
            self.txtField.returnKeyType = UIReturnKeyNext;
            self.txtField.textAlignment = NSTextAlignmentRight;
            self.txtField.tag = sectionCount + [indexPath row];
            self.txtField.adjustsFontSizeToFitWidth = YES;
            
            self.txtField.text = [ratedict objectForKey:@"dryclean"];
            
            cell.textLabel.text = @"DryClean              : ";
            [cell setAccessoryView:self.txtField];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        }
            
        case 3:
        {
            // Cell1 is re-usable cell for textfield based cells
            static NSString *CellIdentifier = @"Cell1";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            self.txtField = [[UITextField alloc] initWithFrame:CGRectMake(180, 60, 90, 20)];
            self.txtField.delegate = self;
            
            self.txtField.placeholder = @"Rs. per cloth";
            self.txtField.keyboardType = UIKeyboardTypeDecimalPad;
            self.txtField.returnKeyType = UIReturnKeyNext;
            self.txtField.textAlignment = NSTextAlignmentRight;
            self.txtField.tag = sectionCount + [indexPath row];
            self.txtField.adjustsFontSizeToFitWidth = YES;
            
            self.txtField.text = [ratedict objectForKey:@"bleach"];
            
            cell.textLabel.text = @"Bleach                  : ";
            [cell setAccessoryView:self.txtField];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        }

        case 4:
        {
            // Cell1 is re-usable cell for textfield based cells
            static NSString *CellIdentifier = @"Cell1";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            self.txtField = [[UITextField alloc] initWithFrame:CGRectMake(180, 60, 90, 20)];
            self.txtField.delegate = self;
            
            self.txtField.placeholder = @"Rs. per saree";
            self.txtField.keyboardType = UIKeyboardTypeDecimalPad;
            self.txtField.returnKeyType = UIReturnKeyNext;
            self.txtField.textAlignment = NSTextAlignmentRight;
            self.txtField.tag = sectionCount + [indexPath row];
            self.txtField.adjustsFontSizeToFitWidth = YES;
            
            self.txtField.text = [ratedict objectForKey:@"saree"];
            
            cell.textLabel.text = @"Saree                    : ";
            [cell setAccessoryView:self.txtField];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        }
            
        case 5:
        {
            // Cell1 is re-usable cell for textfield based cells
            static NSString *CellIdentifier = @"Cell1";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            self.txtField = [[UITextField alloc] initWithFrame:CGRectMake(180, 60, 90, 20)];
            self.txtField.delegate = self;
            
            self.txtField.placeholder = @"Rs. per cloth";
            self.txtField.keyboardType = UIKeyboardTypeDecimalPad;
            self.txtField.returnKeyType = UIReturnKeyNext;
            self.txtField.textAlignment = NSTextAlignmentRight;
            self.txtField.tag = sectionCount + [indexPath row];
            self.txtField.adjustsFontSizeToFitWidth = YES;
            
            self.txtField.text = [ratedict objectForKey:@"starch"];
            
            cell.textLabel.text = @"Starch                   : ";
            [cell setAccessoryView:self.txtField];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        }
            
        case 6:
        {
            // Cell1 is re-usable cell for textfield based cells
            static NSString *CellIdentifier = @"Cell1";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            self.txtField = [[UITextField alloc] initWithFrame:CGRectMake(180, 60, 90, 20)];
            self.txtField.delegate = self;
            
            self.txtField.placeholder = @"Rs. per month";
            self.txtField.keyboardType = UIKeyboardTypeNumberPad;
            self.txtField.returnKeyType = UIReturnKeyNext;
            self.txtField.textAlignment = NSTextAlignmentRight;
            self.txtField.tag = sectionCount + [indexPath row];
            self.txtField.adjustsFontSizeToFitWidth = YES;
            
            self.txtField.text = [ratedict objectForKey:@"deliveryCharge"];
            
            cell.textLabel.text = @"Delivery charges : ";
            [cell setAccessoryView:self.txtField];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        }
            
        case 7:
        {
            // Cell1 is re-usable cell for textfield based cells
            static NSString *CellIdentifier = @"Cell2";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            self.txtField = [[UITextField alloc] initWithFrame:CGRectMake(180, 60, 90, 20)];
            [self.txtField setDelegate:self];
            self.txtField.placeholder = @"Rate from date";
            self.txtField.textAlignment = NSTextAlignmentRight;
            self.txtField.tag = sectionCount + [indexPath row];
            self.txtField.adjustsFontSizeToFitWidth = YES;
            
            UIDatePicker *datePicker = [[UIDatePicker alloc]init];
            [datePicker setDatePickerMode:UIDatePickerModeDate];
            
            NSDateFormatter* dateformat = [[NSDateFormatter alloc] init];
            [dateformat setDateFormat:@"MMM dd, yyyy"];
            
            self.txtField.text = [ratedict objectForKey:@"fromDate"];
            
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
            
            cell.textLabel.text = @"From Date            : ";
            [cell setAccessoryView:self.txtField];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            break;
        }
            
        case 8:
        {
            // Cell1 is re-usable cell for textfield based cells
            static NSString *CellIdentifier = @"Cell2";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            self.txtField = [[UITextField alloc] initWithFrame:CGRectMake(180, 60, 90, 20)];
            [self.txtField setDelegate:self];
            self.txtField.textAlignment = NSTextAlignmentRight;
            self.txtField.tag = sectionCount + [indexPath row];
            self.txtField.adjustsFontSizeToFitWidth = YES;
            
            UIDatePicker *datePicker = [[UIDatePicker alloc]init];
            [datePicker setDatePickerMode:UIDatePickerModeDate];
            
            NSDateFormatter* dateformat = [[NSDateFormatter alloc] init];
            [dateformat setDateFormat:@"MMM dd, yyyy"];
            
            self.txtField.text = [ratedict objectForKey:@"toDate"];
            NSDate* date = [dateformat dateFromString:self.txtField.text];
            
            if (date == nil)
            {
                self.txtField.text = @"Dec 31, 2100";
                [[self.rates objectAtIndex:indexPath.section] setValue:self.txtField.text forKey:@"toDate"];
                self.ischangedflag = YES;
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
            
            cell.textLabel.text = @"Till Date                : ";
            [cell setAccessoryView:self.txtField];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            break;
        }
            
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
            [[self.rates objectAtIndex:arrind] setValue:textField.text forKey:@"press"];
            self.ischangedflag = YES;
            break;
            
        case 1:
            [[self.rates objectAtIndex:arrind] setValue:textField.text forKey:@"wash"];
            self.ischangedflag = YES;
            break;

        case 2:
            [[self.rates objectAtIndex:arrind] setValue:textField.text forKey:@"dryclean"];
            self.ischangedflag = YES;
            break;

        case 3:
            [[self.rates objectAtIndex:arrind] setValue:textField.text forKey:@"bleach"];
            self.ischangedflag = YES;
            break;
            
        case 4:
            [[self.rates objectAtIndex:arrind] setValue:textField.text forKey:@"saree"];
            self.ischangedflag = YES;
            break;
            
        case 5:
            [[self.rates objectAtIndex:arrind] setValue:textField.text forKey:@"starch"];
            self.ischangedflag = YES;
            break;
            
        case 6:
            [[self.rates objectAtIndex:arrind] setValue:textField.text forKey:@"deliveryCharge"];
            self.ischangedflag = YES;
            break;

        case 7:
            [self.tableView reloadData];
            break;

        case 8:
            [self.tableView reloadData];
            break;
            
        default:
            break;
    }
}

-(void) updateDateField:(UIDatePicker*)sender
{
    NSUInteger arrind = sender.tag/10;
    NSUInteger tagind = sender.tag - (arrind * 10);
    
    NSDateFormatter* dformat = [[NSDateFormatter alloc] init];
    [dformat setDateFormat:@"MMM dd, yyyy"];
    
    self.txtField.text = [NSString stringWithFormat:@"%@",[dformat stringFromDate:sender.date]];
    
    if (tagind == 7)
    {
        [[self.rates objectAtIndex:arrind] setValue:self.txtField.text forKey:@"fromDate"];
        self.ischangedflag = YES;
    }
    else
    {
        // Compare toDate with From Date
        NSString* frmtxt = [[self.rates objectAtIndex:arrind] objectForKey:@"fromDate"];
        
        NSDate* frmdate = [dformat dateFromString:frmtxt];
        
        if([frmdate compare:sender.date] == NSOrderedDescending)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"TillDate should be after FromDate." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            self.txtField.text = @"";
            [alert show];
        }
        else
        {
            [[self.rates objectAtIndex:arrind] setValue:self.txtField.text forKey:@"toDate"];
            self.ischangedflag = YES;
        } 
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
}


    


@end
