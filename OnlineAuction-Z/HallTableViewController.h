//
//  HallTableViewController.h
//  OnlineAuction-Z
//
//  Created by zqzas on 13-6-13.
//  Copyright (c) 2013年 Hao Ma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommunicationWithServer.h"

@interface HallTableViewController : UITableViewController

@property(nonatomic, strong)CommunicationWithServer * comm;

-(void)setAlart:(NSString *) alartMsg;

- (void)nofityReply:(NSString *)msg;

@end
