//
//  MBShowBillVC.m
//  KichenCalender
//
//  Created by Swapnil Takalkar on 8/1/13.
//  Copyright (c) 2013 mobi. All rights reserved.
//

#import "MBShowBillVC.h"


@interface MBShowBillVC ()

@end

@implementation MBShowBillVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.model = [[MBKCModel alloc] init];
    
    if (self.billtype == 0)
    {
        self.title = @"Milk Bill";
        self.billarray = [self.model getMilkBillFrom:self.frmdt Till:self.todt];
        
//        NSLog(@"self.billarray %@",self.billarray);

        // returns array with these elements sections, Rs, total bill, {title,rate,delivery charge,quantity,bill amount}
        
        self.milkarr = [self.billarray objectAtIndex:3];
//        NSLog(@"self.milkarr %@",self.milkarr);
    }
    else if (self.billtype == 1)
    {
        self.title = @"Laundry Bill";
    }
    else
    {
        self.title = @"Paper Bill";
    }
    
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
    NSUInteger sect = [[self.billarray objectAtIndex:0] integerValue];
    return (sect+1);
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section > 0)
    {
        NSDictionary* dict = [self.milkarr objectAtIndex:(section-1)];
        return [dict objectForKey:@"title"];
    }
    else
    {
        return @"";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 3;
    }
    else
        return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    NSDateFormatter* dformat = [[NSDateFormatter alloc] init];
    [dformat setDateFormat:@"MMM dd, yyyy"];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(180, 15, 120, 20)];
    label.backgroundColor = [UIColor clearColor];
    
    // Configure the cell...
    if (indexPath.section == 0)
    {
        // Just put from date, to date and no. of days here.
        if (indexPath.row == 0)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell1" forIndexPath:indexPath];
            cell.textLabel.text = @"From Date      : ";
            label.text = [NSString stringWithFormat:@"%@",[dformat stringFromDate:self.frmdt]];
        }
        if (indexPath.row == 1)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell1" forIndexPath:indexPath];            
            cell.textLabel.text = @"To Date        : ";
            label.text = [NSString stringWithFormat:@"%@",[dformat stringFromDate:self.todt]];
        }
        if (indexPath.row == 2)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell2" forIndexPath:indexPath];            
            cell.textLabel.text = @"Total Bill Rs. : ";
            label.text = [NSString stringWithFormat:@"%@",[self.billarray objectAtIndex:2]];
        }
    }
    else
    {
        NSUInteger arrct = indexPath.section - 1;
        NSDictionary* dict = [self.milkarr objectAtIndex:arrct];
        
        if (indexPath.row == 0)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell1" forIndexPath:indexPath];            
            cell.textLabel.text = @"Quantity Ltr : ";
            label.text = [dict objectForKey:@"quantity"];
        }
        if (indexPath.row == 1)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell2" forIndexPath:indexPath];            
            cell.textLabel.text = @"Bill Rs.       : ";
            label.text = [dict objectForKey:@"billamt"];
        }
    }
    
    [cell addSubview:label];
    
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
