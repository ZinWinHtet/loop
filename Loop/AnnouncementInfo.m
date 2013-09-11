//
//  AnnouncementInfo.m
//  Loop
//
//  Created by uniqsoft on 5/9/13.
//  Copyright (c) 2013 uniqsoft. All rights reserved.
//

#import "AnnouncementInfo.h"

@implementation AnnouncementInfo

-(id)initWithAnnouncementId:(NSString*) ann_id title : (NSString*) title content : (NSString*) content date : (NSString*) date device : (NSString*) device login_code : (NSString*) login_code checked : (NSString*) checked{
        if ((self = [super init])) {
            self.anno_id = ann_id;
            self.anno_title = title;
            self.anno_content = content;
            self.anno_date = date;
            self.r_device = device;
            self.s_login_code = login_code;
            self.is_checked = checked;
        }
    return self;
}

@end
