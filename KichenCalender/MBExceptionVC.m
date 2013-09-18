//
//  MBExceptionVC.m
//  KichenCalender
//
//  Created by Swapnil Takalkar on 7/25/13.
//  Copyright (c) 2013 09Apps. All rights reserved.
//

#import "MBExceptionVC.h"

@interface MBExceptionVC ()

@end

@implementation MBExceptionVC

- (id)initWithException:(NSMutableArray*) exarray
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        self.exceptions = exarray;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"board_back.png"]];
    
    UIImage *image = [UIImage imageNamed: @"NavBar-Wood.png"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics: UIBarMetricsDefault];

    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    self.title = @"Exceptions";
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addExceptionCell)];
    
    self.navigationItem.rightBarButtonItem = addButton;    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.shared = [MBGADMasterVC singleton];
    [self.shared resetAdView:self];
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
    return [self.exceptions count];
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
    
    NSDictionary* dict = [self.exceptions objectAtIndex:indexPath.row];
    
    if ([[dict objectForKey:@"fromDate"] length] != 0)
    {
        [cell.textLabel setText:[dict objectForKey:@"fromDate"]];
        
        NSString* str = @"Till : ";
        str = [str stringByAppendingString:[dict objectForKey:@"toDate"]];
        [cell.detailTextLabel setText:str];

        UILabel* quantitylbl = [[UILabel alloc] initWithFrame:CGRectMake(135, 60, 130, 20)];
        [quantitylbl setTextAlignment:NSTextAlignmentRight];
        quantitylbl.backgroundColor = [UIColor clearColor];
    
        if (self.category == MILKCAT)
        {
            str = [dict objectForKey:@"quantity"];
            quantitylbl.text = [str stringByAppendingString:@"  Ltr / day"];
            
            cell.accessoryView = quantitylbl;
        }

        cell.selectionStyle = UITableViewCellSelectionStyleNone;        
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


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source
        [self.exceptions removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (void)addExceptionCell
{
    MBAddExcepVC* addExceptionVC = [[MBAddExcepVC alloc]init];
    addExceptionVC.category = self.category;
    addExceptionVC.delegate = self;
    
    [self.navigationController pushViewController:addExceptionVC animated:YES];
    
//    [addExceptionVC setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
//    [self presentViewController:addExceptionVC animated:YES completion:nil];
}

- (void)addExceptionVC:(MBAddExcepVC *)controller didFinishAddingException:(NSDictionary *)item
{
    [self.exceptions addObject:item];
    [self.tableView reloadData];
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
