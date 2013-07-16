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
    
    UITextField *txtField = [[UITextField alloc] initWithFrame:CGRectMake(135, 60, 130, 20)];
    UIStepper *stepper =[[UIStepper alloc] initWithFrame:CGRectMake(200, 60, 50, 20)];
    
    switch ([indexPath row])
    {
        case 0:
            txtField.placeholder = @"e.g. Amul milk";
            txtField.keyboardType = UIKeyboardTypeNamePhonePad;
            txtField.returnKeyType = UIReturnKeyNext;
//          txtField.tag = [indexPath row];
            txtField.adjustsFontSizeToFitWidth = YES;

            cell.textLabel.text = @"Title ";
            cell.accessoryView = txtField;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            break;

        case 1:
            txtField.placeholder = @"Rs per ltr";
            txtField.keyboardType = UIKeyboardTypeDecimalPad;
            txtField.returnKeyType = UIReturnKeyNext;
//          txtField.tag = [indexPath row];
            [txtField setEnabled: YES];

            cell.textLabel.text = @"Rate per ltr";
            cell.accessoryView = txtField;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            break;

        case 2:
            [stepper setStepValue:0.25];
            cell.textLabel.text = @"Quantity per day";
            cell.accessoryView = stepper;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;

        case 3:
            txtField.placeholder = @"Rs per month";
            txtField.keyboardType = UIKeyboardTypeNumberPad;
            txtField.returnKeyType = UIReturnKeyNext;
//          txtField.tag = [indexPath row];
            
            cell.textLabel.text = @"Delivery Charges";
            cell.accessoryView = txtField;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            break;

        case 4:

            txtField.placeholder = @"effective from date";
//          txtField.tag = [indexPath row];
                
            cell.textLabel.text = @"From Date ";
            cell.accessoryView = txtField;
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
