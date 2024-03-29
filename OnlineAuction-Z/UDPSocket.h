//
//  UDPSocket.h
//  OnlineAuction-Z
//
//  Created by zqzas on 13-6-9.
//  Copyright (c) 2013年 Hao Ma. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CFNetwork/CFNetwork.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>


@interface UDPSocket : NSObject

- (id)init;

- (void)sendData:(int)sock data:(NSData *)data;
- (int)runClientWithAddress:(NSString *)serverIP port:(NSUInteger)port;
- (NSString *)readData: (int)sock;

- (void)stop;


@property (nonatomic, strong, readonly) NSData * serverAddress;
//@property (nonatomic, assign, readonly) NSUInteger serverPort;


@end
