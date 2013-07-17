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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
    
    [self.view addGestureRecognizer:tap];
    
    self.milk1 = [[NSMutableDictionary alloc] init];
    self.milk2 = [[NSMutableDictionary alloc] init];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStepper *stepper =[[UIStepper alloc] initWithFrame:CGRectMake(200, 60, 50, 20)];
    
    int sectionCount = 0;
    
    if ([indexPath section] == 1)  sectionCount = 10;  // This is to manage tags of the textfields
    
    switch ([indexPath row])
    {
        case 0:
            // Cell1 is re-usable cell for textfield based cells
            self.cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell1"];            
            self.txtField = [[UITextField alloc] initWithFrame:CGRectMake(135, 60, 130, 20)];
            self.txtField.delegate = self;
            
            self.txtField.placeholder = @"e.g. Amul milk";
            self.txtField.keyboardType = UIKeyboardTypeNamePhonePad;
            self.txtField.returnKeyType = UIReturnKeyNext;
            self.txtField.textAlignment = NSTextAlignmentRight;
            self.txtField.tag = sectionCount + [indexPath row];
            self.txtField.adjustsFontSizeToFitWidth = YES;
            
            if ([indexPath section] == 0)
                self.txtField.text = [self.milk1 objectForKey:@"Title"];
            else
                self.txtField.text = [self.milk2 objectForKey:@"Title"];

            self.cell.textLabel.text = @"Title ";
            self.cell.accessoryView = self.txtField;
            self.cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            break;
        
        case 1:
            self.cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell1"];            
            self.txtField = [[UITextField alloc] initWithFrame:CGRectMake(135, 60, 130, 20)];
            self.txtField.delegate = self;
            
            self.txtField.placeholder = @"Rs per ltr";
            self.txtField.keyboardType = UIKeyboardTypeDecimalPad;
            self.txtField.returnKeyType = UIReturnKeyNext;
            self.txtField.textAlignment = NSTextAlignmentRight;            
            self.txtField.tag = sectionCount + [indexPath row];
            [self.txtField setEnabled: YES];
            
            if ([indexPath section] == 0)
                self.txtField.text = [self.milk1 objectForKey:@"Rate"];
            else
                self.txtField.text = [self.milk2 objectForKey:@"Rate"];
            
            self.cell.textLabel.text = @"Rate per ltr";
            self.cell.accessoryView = self.txtField;
            self.cell.selectionStyle = UITableViewCellSelectionStyleNone;

            break;

        case 2:
            self.cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell2"];            
            [stepper setStepValue:0.25];
            self.cell.textLabel.text = @"Quantity per day";
            self.cell.accessoryView = stepper;
            [stepper addTarget:self action:@selector(stepperPressed:) forControlEvents:UIControlEventValueChanged];
            
            self.cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;

        case 3:
            self.cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell1"];            
            self.txtField = [[UITextField alloc] initWithFrame:CGRectMake(135, 60, 130, 20)];
            self.txtField.delegate = self;
            
            self.txtField.placeholder = @"Rs per month";
            self.txtField.keyboardType = UIKeyboardTypeNumberPad;
            self.txtField.returnKeyType = UIReturnKeyNext;
            self.txtField.textAlignment = NSTextAlignmentRight;            
            self.txtField.tag = sectionCount + [indexPath row];
            
            if ([indexPath section] == 0)
                self.txtField.text = [self.milk1 objectForKey:@"DeliveryCharge"];
            else
                self.txtField.text = [self.milk2 objectForKey:@"DeliveryCharge"];
            
            self.cell.textLabel.text = @"Delivery Charges";
            self.cell.accessoryView = self.txtField;
            self.cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            break;

        case 4:
            self.cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell1"];
            self.txtField = [[UITextField alloc] initWithFrame:CGRectMake(135, 60, 130, 20)];
            self.txtField.delegate = self;
            
            self.txtField.placeholder = @"effective from date";
            self.txtField.textAlignment = NSTextAlignmentRight;            
            self.txtField.tag = sectionCount + [indexPath row];
            self.txtField.adjustsFontSizeToFitWidth = YES;            
                
            self.cell.textLabel.text = @"From Date ";
            self.cell.accessoryView = self.txtField;
            self.cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            break;

        case 5:
            self.cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell3"];            
            self.cell.textLabel.text = @"Add exceptions ";
            [self.cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
            break;

                
        default:
            break;
    }
    
    return self.cell;
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
            [self.milk1 setValue:textField.text forKey:@"Title"];
            break;
                
        case 1:
            [self.milk1 setValue:textField.text forKey:@"Rate"];
            break;
                
        case 3:
            [self.milk1 setValue:textField.text forKey:@"DeliveryCharge"];
            break;
                
        case 10:
            [self.milk2 setValue:textField.text forKey:@"Title"];
            break;
            
        case 11:
            [self.milk2 setValue:textField.text forKey:@"Rate"];
            break;
            
        case 13:
            [self.milk2 setValue:textField.text forKey:@"DeliveryCharge"];
            break;
            
        default:
            break;
        }
}



- (IBAction)stepperPressed:(UIStepper *)sender
{    
    self.cell.textLabel.text = [NSString stringWithFormat:@"%.2f",sender.value];
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

@end
