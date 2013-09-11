//
//  AnnouncementDetailViewController.m
//  Loop
//
//  Created by uniqsoft on 8/9/13.
//  Copyright (c) 2013 uniqsoft. All rights reserved.
//

#import "AnnouncementDetailViewController.h"

@interface AnnouncementDetailViewController ()

@end

@implementation AnnouncementDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.titleLabel.text = self.titleString;
    self.content.text = self.contentString;
}

- (void)viewDidUnload {
    [self setTitle:nil];
    [self setContent:nil];
    [self setTitleLabel:nil];
    [super viewDidUnload];
}

@end
