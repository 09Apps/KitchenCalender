//
//  MBShowBillVC.m
//  KichenCalender
//
//  Created by Swapnil Takalkar on 8/1/13.
//  Copyright (c) 2013 09Apps. All rights reserved.
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
    
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"board_back.png"]];
    
    self.model = [[MBKCModel alloc] init];
    
    if (self.billtype == 0)
    {
        self.title = @"Milk Bill";
        self.billarray = [self.model getMilkBillFrom:self.frmdt Till:self.todt];

        // returns array with these elements sections, Rs, total bill, {title,rate,delivery charge,quantity,bill amount}
        self.element = [self.billarray objectAtIndex:3];
    }
    else if (self.billtype == 1)
    {
        self.title = @"Laundry Bill";
        self.element = [self.model getLaundryBillFrom:self.frmdt Till:self.todt];
    }
    else
    {
        self.title = @"Paper Bill";
        self.billarray =[self.model getPaperBillFrom:self.frmdt Till:self.todt];
        self.element = [self.billarray objectAtIndex:3];
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
    if (self.billtype == 1)
    {
        return 2;
    }
    else
    {
        NSUInteger sect = [[self.billarray objectAtIndex:0] integerValue];
        return (sect+1);
    }
}

/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section > 0)
    {
        NSDictionary* dict = [self.element objectAtIndex:(section-1)];
        return [dict objectForKey:@"title"];
    }
    else
    {
        return @"Bill Summary";
    }
}

*/

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *customTitleView = [ [UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 44)];
    
    UILabel *titleLabel = [ [UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 44)];
    
    if (section > 0)
    {
        NSDictionary* dict = [self.element objectAtIndex:(section-1)];
        titleLabel.text =  [dict objectForKey:@"title"];
    }
    else
    {
        titleLabel.text =  @"Bill Summary";
    }
    
    titleLabel.textColor = [UIColor whiteColor];
    
    titleLabel.backgroundColor = [UIColor clearColor];
    
    [customTitleView addSubview:titleLabel];
    
    return customTitleView;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0)
    {
        // first section has 3 rows - from date, to date and total bill
        return 3;
    }
    else
    {
        if (self.billtype == 2)
        {
            // for newspaper , we just have two row
            return 2;
        }
        else if (self.billtype == 0)
        {
            // For milk we have 3 rows
            return 3;
        }
        else
        {
            // Laundry has 9 rows
            // count of press, wash, dryclean, bleach, saree, starch, laundry cost, delivery charge & clothes not returned
            return 9;
        }

    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    NSDateFormatter* dformat = [[NSDateFormatter alloc] init];
    [dformat setDateFormat:@"MMM dd, yyyy"];
    
    // Configure the cell...
    if (indexPath.section == 0)
    {
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(180, 13, 120, 20)];
        label.backgroundColor = [UIColor clearColor];
        
        // Just put from date, to date and Total bill here.
        if (indexPath.row == 0)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell1" forIndexPath:indexPath];
            cell.textLabel.text = @"From Date      : ";
            label.text = [NSString stringWithFormat:@"%@",[dformat stringFromDate:self.frmdt]];
        }
        if (indexPath.row == 1)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell1" forIndexPath:indexPath];            
            cell.textLabel.text = @"To Date           : ";
            label.text = [NSString stringWithFormat:@"%@",[dformat stringFromDate:self.todt]];
        }
        if (indexPath.row == 2)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell1" forIndexPath:indexPath];            
            cell.textLabel.text = @"Total Bill Rs.  : ";
            
            if (self.billtype == 1)
            {
                label.text = [[self.element objectAtIndex:0] objectForKey:@"totalbill"];
            }
            else
            {
                label.text = [NSString stringWithFormat:@"%@",[self.billarray objectAtIndex:2]];
            }
        }
        [cell addSubview:label];
    }
    else
    {
        NSUInteger arrct = indexPath.section - 1;
        NSDictionary* dict = [self.element objectAtIndex:arrct];
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell2" forIndexPath:indexPath];
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(232, 13, 70, 20)];
        label.backgroundColor = [UIColor clearColor];
        
        if (self.billtype == 2)
        {
            if (indexPath.row == 0)
            {
                cell.textLabel.text = @"Paper cost Rs.      :  ";
                label.text = [dict objectForKey:@"billamt"];
            }
            else if (indexPath.row == 1)
            {
                cell.textLabel.text = @"Delivery Charge Rs.: ";
                label.text = [dict objectForKey:@"deliveryCharge"];
            }
        }
        else if (self.billtype == 0)
        {
            // two rows for milk 
            if (indexPath.row == 0)
            {
                cell.textLabel.text = @"Quantity Ltr   :    ";
                label.text = [dict objectForKey:@"quantity"];
            }
            else if (indexPath.row == 1)
            {
                cell.textLabel.text = @"Milk cost Rs.  : ";
                label.text = [dict objectForKey:@"billamt"];
            }
            else 
            {
                cell.textLabel.text = @"Delivery Charge Rs.: ";
                label.text = [dict objectForKey:@"deliveryCharge"];
            }
        }
        else
        {
            // Laundry has 9 rows
            
            switch (indexPath.row)
            {
                case 0:
                    cell.textLabel.text = @"Pressed clothes                : ";
                    label.text = [dict objectForKey:@"presscount"];
                    break;

                case 1:
                    cell.textLabel.text = @"Drycleaned clothes          : ";
                    label.text = [dict objectForKey:@"drycleancount"];
                    break;
                    
                case 2:
                    cell.textLabel.text = @"Wash n' Pressed clothes : ";
                    label.text = [dict objectForKey:@"washcount"];
                    break;
                    
                case 3:
                    cell.textLabel.text = @"Bleached clothes             : ";
                    label.text = [dict objectForKey:@"bleachcount"];
                    break;

                case 4:
                    cell.textLabel.text = @"Sarees                               : ";
                    label.text = [dict objectForKey:@"sareecount"];
                    break;
                    
                case 5:
                    cell.textLabel.text = @"Starch                               : ";
                    label.text = [dict objectForKey:@"starchcount"];
                    break;
                    
                case 6:
                    cell.textLabel.text = @"Laundry Bill                      : ";
                    label.text = [dict objectForKey:@"laundrybill"];
                    break;
                    
                case 7:
                    cell.textLabel.text = @"Delivery charge                : ";
                    label.text = [dict objectForKey:@"deliveryCharge"];
                    break;

                case 8:
                    cell.textLabel.text = @"Clothes Not Returned     : ";
                    label.text = [dict objectForKey:@"notreturncount"];
                    label.textColor = [UIColor redColor];
                    break;
                    
                default:
                    break;
            }
            
        }
        [cell addSubview:label];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Set backgroundcolor
    cell.backgroundColor = [UIColor colorWithRed:.1 green:.1 blue:.1 alpha:.2];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.opaque = NO;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
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
