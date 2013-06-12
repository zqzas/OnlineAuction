//
//  CommunicationWithServer.h
//  OnlineAuction-Z
//
//  Created by zqzas on 13-6-12.
//  Copyright (c) 2013年 Hao Ma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UDPSocket.h"

// Protocol definition starts here
@protocol UICommunicationProtocol  <NSObject>
@required
- (void) setAlart:(NSString *)alartMsg;
- (void) notifyReply:(NSString *)replyMsg;
@end

@interface CommunicationWithServer : NSObject
{
    id <UICommunicationProtocol> _delegate;
}

@property (nonatomic, strong) id delegate;

- (void)setupCommucationToServer;

- (void)sendMessageToServer:(NSString *)msg;


@end
