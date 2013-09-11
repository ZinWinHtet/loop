//
//  MenuViewController.m
//  Loop
//
//  Created by uniqsoft on 26/8/13.
//  Copyright (c) 2013 uniqsoft. All rights reserved.
//

#import "MenuViewController.h"
#import "AppDelegate.h"
@interface MenuViewController ()
{
    NSDictionary *student;
}
@end

@implementation MenuViewController

-(void) announcementWork{
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSDictionary *student = (NSDictionary*)[[NSUserDefaults standardUserDefaults] objectForKey:@"student_info"];
    NSString *s_mail = [student objectForKey:@"s_mail"];
    NSLog(@"s_mail is ------> %@",s_mail);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)MenuButtonAction:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:@"No" forKey:@"logIn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    AppDelegate *appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    appDelegate.window.rootViewController = [appDelegate.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"loginScreen"];
}

@end
