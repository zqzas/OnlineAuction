//
//  HallTableViewController.m
//  OnlineAuction-Z
//
//  Created by zqzas on 13-6-13.
//  Copyright (c) 2013年 Hao Ma. All rights reserved.
//

#import "HallTableViewController.h"

@interface HallTableViewController ()
@property (atomic, assign, readwrite) NSUInteger roomNum;
@property (atomic, strong, readwrite) NSMutableArray * roomArray;



@end

@implementation HallTableViewController



- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.comm.delegate = self;
    [self updateHallInfo];
    self.roomArray = [[NSMutableArray alloc] init];
    

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.

    return (NSInteger)self.roomNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@: CurrentPrice: %@", [[self.roomArray objectAtIndex:indexPath.row] objectAtIndex:0], [[self.roomArray objectAtIndex:indexPath.row] objectAtIndex:1]];
    
    return cell;
}
- (IBAction)refreshButton:(id)sender {
    [self updateHallInfo];
}

#pragma mark - Communication protocol delegate
-(void)setAlart:(NSString *) alartMsg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Alart from server"
                                                    message: alartMsg
                                                   delegate: nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    //[self updateHallInfo];
}

#pragma mark - Communication protocol delegate
- (void)notifyReply:(NSString *)msg
{
    NSArray * roomList = [msg componentsSeparatedByString:@"\n"];
    NSUInteger roomCount = roomList.count;
    
    for (NSUInteger index = 0; index < roomCount; index++) {
        NSArray * roomInfo = [roomList[index] componentsSeparatedByString:@" "];
        if (roomInfo && ![roomInfo[0] isEqual: @""])
            [self.roomArray addObject:roomInfo];
    }
    
    self.roomNum = (NSUInteger)self.roomArray.count;
    [self setAlart:@"Got Data from server!"];
    [self.tableView reloadData];
}


- (void) updateHallInfo
{
    [self.comm sendMessageToServer:@"/auctions"];

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

    RoomViewController *roomVC = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"RoomViewController"];
    //RoomViewController *roomVC = [[RoomViewController alloc]initWithNibName:@"RoomViewController" bundle:[NSBundle mainBundle]];
    // ...
    // Pass the selected object to the new view controller.
    
    roomVC.comm = self.comm;
    roomVC.roomName = [[self.roomArray objectAtIndex:indexPath.row] objectAtIndex:0];
    roomVC.currentPrice = [[self.roomArray objectAtIndex:indexPath.row] objectAtIndex:1];
    roomVC.roomID = indexPath.row;
    [self.navigationController pushViewController:roomVC animated:YES];
    

}

@end
