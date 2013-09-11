//
//  AnnouncementInfo.h
//  Loop
//
//  Created by uniqsoft on 5/9/13.
//  Copyright (c) 2013 uniqsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnnouncementInfo : NSObject

//should be same with table's columns
@property (nonatomic, copy) NSString *anno_id; // NSString should be chosen "copy"
@property (nonatomic, copy) NSString *anno_title;
@property (nonatomic, copy) NSString *anno_content;
@property (nonatomic, copy) NSString *anno_date;
@property (nonatomic, copy) NSString *r_device;
@property (nonatomic, copy) NSString *s_login_code;
@property (nonatomic, copy) NSString *is_checked;

-(id)initWithAnnouncementId:(NSString*) ann_id title : (NSString*) title content : (NSString*) content date : (NSString*) date device : (NSString*) device login_code : (NSString*) login_code checked : (NSString*) checked;

@end
