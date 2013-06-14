//
//  CommunicationWithServer.m
//  OnlineAuction-Z
//
//  Created by zqzas on 13-6-12.
//  Copyright (c) 2013年 Hao Ma. All rights reserved.
//

#import "CommunicationWithServer.h"

@interface CommunicationWithServer ()

@property (nonatomic, strong, readwrite) UDPSocket * udpsock;

@end

@implementation CommunicationWithServer
{
    CFSocketRef _cfSocket;
}

- (id)init
{
    self = [super init];
    [self setupCommucationToServer];
    return self;
}
- (void)setupCommucationToServer
{
    //int err;
    int junk;
    int sock;
    const CFSocketContext   context = { 0, (__bridge void *)(self), NULL, NULL, NULL };
    CFRunLoopSourceRef rls;
    
    if (self.udpsock == nil)
        self.udpsock = [[UDPSocket alloc] init];
    
    //sock = [self.udpsock  runClientWithAddress:@"103.6.84.203" port:32332];
    sock = [self.udpsock  runClientWithAddress:@"127.0.0.1" port:32332];
    
    self->_cfSocket = CFSocketCreateWithNative(NULL, sock, kCFSocketReadCallBack, SocketReadCallback, &context);
    
    assert(CFSocketGetSocketFlags(self->_cfSocket) & kCFSocketCloseOnInvalidate);
    sock = -1;
    
    rls = CFSocketCreateRunLoopSource(NULL, self->_cfSocket, 0);
    assert(rls != NULL);
    
    CFRunLoopAddSource(CFRunLoopGetCurrent(), rls, kCFRunLoopDefaultMode);
    
    //Handle errors
    if (sock != -1)
    {
        junk = close(sock);
        assert(junk == 0);
    }    
}

- (void)sendMessageToServer:(NSString *)msg
{
    NSData * data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    int sock = CFSocketGetNative(self->_cfSocket);
    [self.udpsock sendData:sock data:data];
}

- (void)didReceiveReply:(NSString *)msg
{
    //analyze the reply from remote server
    if ([msg hasPrefix:@"!"])
    {
        [self.delegate setAlart:msg];
    }
    else
    {
        [self.delegate notifyReply:msg];
    }
    //NSLog(@"Haha!%@\n", msg);
}

static void SocketReadCallback(CFSocketRef s, CFSocketCallBackType type, CFDataRef address, const void *data, void *info)
{
    CommunicationWithServer * obj = (__bridge CommunicationWithServer *) info;
    UDPSocket * udpsock = [[UDPSocket alloc] init];
    int sock = CFSocketGetNative(obj->_cfSocket);
//    
//    #pragma unused(s)
//    assert(s == self->_cfSocket);
//    #pragma unused(type)
//    assert(type == kCFSocketReadCallBack);
//    #pragma unused(address)
//    assert(address == nil);
//    #pragma unused(data)
//    assert(data == nil);
    NSLog(@"I start looking");
    NSString * msg = [udpsock readData:sock];
    NSLog(@"I see%@\n", msg);
    
    [obj didReceiveReply:msg];
}

@end
