//
//  LoginViewController.m
//  OnlineAuction-Z
//
//  Created by zqzas on 13-6-13.
//  Copyright (c) 2013年 Hao Ma. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic, readwrite) IBOutlet UIButton *LoginButton;
@property (weak, nonatomic, readwrite) IBOutlet UITextField *serverIP;
@property (weak, nonatomic, readwrite) IBOutlet UITextField *userName;
@property (assign, nonatomic, readwrite) NSInteger isLogin;
@property (weak, nonatomic) IBOutlet UIButton *EnterButton;


@property (strong, nonatomic) CommunicationWithServer *comm;


@end

@implementation LoginViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.comm = [[CommunicationWithServer alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.comm.delegate = self;
    self.isLogin = -1;
    self.EnterButton.enabled = NO;
}

- (BOOL)checkValidIP:(NSString *)IP
{
    return TRUE;
}

- (BOOL)checkValidUserName:(NSString *)userName
{
    return TRUE;
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
}

#pragma mark - Communication protocol delegate
-(void)notifyReply:(NSString *)replyMsg
{
    if ([replyMsg isEqualToString:@"OK"])
    {
        self.isLogin = 1;
        [self setAlart:@"Login OK."];
        self.EnterButton.enabled = YES;
    }
    else
    {
        self.isLogin = 0;
        [self setAlart:@"Login failed. Please try again."];
    }
}

- (IBAction)loginAction:(id)sender
{
    
    if ([self checkValidIP:self.serverIP.text] && [self checkValidUserName:self.userName.text])
    {
        [self.comm sendMessageToServer:[NSString stringWithFormat:@"/login %@", self.userName.text]];

        //[self setAlart:@"Trying to connect..."];
    }
}
- (IBAction)EnterAction:(id)sender
{
    //anything to do?
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"EnterSegue"])
        if ([segue.destinationViewController isKindOfClass:[HallTableViewController class]])
        {
            //prepare
            HallTableViewController *cdvc = (HallTableViewController *)segue.destinationViewController;
            cdvc.comm = self.comm;
        }
}

@end
