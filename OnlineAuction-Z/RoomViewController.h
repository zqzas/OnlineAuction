//
//  RoomViewController.h
//  OnlineAuction-Z
//
//  Created by zqzas on 13-6-14.
//  Copyright (c) 2013年 Hao Ma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommunicationWithServer.h"

@interface RoomViewController : UIViewController

@property(nonatomic, strong)CommunicationWithServer * comm;
@property(nonatomic, strong)NSString * roomName;
@property(nonatomic, assign)NSUInteger roomID;
@property(nonatomic, strong)NSString * currentPrice;
-(void)setAlart:(NSString *) alartMsg;

- (void)nofityReply:(NSString *)msg;


@end
