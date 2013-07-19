//
//  MilkViewController.m
//  KichenCalender
//
//  Created by Swapnil Takalkar on 7/16/13.
//  Copyright (c) 2013 mobi. All rights reserved.
//

#import "MilkViewController.h"

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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
    
    [self.view addGestureRecognizer:tap];
    
    self.milk1 = [self.model getMilkDetails:1];
    self.milk2 = [self.model getMilkDetails:2];

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addSection)];
    
    self.navigationItem.rightBarButtonItem = addButton;
    
    [self.navigationItem.leftBarButtonItem setTitle:@"Save"];

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
    return [self.model.sections integerValue];
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
    
    int sectionCount = 0; 
    
    if ([indexPath section] == 1)  sectionCount = 10;  // This is to manage tags of the textfields
    
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
            
            if ([indexPath section] == 0)
                self.txtField.text = [self.milk1 objectForKey:@"title"];
            else
                self.txtField.text = [self.milk2 objectForKey:@"title"];

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
            
            if ([indexPath section] == 0)
                self.txtField.text = [self.milk1 objectForKey:@"rate"];
            else
                self.txtField.text = [self.milk2 objectForKey:@"rate"];
            
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
            
            if ([indexPath section] == 0)
            {
                quantitylbl.text = [self.milk1 objectForKey:@"quantity"];
            }
            else
            {
                quantitylbl.text = [self.milk2 objectForKey:@"quantity"];
            }

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
            
            if ([indexPath section] == 0)
                self.txtField.text = [self.milk1 objectForKey:@"deliveryCharge"];
            else
                self.txtField.text = [self.milk2 objectForKey:@"deliveryCharge"];
            
            cell.textLabel.text = @"Delivery Charges";
            [cell setAccessoryView:self.txtField];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            break;

        case 4:
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell1"];
            self.txtField = [[UITextField alloc] initWithFrame:CGRectMake(135, 60, 130, 20)];
            self.txtField.delegate = self;
            
            self.txtField.placeholder = @"effective from date";
            self.txtField.textAlignment = NSTextAlignmentRight;            
            self.txtField.tag = sectionCount + [indexPath row];
            self.txtField.adjustsFontSizeToFitWidth = YES;            
                
            cell.textLabel.text = @"From Date ";
            [cell setAccessoryView:self.txtField];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            break;

        case 5:
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell3"];            
            cell.textLabel.text = @"Add exceptions ";
            [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
            break;

        default:
            break;
    }
    
    return cell;
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

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // Save the values from textfields. If Tag is 0 to 9 means it is coming from 1st section
    // If tag value is more than 10 means it is coming from 2nd section to save it to milk2
    
    switch (textField.tag)
    {
        case 0:
            [self.milk1 setValue:textField.text forKey:@"title"];        
            break;
                
        case 1:
            [self.milk1 setValue:textField.text forKey:@"rate"];
            break;
                
        case 3:
            [self.milk1 setValue:textField.text forKey:@"deliveryCharge"];
            break;
                
        case 10:
            [self.milk2 setValue:textField.text forKey:@"title"];
            break;
            
        case 11:
            [self.milk2 setValue:textField.text forKey:@"rate"];
            break;
            
        case 13:
            [self.milk2 setValue:textField.text forKey:@"deliveryCharge"];
            break;
            
        default:
            break;
        }
    

}

- (IBAction)stepperPressed:(UIStepper *)sender
{
//    double stepval = sender.value + sender.stepValue;
    NSString* strval = [NSString stringWithFormat:@"%.2f",sender.value];
    
    if (sender.tag == 0)
        [self.milk1 setValue:strval forKey:@"quantity"];
    else
        [self.milk2 setValue:strval forKey:@"quantity"];

    [self.tableView reloadData];
}

- (void)addSection
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Milk" message:@"Do you wish to add one more milk details?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    
    [alert show];
    
    // DO only if users says yes in alert. Check alert's method.
}

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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        self.model.sections = @"2";
        self.navigationItem.rightBarButtonItem = nil;
        [self.tableView reloadData];
        
        [self.model setMilkDetailsWithMilk1:self.milk1 AndMilk2:self.milk2];
    }
    
    // Do nothing if users says No to add milk
}

@end
