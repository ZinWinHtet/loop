//
//  AnnouncementViewController.h
//  Loop
//
//  Created by uniqsoft on 31/8/13.
//  Copyright (c) 2013 uniqsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnnouncementViewController : UITableViewController <NSXMLParserDelegate>

@property(strong) NSMutableDictionary *xmlAnnouncement;
@property(strong) NSMutableDictionary *currentDictionary;
@property(strong) NSString *previousElementName;
@property(strong) NSString *elementName;
@property(strong) NSMutableString *outstring;

@end