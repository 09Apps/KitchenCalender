//
//  MBLaundryVC.m
//  KichenCalender
//
//  Created by Swapnil Takalkar on 8/17/13.
//  Copyright (c) 2013 09Apps. All rights reserved.
//

#import "MBLaundryVC.h"
#import "MBSetLaundryVC.h"
#import "MBAddLaundryDVC.h"


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
    
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"board_back.png"]];    

    UIImage *image = [UIImage imageNamed: @"NavBar-Wood.png"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics: UIBarMetricsDefault];

    self.title = @"Laundry";
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addLaundry)];

    NSString* settingPng;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        settingPng = @"tools1.png";
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    }
    else
    {
        settingPng = @"simple_gears.png";
        self.navigationController.navigationBar.tintColor = [UIColor brownColor];
    }
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveData)];
    self.navigationItem.leftBarButtonItem = doneButton;
    
    UIImage *confimg = [UIImage imageNamed:settingPng];
    
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithImage:confimg style:UIBarButtonItemStyleBordered target:self action:@selector(setupLaundry)];
    
    self.navigationItem.rightBarButtonItems = @[settingsButton, addButton];
    
    // Get Currency, array count and laundry data
    
    self.model = [[MBKCModel alloc] init];
    
    NSMutableArray* laundry = [self.model getLaundryDetails];
    
    NSDictionary* dict = [laundry objectAtIndex:2];
    
    self.countarr = [dict objectForKey:@"counts"];

    self.ratearr = [dict objectForKey:@"rates"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addLaundry
{
    if ([[self.ratearr objectAtIndex:0] objectForKey:@"fromDate"] == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Set Rates" message:@"Please set laundry rates using settings icon before adding details." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        MBAddLaundryDVC *addlaundryc = [[MBAddLaundryDVC alloc] init];
        addlaundryc.delegate = self;
        [self.navigationController pushViewController:addlaundryc animated:YES];
    }
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 63;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    NSDictionary* dict = [self.countarr objectAtIndex:indexPath.row];
    
    if (indexPath.row == 0)
    {
        [cell.textLabel setText:@"Date"];
        [cell.detailTextLabel setText:@"Laundry details"];
        UILabel* returnlbl = [[UILabel alloc] initWithFrame:CGRectMake(135, 60, 130, 20)];
        [returnlbl setTextAlignment:NSTextAlignmentRight];
        
        returnlbl.backgroundColor = [UIColor clearColor];
        
        returnlbl.text = @"Got it back?";
            
        cell.accessoryView = returnlbl;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;        
    }
        
    else if ([[dict objectForKey:@"totalcloth"] integerValue] != 0)
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

        if ([[dict objectForKey:@"saree"] integerValue] != 0)
        {
            subtitle = [subtitle stringByAppendingString:@" Saree:"];
            subtitle = [subtitle stringByAppendingString:[dict objectForKey:@"saree"]];
        }
        
        if ([[dict objectForKey:@"starch"] integerValue] != 0)
        {
            subtitle = [subtitle stringByAppendingString:@" Starch:"];
            subtitle = [subtitle stringByAppendingString:[dict objectForKey:@"starch"]];
        }
        
        [cell.detailTextLabel setNumberOfLines:2];
        [cell.detailTextLabel setText:subtitle];
        
        NSArray *itemArray = [NSArray arrayWithObjects: @"No", @"Yes", nil];
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];

        //segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
        segmentedControl.tag = indexPath.row;
        segmentedControl.selectedSegmentIndex = [[dict objectForKey:@"returned"] integerValue];
        
        if (segmentedControl.selectedSegmentIndex == 0)
        {
            [segmentedControl setTintColor:[UIColor whiteColor]];
        }
        else
        {
            [segmentedControl setTintColor:[UIColor lightGrayColor]];
        }
        
        [segmentedControl addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
        
        cell.accessoryView = segmentedControl;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
 
    }
    
    // Set backgroundcolor
    cell.backgroundColor = [UIColor colorWithRed:.1 green:.1 blue:.1 alpha:.2];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.opaque = NO;
    
    return cell;
}

/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{    
    return @" Records ";
}
*/

-(void)segmentChanged:(UISegmentedControl*)sender
{
    // when a segment is selected, it resets the text colors
    NSDictionary* dict = [self.countarr objectAtIndex:sender.tag];
    
    if (sender.selectedSegmentIndex == 0)
    {
        [sender setTintColor:[UIColor whiteColor]];
        [dict setValue:@"0" forKey:@"returned"];
    }
    else
    {
        [sender setTintColor:[UIColor lightGrayColor]];
        [dict setValue:@"1" forKey:@"returned"];        
    }
}

- (void)addLaundry:(MBAddLaundryDVC *)controller didFinishAddingException:(NSDictionary *)item
{
    [self.countarr addObject:item];
    
    [self.tableView reloadData];
} 

- (void)saveData
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    
    [dict setObject:self.countarr forKey:@"counts"];
    [dict setObject:self.ratearr forKey:@"rates"];
    
    [self.model setLaundryDetails:dict];
    
    [self.navigationController popViewControllerAnimated:YES];
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
