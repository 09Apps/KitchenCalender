//
//  MBAddLaundryDVC.m
//  KichenCalender
//
//  Created by Swapnil Takalkar on 8/31/13.
//  Copyright (c) 2013 09Apps. All rights reserved.
//

#import "MBAddLaundryDVC.h"

@interface MBAddLaundryDVC ()

@end

@implementation MBAddLaundryDVC

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
    
    self.navigationItem.title = @"Add laundry details";

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(AddLaundry)];
    self.navigationItem.leftBarButtonItem = saveButton;
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cencelAdd)];
    self.navigationItem.rightBarButtonItem = cancelButton;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    }
    else
    {
        self.navigationController.navigationBar.tintColor = [UIColor brownColor];
    }
    
    self.ctdict = [[NSMutableDictionary alloc] init];
    
    self.isaddedflag = NO;
    self.isDateAddedFlag = NO;
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)] ;
    [self.view addGestureRecognizer:tap];
  
                       
    self.segcontrol =[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"No",@"Yes", nil]];
    //[self.segcontrol setSegmentedControlStyle:UISegmentedControlStyleBar];
    [self.segcontrol setFrame:CGRectMake(170, 60, 70, 25)];
    [self.ctdict setValue:@"0" forKey:@"returned"];
    [self.segcontrol setTintColor:[UIColor whiteColor]];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.shared = [MBGADMasterVC singleton];
    [self.shared resetAdView:self];
}

 

- (void)tapped
{
    [self.view endEditing:YES];
}

- (void)AddLaundry
{
    [self.view endEditing:YES];
    
    if (self.isaddedflag == YES && self.isDateAddedFlag == YES)
    {
        NSUInteger totalcloth = [[self.ctdict objectForKey:@"press"] integerValue] +
        [[self.ctdict objectForKey:@"wash"] integerValue] +
        [[self.ctdict objectForKey:@"dryclean"] integerValue] +
        [[self.ctdict objectForKey:@"saree"] integerValue] +
        [[self.ctdict objectForKey:@"starch"] integerValue] +          
        [[self.ctdict objectForKey:@"bleach"] integerValue] ;
        
        [self.ctdict setValue:[NSString stringWithFormat:@"%lu",(unsigned long)totalcloth] forKey:@"totalcloth"];
        
        [self.delegate addLaundry:self didFinishAddingException:self.ctdict];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter date & laundry details." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)cencelAdd
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.txtfld = [[UITextField alloc] initWithFrame:CGRectMake(160, 60, 100, 20)];
    self.txtfld.delegate = self;
    self.txtfld.returnKeyType = UIReturnKeyNext;
    self.txtfld.textAlignment = NSTextAlignmentRight;
    self.txtfld.tag = [indexPath row];
    self.txtfld.adjustsFontSizeToFitWidth = YES;

    // Configure the cell...
    switch ([indexPath row])
    {
        case 0:
        {
            cell.textLabel.text = @"Date                        : ";
            [cell setAccessoryView:self.txtfld];
            
            UIDatePicker *datePicker = [[UIDatePicker alloc]init];
            [datePicker setDatePickerMode:UIDatePickerModeDate];
            
            NSDateFormatter* dateformat = [[NSDateFormatter alloc] init];
            [dateformat setDateFormat:@"MMM dd, yyyy"];
            
            [datePicker setDate:[NSDate date]];
            
            [datePicker setTag:self.txtfld.tag];
            [datePicker addTarget:self action:@selector(getDate:) forControlEvents:UIControlEventValueChanged];
            [self.txtfld setInputView:datePicker];
            self.txtfld.placeholder = @"On Date";            
            self.txtfld.text = [self.ctdict objectForKey:@"ondate"];
            break;
        }
        case 1:
            self.txtfld.placeholder = @"0";
            cell.textLabel.text = @"For Press                : ";
            [cell setAccessoryView:self.txtfld];
            self.txtfld.text = [self.ctdict objectForKey:@"press"];            
            self.txtfld.keyboardType = UIKeyboardTypeNumberPad;
            break;
            
        case 2:
            self.txtfld.placeholder = @"0";
            cell.textLabel.text = @"For Wash n' Press : ";
            [cell setAccessoryView:self.txtfld];
            self.txtfld.text = [self.ctdict objectForKey:@"wash"];
            self.txtfld.keyboardType = UIKeyboardTypeNumberPad;
            break;
            
        case 3:
            self.txtfld.placeholder = @"0";
            cell.textLabel.text = @"For DryClean          : ";
            [cell setAccessoryView:self.txtfld];
            self.txtfld.text = [self.ctdict objectForKey:@"dryclean"];            
            self.txtfld.keyboardType = UIKeyboardTypeNumberPad;                        
            break;
            
        case 4:
            self.txtfld.placeholder = @"0";
            cell.textLabel.text = @"For Bleach              : ";
            [cell setAccessoryView:self.txtfld];
            self.txtfld.text = [self.ctdict objectForKey:@"bleach"];            
            self.txtfld.keyboardType = UIKeyboardTypeNumberPad;                        
            break;
            
        case 5:
            self.txtfld.placeholder = @"0";
            cell.textLabel.text = @"For Saree                : ";
            [cell setAccessoryView:self.txtfld];
            self.txtfld.text = [self.ctdict objectForKey:@"saree"];            
            self.txtfld.keyboardType = UIKeyboardTypeNumberPad;                        
            break;
            
        case 6:
            self.txtfld.placeholder = @"0";
            cell.textLabel.text = @"For Starch               : ";
            [cell setAccessoryView:self.txtfld];
            self.txtfld.text = [self.ctdict objectForKey:@"starch"];
            self.txtfld.keyboardType = UIKeyboardTypeNumberPad;
            break;
            
        case 7:
            cell.textLabel.text = @"Returned ?              : ";
            [cell setAccessoryView:self.segcontrol];
            [self.segcontrol setSelectedSegmentIndex:[[self.ctdict objectForKey:@"returned"] integerValue]];
            [self.segcontrol addTarget:self action:@selector(isReturned:) forControlEvents:UIControlEventValueChanged];
            break;
            
        default:
            break;
    }
    
    // Set backgroundcolor
    cell.backgroundColor = [UIColor colorWithRed:.1 green:.1 blue:.1 alpha:.2];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.opaque = NO;
    // Set placeholder color
    [self.txtfld setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    self.txtfld.textColor = [UIColor whiteColor];
    
    return cell;
}

- (void)isReturned:(UISegmentedControl *)sender
{
    NSString* str = [NSString stringWithFormat:@"%ld",(long)sender.selectedSegmentIndex];
    if (sender.selectedSegmentIndex == 0)
    {
        [sender setTintColor:[UIColor whiteColor]];
    }
    else
    {
        [sender setTintColor:[UIColor lightGrayColor]];
    }
    
    [self.ctdict setValue:str forKey:@"returned"];
}

-(void) getDate:(id)sender
{
    UIDatePicker* datepicker = (UIDatePicker*) sender;
    NSDateFormatter* dformat = [[NSDateFormatter alloc] init];
    [dformat setDateFormat:@"MMM dd, yyyy"];
    self.isDateAddedFlag = YES;    
    [self.ctdict setValue:[NSString stringWithFormat:@"%@",[dformat stringFromDate:datepicker.date]] forKey:@"ondate"];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag)
    {
        case 0:
            [self.tableView reloadData];
            break;
            
        case 1:
            [self.ctdict setValue:textField.text forKey:@"press"];
            self.isaddedflag = YES;
            [textField resignFirstResponder];
            break;
            
        case 2:
            [self.ctdict setValue:textField.text forKey:@"wash"];
            self.isaddedflag = YES;
            [textField resignFirstResponder];
            break;
            
        case 3:
            [self.ctdict setValue:textField.text forKey:@"dryclean"];
            self.isaddedflag = YES;
            [textField resignFirstResponder];
            break;
            
        case 4:
            [self.ctdict setValue:textField.text forKey:@"bleach"];
            self.isaddedflag = YES;
            [textField resignFirstResponder];
            break;
            
        case 5:
            [self.ctdict setValue:textField.text forKey:@"saree"];
            self.isaddedflag = YES;
            [textField resignFirstResponder];
            break;
            
        case 6:
            [self.ctdict setValue:textField.text forKey:@"starch"];
            self.isaddedflag = YES;
            [textField resignFirstResponder];
            break;
            
        default:
            break;
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
