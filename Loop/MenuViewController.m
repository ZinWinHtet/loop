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

- (IBAction)announcementClicked:(id)sender {
//    if(sender.highlighted == YES){
//        UIImage *img = [UIImage imageNamed:@"btn_announcement_over.png"];
//        [self.btnAnnouncement setBackgroundImage:img forState:(nil)];
//    }
}

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
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Not now" destructiveButtonTitle:nil otherButtonTitles:@"Log Out", nil];
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        [self logOut];
    }
    else if(buttonIndex == 1){
        NSLog(@"Here is 1");
    }
    else if(buttonIndex == 2){
        NSLog(@"Here is 2");
    }
}

-(void) logOut{
    [[NSUserDefaults standardUserDefaults] setObject:@"No" forKey:@"logIn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    AppDelegate *appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    appDelegate.window.rootViewController = [appDelegate.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"loginScreen"];
}

@end
