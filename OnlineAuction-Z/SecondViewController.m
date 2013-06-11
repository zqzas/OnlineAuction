//
//  SecondViewController.m
//  OnlineAuction-Z
//
//  Created by zqzas on 13-6-7.
//  Copyright (c) 2013年 Hao Ma. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()
@property (weak, nonatomic) IBOutlet UITextView *Dialog;
@property (nonatomic, strong, readwrite) UDPSocket * udpsock;

@end

@implementation SecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.Dialog.text = @"Hello World";
	// Do any additional setup after loading the view, typically from a nib.
    
    
    [self setupUDPSocket];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUDPSocket
{
    if (self.udpsock == nil)
        self.udpsock = [[UDPSocket alloc] init];
    
    [self.udpsock  runClientWithAddress:@"8.8.8.8" port:32332];
}

- (IBAction)SampleButton:(id)sender {
    
    NSString * saySomething = @"Say Something";
    
    self.Dialog.text = [NSString stringWithFormat:@"%@\n%@", self.Dialog.text, saySomething];
    
    
    
    NSData * data = [saySomething dataUsingEncoding:NSUTF8StringEncoding];
    
    [self.udpsock sendData:data];
    
}

@end
