//
//  UDPSocket.m
//  OnlineAuction-Z
//
//  Created by zqzas on 13-6-9.
//  Copyright (c) 2013年 Hao Ma. All rights reserved.
//

#import "UDPSocket.h"

@interface UDPSocket ()


// re-declare as readwrite for private use

@property (nonatomic, strong, readwrite) NSData * serverAddress;
@property (nonatomic, assign, readwrite) NSUInteger port;

// forward declaration

- (void)stopWithError:(NSError *)error;

@end

@implementation UDPSocket
{
    //CFHostRef _cfHost;
    CFSocketRef _cfSocket;
}

@synthesize serverAddress;
@synthesize serverPort;

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        //nothing to do
        
    }
    return self;
}

- (void)sendData:(NSData *)data
{
    NSData * addr;
    int err;
    int sock;
    ssize_t bytesWritten;
    const struct sockaddr_in * addrPtr;
    socklen_t addrLen;
    
    assert(data != nil);
    
    sock = CFSocketGetNative(self->_cfSocket);
    assert(sock >= 0);
    
    assert(self.serverAddress != nil);
    addr = self.serverAddress;
    addrPtr = [addr bytes];
    addrLen = (socklen_t) [addr length];
    
    bytesWritten = sendto(sock, [data bytes], [data length], 0, (const struct sockaddr *)addrPtr, addrLen);
    
    if (bytesWritten < 0)
        err = errno;
    else if (bytesWritten == 0)
    {
        err = EPIPE;
    }
    else
    {
        //we ignore any short writes, which shouldn't happen for UDP anyway
        assert( (NSUInteger) bytesWritten == [data length]);
        err = 0;
    }
    
    if (err == 0)
    {
        //delegate stuff
    }
    else
    {
        //error handle
    }
    return;
}
- (void)stop
{
    return;
}

static void SocketReadCallback(CFSocketRef s, CFSocketCallBackType type, CFDataRef address, const void *data, void *info)
{
    NSLog(@"I did receive something:)\n");
}

- (BOOL) setupSocketConnectedToAddress:(NSData *)address port:(NSUInteger)port error:(NSError **)errorPtr
{
    int err;
    int junk;
    int sock;
    CFRunLoopSourceRef rls;
    
    //Assert something for safety
    assert([address length] <= sizeof(struct sockaddr_storage));
    assert(port < 65536);
    assert(self->_cfSocket == NULL);
    
    
    //Build socket
    err = 0;
    sock = socket(AF_INET, SOCK_DGRAM, 0);
    if (sock < 0)
        err = errno;
    
    //Connect to the server
    
    if (err == 0)
    {
        struct sockaddr_in addr;
        memset(&addr, 0, sizeof(addr));
        
        addr.sin_len = sizeof(addr);
        addr.sin_family = AF_INET;
        addr.sin_port = htons(port);
        addr.sin_addr.s_addr = INADDR_ANY;
        err = bind(sock, (const struct sockaddr *) &addr, sizeof(addr));
        /*
        if (address != nil)
        {
            //Sender Mode

            //[address getBytes:&addr length:[address length]]; //copy into addr
     
            //assert(addr.sin_family == AF_INET);
            //addr.sin_port = htons(port);
            //err = connect(sock, (const struct sockaddr *) &addr, sizeof(addr));
            //char *s = "ok";
            //err = sendto(sock, s, sizeof(*s), 0, &addr, sizeof(addr));
            //if (err < 0)
            //    err = errno;
        }
        else
        {
            //Listener Mode, where address is nil
            
            addr.sin_len = sizeof(addr);
            addr.sin_family = AF_INET;
            addr.sin_port = htons(port);
            addr.sin_addr.s_addr = INADDR_ANY;
            err = bind(sock, (const struct sockaddr *) &addr, sizeof(addr));
        }
        if (err <0)
        {
            err = errno;
        }
         */
    }
    
    //Set non-blocking mode
    if (err == 0)
    {
        int flags;
        flags = fcntl(sock, F_GETFL);
        err = fcntl(sock, F_SETFL, flags | O_NONBLOCK);
        if (err < 0)
            err = errno;
    }
    //Wrap the socket into a CFSocket that's scheduled on the runloop
    
    if (err == 0)
    {
        self->_cfSocket = CFSocketCreateWithNative(NULL, sock, kCFSocketReadCallBack, SocketReadCallback, NULL);
        
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
        assert( (err == 0) == (self->_cfSocket != NULL));

        if ( (self->_cfSocket == NULL) && (errorPtr != NULL) ) {
            *errorPtr = [NSError errorWithDomain:NSPOSIXErrorDomain code:err userInfo:nil];
        }
    }
    return (err == 0);
}

- (BOOL)runClientWithAddress:(NSString *)serverIP port:(NSUInteger)port
{
    NSError * error;
    
    assert(inet_addr([serverIP UTF8String]) != -1); //check if IPv4 numbers-and-dots notation is correct
    
    assert(self.port ==0);
    if (self.port ==0)
    {
        self.port = port;
        
        //init address
        
        struct sockaddr_in address;
        address.sin_family = AF_INET;
        address.sin_port = htons(port);
        address.sin_addr.s_addr = inet_addr([serverIP UTF8String]); //convert NSString to char *
        
        self.serverAddress = [NSData dataWithBytes:&address length:sizeof(address)];
        
        BOOL success = [self setupSocketConnectedToAddress:self.serverAddress port:port error:&error];
    
        if (!success)
        {
            NSLog(@"Error when setup");
            return NO;
        }
        
    }
    return YES;
}

@end
