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


@property (strong, nonatomic) CommunicationWithServer *comm;

- (BOOL)checkValidIP:(NSString *)IP;
- (BOOL)checkValidUserName:(NSString *)userName;

@end

@implementation LoginViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.comm = [[CommunicationWithServer alloc] init];
    self.comm.delegate = self;
   
}

- (BOOL)checkValidIP:(NSString *)IP
{
    return TRUE;
}

- (BOOL)checkValidUserName:(NSString *)userName
{
    return TRUE;
}
- (IBAction)loginAction:(id)sender {
    
    if (checkValidIP(self.serverIP.text) && checkValidUserName(self.userName.text))
    {
        //
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"LoginSegue"])
        if ([segue.destinationViewController isKindOfClass:[HallViewController class]])
        {
            //prepare
            HallViewController *cdvc = (HallViewController *)segue.destinationViewController;
            cdvc.comm = self.comm;
        }
}

@end
