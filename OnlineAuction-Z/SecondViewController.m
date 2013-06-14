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
@property (strong, nonatomic) CommunicationWithServer *comm;


@end

@implementation SecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.Dialog.text = @"Hello World";
	// Do any additional setup after loading the view, typically from a nib.
    self.comm = [[CommunicationWithServer alloc] init];
    self.comm.delegate = self;
}


- (IBAction)SampleButton:(id)sender {
    
    NSString * saySomething = @"/login test";
    
    self.Dialog.text = [NSString stringWithFormat:@"%@\n%@", self.Dialog.text, saySomething];
    
    
    [self.comm sendMessageToServer:saySomething];
    //will be notified automatically when get reply
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
    //[alert release];
    
    
}

#pragma mark - Communication protocol delegate
-(void)notifyReply:(NSString *)replyMsg
{
    self.Dialog.text = [NSString stringWithFormat:@"%@\n>>> %@", self.Dialog.text, replyMsg];

}

@end
