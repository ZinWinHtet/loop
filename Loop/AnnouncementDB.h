//
//  AnnouncementDB.h
//  Loop
//
//  Created by uniqsoft on 5/9/13.
//  Copyright (c) 2013 uniqsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "AnnouncementInfo.h"

@interface AnnouncementDB : NSObject
{
    sqlite3 *_database;
}

+ (AnnouncementDB*) database;
- (NSArray *) getAnnouncementInfos;
- (void) insertAnnouncement:(NSDictionary*) announcementInfo;

@end
