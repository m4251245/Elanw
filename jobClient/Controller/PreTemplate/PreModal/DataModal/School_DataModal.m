//
//  School_DataModal.m
//  CampusClient
//
//  Created by job1001 job1001 on 13-3-5.
//
//

#import "School_DataModal.h"

@implementation School_DataModal

@synthesize id_;
@synthesize beAttentionId_;
@synthesize regionId_;
@synthesize name_;
@synthesize logoPath_;
@synthesize empWeb_;
@synthesize lat_;
@synthesize lng_;
@synthesize bAttention_;
@synthesize imageData_;
@synthesize bSelect_;

-(void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:id_ forKey:@"id"];
    [aCoder encodeObject:regionId_ forKey:@"region_id"];
    [aCoder encodeObject:name_ forKey:@"name"];
    [aCoder encodeObject:logoPath_ forKey:@"logo_path"];
    [aCoder encodeObject:empWeb_ forKey:@"emp_web"];
    [aCoder encodeFloat:lat_ forKey:@"lat"];
    [aCoder encodeFloat:lng_ forKey:@"lng"];
    [aCoder encodeBool:bAttention_ forKey:@"attention_flag"];
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    id_         = [aDecoder decodeObjectForKey:@"id"];
    regionId_   = [aDecoder decodeObjectForKey:@"region_id"];
    name_       = [aDecoder decodeObjectForKey:@"name"];
    logoPath_   = [aDecoder decodeObjectForKey:@"logo_path"];
    empWeb_     = [aDecoder decodeObjectForKey:@"emp_web"];
    lat_        = [aDecoder decodeFloatForKey:@"lat"];
    lng_        = [aDecoder decodeFloatForKey:@"lng"];
    bAttention_ = [aDecoder decodeBoolForKey:@"attention_flag"];
    
    return self;
}


@end
