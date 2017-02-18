//
//  Login_DataModal.m
//  iPadJobClient
//
//  Created by job1001 job1001 on 11-12-2.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "Login_DataModal.h"

@implementation Login_DataModal

@synthesize loginState_;
@synthesize msg_;
@synthesize status_;
@synthesize personId_;
@synthesize iname_;
@synthesize uname_;
@synthesize prnd_;
@synthesize tradeId_;
@synthesize totalId_;
@synthesize pwd_;
@synthesize pic_;
@synthesize school_;
@synthesize majorCatId_;
@synthesize majorStr_;
@synthesize sex_;
@synthesize updateTime_;
@synthesize createDate_;

-(id) init
{
    loginState_ = LoginFail;
    
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:loginState_ forKey:@"login_state"];
    [aCoder encodeObject:msg_ forKey:@"msg"];
    [aCoder encodeObject:status_ forKey:@"status"];
    [aCoder encodeObject:personId_ forKey:@"person_id"];
    [aCoder encodeObject:iname_ forKey:@"iname"];
    [aCoder encodeObject:uname_ forKey:@"uname"];
    [aCoder encodeObject:prnd_ forKey:@"prnd"];
    [aCoder encodeObject:tradeId_ forKey:@"trade_id"];
    [aCoder encodeObject:totalId_ forKey:@"total_id"];
    [aCoder encodeObject:pwd_ forKey:@"pwd"];
    [aCoder encodeObject:pic_ forKey:@"pic"];
    [aCoder encodeObject:school_ forKey:@"school"];
    [aCoder encodeObject:majorCatId_ forKey:@"major_cat_id"];
    [aCoder encodeObject:majorStr_ forKey:@"major_str"];
    [aCoder encodeObject:sex_ forKey:@"sex"];
    [aCoder encodeObject:updateTime_ forKey:@"updatetime"];
    [aCoder encodeObject:createDate_ forKey:@"createdate"];
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    loginState_ = [aDecoder decodeIntForKey:@"login_state"];
    msg_        = [aDecoder decodeObjectForKey:@"msg"];
    status_     = [aDecoder decodeObjectForKey:@"status"];
    personId_   = [aDecoder decodeObjectForKey:@"person_id"];
    iname_      = [aDecoder decodeObjectForKey:@"iname"];
    uname_      = [aDecoder decodeObjectForKey:@"uname"];
    prnd_       = [aDecoder decodeObjectForKey:@"prnd"];
    tradeId_    = [aDecoder decodeObjectForKey:@"trade_id"];
    totalId_    = [aDecoder decodeObjectForKey:@"total_id"];
    pwd_        = [aDecoder decodeObjectForKey:@"pwd"];
    pic_        = [aDecoder decodeObjectForKey:@"pic"];
    school_     = [aDecoder decodeObjectForKey:@"school"];
    majorCatId_ = [aDecoder decodeObjectForKey:@"major_cat_id"];
    majorStr_   = [aDecoder decodeObjectForKey:@"major_str"];
    sex_        = [aDecoder decodeObjectForKey:@"sex"];
    updateTime_ = [aDecoder decodeObjectForKey:@"updatetime"];
    createDate_ = [aDecoder decodeObjectForKey:@"createdate"];
    
    return self;
}

@end
