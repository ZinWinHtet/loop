//
//  AnnouncementDetailViewController.h
//  Loop
//
//  Created by uniqsoft on 8/9/13.
//  Copyright (c) 2013 uniqsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnnouncementDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (nonatomic) NSString *titleString;
@property (nonatomic) NSString *contentString;

@end
