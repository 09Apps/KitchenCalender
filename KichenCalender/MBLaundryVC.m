//
//  MBLaundryVC.m
//  KichenCalender
//
//  Created by Swapnil Takalkar on 8/17/13.
//  Copyright (c) 2013 mobi. All rights reserved.
//

#import "MBLaundryVC.h"
#import "MBSetLaundryVC.h"
#import "MBAddLaundryVC.h"


@interface MBLaundryVC ()

@end

@implementation MBLaundryVC

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

    self.title = @"Laundry";
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addLaundry)];

    UIImage *confimg = [UIImage imageNamed:@"simple_gears.png"];
    
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithImage:confimg style:UIBarButtonItemStyleBordered target:self action:@selector(setupLaundry)];
      
    self.navigationItem.rightBarButtonItems = @[settingsButton, addButton];
    
    // Get Currency, array count and laundry data
    
    self.model = [[MBKCModel alloc] init];
    
    NSMutableArray* laundry = [self.model getOtherDetails:LAUNDRYCAT];
    
    //self.sect = [[laundry objectAtIndex:1] integerValue];
    
    NSDictionary* dict = [laundry objectAtIndex:2];
    
    self.countarr = [dict objectForKey:@"counts"];

    self.ratearr = [dict objectForKey:@"rates"];
    
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

- (void)addLaundry
{
    MBAddLaundryVC *addlaundry = [[MBAddLaundryVC alloc] init];
    addlaundry.delegate = self;
    [addlaundry setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentViewController:addlaundry animated:YES completion:nil];
}

- (void)setupLaundry
{
    MBSetLaundryVC *setlaundry = [[MBSetLaundryVC alloc] initWithRates:self.ratearr];
    [self.navigationController pushViewController:setlaundry animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.countarr count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 63;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    NSDictionary* dict = [self.countarr objectAtIndex:indexPath.row];
    
    if ([[dict objectForKey:@"totalcloth"] integerValue] != 0)
    {
        [cell.textLabel setText:[dict objectForKey:@"ondate"]];
        
        NSString* subtitle =@"Total:";

        subtitle = [subtitle stringByAppendingString:[dict objectForKey:@"totalcloth"]];
    
        if ([[dict objectForKey:@"press"] integerValue] != 0)
        {
            subtitle = [subtitle stringByAppendingString:@" Press:"];                 
            subtitle = [subtitle stringByAppendingString:[dict objectForKey:@"press"]];
        }

        if ([[dict objectForKey:@"wash"] integerValue] != 0)
        {
            subtitle = [subtitle stringByAppendingString:@" Wash:"];            
            subtitle = [subtitle stringByAppendingString:[dict objectForKey:@"wash"]];
        }

        if ([[dict objectForKey:@"dryclean"] integerValue] != 0)
        {
            subtitle = [subtitle stringByAppendingString:@" DryClean:"];               
            subtitle = [subtitle stringByAppendingString:[dict objectForKey:@"dryclean"]];
        }

        if ([[dict objectForKey:@"bleach"] integerValue] != 0)
        {
            subtitle = [subtitle stringByAppendingString:@" Bleach:"];                   
            subtitle = [subtitle stringByAppendingString:[dict objectForKey:@"bleach"]];
        }
        
        [cell.detailTextLabel setText:subtitle];
        [cell.detailTextLabel setNumberOfLines:2];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{    
    return @"";
}


- (void)addLaundry:(MBAddLaundryVC *)controller didFinishAddingException:(NSDictionary *)item
{
    [self.countarr addObject:item];
    
    [self.tableView reloadData];
} 

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source
        [self.countarr removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadData];        
    }      
}


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
