//
//  AnnouncementDB.m
//  Loop
//
//  Created by uniqsoft on 5/9/13.
//  Copyright (c) 2013 uniqsoft. All rights reserved.
//

#import "AnnouncementDB.h"
#import "AnnouncementInfo.h"

@implementation AnnouncementDB

static AnnouncementDB *_database;

- (id)init {
    if ((self = [super init])) {
        NSString *sqLiteDb = [[NSBundle mainBundle] pathForResource:@"loop" ofType:@"sqlite"];
        
        if (sqlite3_open([sqLiteDb UTF8String], &_database) != SQLITE_OK) {
            NSLog(@"Failed to open database!");
        }
    }
    return self;
}

+ (AnnouncementDB*) database{
    if (_database == nil) {
        _database = [[AnnouncementDB alloc] init];
    }
    return _database;
}
- (NSArray *) getAnnouncementInfos{
    NSMutableArray *retval = [[NSMutableArray alloc] init];
    NSString *query = @"SELECT * FROM announcement_tbl";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *a_id = (char *) sqlite3_column_text(statement,0);
            char *a_title = (char *) sqlite3_column_text(statement,1);
            char *a_content = (char *) sqlite3_column_text(statement,2);
            char *a_date = (char *) sqlite3_column_text(statement,3);
            char *rdevice = (char *) sqlite3_column_text(statement,4);
            char *slogin_code = (char *) sqlite3_column_text(statement,5);
            char *isChecked = (char *) sqlite3_column_text(statement,6); // char နဲ႔ဖမ္း
            NSString *anno_id = [[NSString alloc] initWithUTF8String:a_id];
            NSString *anno_title = [[NSString alloc] initWithUTF8String:a_title];
            NSString *anno_content = [[NSString alloc] initWithUTF8String:a_content];
            NSString *anno_date = [[NSString alloc] initWithUTF8String:a_date];
            NSString *r_device = [[NSString alloc] initWithUTF8String:rdevice];
            NSString *s_login_code = [[NSString alloc] initWithUTF8String:slogin_code]; // convert into String
            NSString *is_checked = [[NSString alloc] initWithUTF8String:isChecked];
            AnnouncementInfo *info = [[AnnouncementInfo alloc] initWithAnnouncementId:anno_id title:anno_title content:anno_content date:anno_date device:r_device login_code:s_login_code checked:is_checked];
            [retval addObject:info];
        }
        sqlite3_finalize(statement);
    }
    return retval;
}
- (void) insertAnnouncement:(NSDictionary*) announcementInfo{
    // refrerenced from http://stackoverflow.com/questions/9706770/inserting-data-into-sqlite-database-on-iphone-not-working
    NSString *anno_id = [announcementInfo objectForKey:@"anno_id"];
    NSString *anno_title = [announcementInfo objectForKey:@"anno_title"];
    NSString *anno_content = [announcementInfo objectForKey:@"anno_content"];
    NSString *anno_date = [announcementInfo objectForKey:@"anno_date"];
    NSString *r_device = [announcementInfo objectForKey:@"r_device"];
    NSString *s_login_code = [announcementInfo objectForKey:@"s_login_code"];
    NSString *is_checked = @"no";

    sqlite3_stmt *statement;
    NSString *databasePath = [[NSBundle mainBundle] pathForResource:@"loop" ofType:@"sqlite"];
    if(sqlite3_open([databasePath UTF8String],&_database)==SQLITE_OK){
        NSString *insertQuerry = [NSString stringWithFormat:@"INSERT INTO announcement_tbl (anno_id,anno_title,anno_content,anno_date,r_device,s_login_code,is_checked) VALUES ('%@','%@','%@','%@','%@','%@','%@')",anno_id,anno_title,anno_content,anno_date,r_device,s_login_code,is_checked];
        const char *insert_stmt = [insertQuerry UTF8String];
        
        if (sqlite3_prepare_v2(_database, insert_stmt, -1, &statement, NULL) ==SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE) NSLog(@"announcement added");
            else NSLog(@"Failed to add directory");
        } else {
            NSLog(@"Problem with prepare statement: %s", sqlite3_errmsg(_database));
            NSLog(@"statement: %@", insertQuerry);
        }
    }

}

@end
