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
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
        
    self.txtField = [[UITextField alloc] initWithFrame:CGRectMake(135, 60, 130, 20)];
    self.txtField.delegate = self;
    
    UIStepper *stepper =[[UIStepper alloc] initWithFrame:CGRectMake(200, 60, 50, 20)];
    
    int sectionCount = 0;
    
    if ([indexPath section] == 1)  sectionCount = 10;  // This is to manage tags of the textfields
    
    
    switch ([indexPath row])
    {
        case 0:
            self.txtField.placeholder = @"e.g. Amul milk";
            self.txtField.keyboardType = UIKeyboardTypeNamePhonePad;
            self.txtField.returnKeyType = UIReturnKeyNext;
            self.txtField.tag = sectionCount + [indexPath row];
            self.txtField.adjustsFontSizeToFitWidth = YES;
            
            if ([indexPath section] == 0)
                self.txtField.text = [self.milk1 objectForKey:@"Title"];
            else
                self.txtField.text = [self.milk2 objectForKey:@"Title"];

            cell.textLabel.text = @"Title ";
            cell.accessoryView = self.txtField;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            break;
        
        case 1:
            self.txtField.placeholder = @"Rs per ltr";
            self.txtField.keyboardType = UIKeyboardTypeDecimalPad;
            self.txtField.returnKeyType = UIReturnKeyNext;
            self.txtField.tag = sectionCount + [indexPath row];
            [self.txtField setEnabled: YES];
            
            if ([indexPath section] == 0)
                self.txtField.text = [self.milk1 objectForKey:@"Rate"];
            else
                self.txtField.text = [self.milk2 objectForKey:@"Rate"];
            
            cell.textLabel.text = @"Rate per ltr";
            cell.accessoryView = self.txtField;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            break;

        case 2:
            [stepper setStepValue:0.25];
            cell.textLabel.text = @"Quantity per day";
            cell.accessoryView = stepper;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;

        case 3:
            self.txtField.placeholder = @"Rs per month";
            self.txtField.keyboardType = UIKeyboardTypeNumberPad;
            self.txtField.returnKeyType = UIReturnKeyNext;
            self.txtField.tag = sectionCount + [indexPath row];
            
            if ([indexPath section] == 0)
                self.txtField.text = [self.milk1 objectForKey:@"DeliveryCharge"];
            else
                self.txtField.text = [self.milk2 objectForKey:@"DeliveryCharge"];
            
            cell.textLabel.text = @"Delivery Charges";
            cell.accessoryView = self.txtField;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            break;

        case 4:
            self.txtField.placeholder = @"effective from date";
            self.txtField.tag = sectionCount + [indexPath row];
                
            cell.textLabel.text = @"From Date ";
            cell.accessoryView = self.txtField;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            break;

        case 5:
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
