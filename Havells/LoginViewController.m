//
//  LoginViewController.m
//  Kotak Wealth Watch App
//
//  Created by Rajeev Ranjan on 05/09/17.
//  Copyright © 2017 Shephertz Technologies. All rights reserved.
//

#import "LoginViewController.h"
#import <Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h>
#import "StocksListViewController.h"
#import "AppDelegate.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface LoginViewController ()

@end

@implementation LoginViewController


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.view endEditing:true];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};

    
    AppDelegate *appDele = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDele.loginVC = self;
    
    self.view.backgroundColor = UIColorFromRGB(0xECEBF3);
    self.continueButton.backgroundColor = [UIColor whiteColor];
    self.continueButton.clipsToBounds = YES;
    self.continueButton.layer.masksToBounds = YES;
    self.continueButton.layer.cornerRadius = self.continueButton.frame.size.height / 2;
    self.continueButton.layer.borderWidth = 1.0f;
    self.continueButton.layer.borderColor = UIColorFromRGB(0xD7D7D7).CGColor;
    [self.continueButton setTitleColor:UIColorFromRGB(0xAE2E23) forState:UIControlStateNormal];
    
    UIImage *img = [UIImage imageNamed:@"120px.png"];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [imgView setImage:img];
    // setContent mode aspect fit
    [imgView setContentMode:UIViewContentModeScaleAspectFit];
//    self.navigationItem.titleView = imgView;
    self.navigationItem.title = @"Login";
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"IsLogin"] == true) {
        StocksListViewController *stocksVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StocksListViewController"];
        [self.navigationController pushViewController:stocksVC animated:NO];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"continueButton"]) {
        NSLog(@"username %@", [App42API getLoggedInUser]);
    }
    
}


- (IBAction)continueButtonClick:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"IsLogin"];
    [App42API setLoggedInUser:[self.userTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    
    NSLog(@"self.deviceToken: %@", self.deviceToken);
    [self registerDeviceToken:self.deviceToken];
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    if ([[App42API getLoggedInUser] isEqualToString:@"sid"]) {
        [userdefaults setInteger:6 forKey:@"UserId"];
    }
    else {
        [userdefaults setInteger:5 forKey:@"UserId"];
    }
    self.userTextField.text = @"";
    
    [self performSegueWithIdentifier:@"continueButton" sender:self];
}


-(void)registerDeviceToken:(NSString *)deviceTokenString {
    NSLog(@"device token: %@", deviceTokenString);
    
    @try
    {
        /***
         * Registering Device Token to App42 Cloud API
         */
        PushNotificationService *pushObj=[App42API buildPushService];
        [pushObj registerDeviceToken:deviceTokenString withUser:[App42API getLoggedInUser] completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
            if (success) {
                PushNotification *push = (PushNotification*)responseObj;
                NSLog(@"push.strResponse: %@", push.strResponse);
            }
            else
            {
                NSLog(@"Reason = %@",exception.reason);
            }
        }];
        
    }
    @catch (App42Exception *exception)
    {
        NSLog(@"Reason = %@",exception.reason);
    }
    @finally
    {
        
    }
}

-(void)setDeviceTokenString:(NSString *)devToken {
    self.deviceToken = devToken;
    NSLog(@"devicetoken: %@", self.deviceToken);
}
@end
