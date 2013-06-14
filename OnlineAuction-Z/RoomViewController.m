//
//  RoomViewController.m
//  OnlineAuction-Z
//
//  Created by zqzas on 13-6-14.
//  Copyright (c) 2013年 Hao Ma. All rights reserved.
//

#import "RoomViewController.h"

@interface RoomViewController ()
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UITextView *userList;

@end

@implementation RoomViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = self.roomName;
    self.priceLabel.text = [NSString stringWithFormat:@"Current Price: %@", self.currentPrice];
    self.userList.text = @"";
    
    self.comm.delegate = self;
    [self joinRoom];
    [self updateUserList];
}


- (void)updateUserList
{
    [self.comm sendMessageToServer:@"/list"];
}

- (void)joinRoom
{
    [self.comm sendMessageToServer:[NSString stringWithFormat:@"/join %lu", (unsigned long)self.roomID]];
     
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
    [self updateUserList];
}

#pragma mark - Communication protocol delegate
-(void)notifyReply:(NSString *)replyMsg
{
    if ([replyMsg isEqualToString:@"OK"])
        return;
    NSArray * userArray = [replyMsg componentsSeparatedByString:@"\n"];
    self.userList.text = @"";
    for (int index = 0; index < userArray.count; index++)
    {
        NSArray * userObj = [[userArray objectAtIndex:index] componentsSeparatedByString:@" "];
        if (userObj && ![userObj[0] isEqual: @""])
        {
            NSString *userName = userObj[0];
            NSInteger userPrice = [userObj[1] integerValue];
            if (userPrice > [self.currentPrice integerValue])
                self.currentPrice = [NSString stringWithFormat:@"%ld", (long)userPrice];
            self.userList.text = [NSString stringWithFormat:@"%@\nUser: %@\t\t Bid: %ld\n", self.userList.text, userName, (long)userPrice];
        }
        
    }
    
 
}

@end