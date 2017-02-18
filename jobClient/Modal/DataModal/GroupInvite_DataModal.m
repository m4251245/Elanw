//
//  GroupInvite_DataModal.m
//  Association
//
//  Created by YL1001 on 14-5-14.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "GroupInvite_DataModal.h"
#import "MLEmojiLabel.h"

@implementation GroupInvite_DataModal
@synthesize type_,typeName_,statusName_,groupInfo_,hasDeleted_,id_,idatetime_,updatatime_,requestInfo_,responeInfo_,resultStatus_;

-(instancetype)initWithDictionary:(NSDictionary *)subDic
{
    self = [super init];
    if (self) {
        self.id_ = [subDic objectForKey:@"yap_id"];
        self.type_ = [subDic objectForKey:@"msg_type"];
        self.msg_type = [subDic objectForKey:@"msg_type"];
        self.group_id = [subDic objectForKey:@"group_id"];
        self.groupInfo_ = [[Groups_DataModal alloc] init];
        self.requestInfo_ = [[Expert_DataModal alloc] init];
        self.groupInfo_.id_ = [subDic objectForKey:@"group_id"];
        self.groupInfo_.name_ = [subDic objectForKey:@"group_name"];
        self.requestInfo_.id_ = [subDic objectForKey:@"person_id"];
        self.requestInfo_.iname_ = [subDic objectForKey:@"person_iname"];
        self.requestInfo_.isExpert_ = [[subDic objectForKey:@"is_expert"] boolValue];
        self.requestInfo_.img_ = [subDic objectForKey:@"person_pic"];
        self.idatetime_ = [subDic objectForKey:@"idatetime"];
        self.isAgree_ = [[subDic objectForKey:@"is_agree"] boolValue];
        self.bRead_ = [[subDic objectForKey:@"is_read"] boolValue];
        self.resultStatus_ = [subDic objectForKey:@"logs_status"];
        self.createrId_ = [subDic objectForKey:@"creater_id"];
        self.reason = [subDic objectForKey:@"apply_reason"];
        if (self.reason !=nil) {
            if (![self.reason isEqualToString:@""]) {
                self.reason = [NSString stringWithFormat:@"申请理由：%@",self.reason];
            }
        }
        NSDate * date = [MyCommon getDate:self.idatetime_];
        self.idatetime_ = [MyCommon CompareCurrentTimeByTheEndOfDay:date];
        
        self.groupInfo_.name_ = [MyCommon translateHTML:self.groupInfo_.name_];
        self.requestInfo_.iname_ = [MyCommon translateHTML:self.requestInfo_.iname_];
        self.reason = [MyCommon translateHTML:self.reason];
    }
    return self;
}

-(void)activityMessageContent{
    NSString *str1 = self.person_iname;
    NSString *str2 = self.group_name;
    NSString *str = [NSString stringWithFormat:@"%@已同意你的报名申请。恭喜你成为%@的一员",str1,str2];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:str];
    [string addAttribute:NSFontAttributeName value:FOURTEENFONT_CONTENT range:NSMakeRange(0,str.length)];
    [string addAttribute:NSForegroundColorAttributeName value:BLACKCOLOR range:NSMakeRange(0,str1.length)];
    [string addAttribute:NSForegroundColorAttributeName value:BLACKCOLOR range:NSMakeRange(str.length-3-str2.length,str2.length)];
    
    CGRect frame = [string boundingRectWithSize:CGSizeMake(ScreenWidth-64,MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine |
                    NSStringDrawingUsesLineFragmentOrigin |
                    NSStringDrawingUsesFontLeading context:nil];
    self.contentAttString = string;
    _cellHeight = frame.size.height+40;
}

-(instancetype)initWithGroupMessageDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        self.yap_id = dic[@"yap_id"];
        self.is_read = dic[@"is_read"];
        self.push_type = dic[@"push_type"];
        self.msg_type = dic[@"msg_type"];
        self.title = dic[@"title"];
        self.content = dic[@"content"];
        self.idatetime = [MyCommon CompareCurrentTimeByTheEndOfDay:[MyCommon getDate:dic[@"idatetime"]]];
        self.person_id = dic[@"person_id"];
        self.person_iname = dic[@"person_iname"];
        if (self.person_iname.length == 0) {
            self.person_iname = @"匿名";
        }
        self.person_pic = dic[@"person_pic"];
        self.is_expert = dic[@"is_expert"];
        self.article_id = dic[@"article_id"];
        self.article_title = dic[@"article_title"];
        self.group_id = dic[@"group_id"];
        self.comment_id = dic[@"comment_id"];
        self.comment_content = dic[@"comment_content"];
        
        NSDictionary *parentDic = dic[@"_parent_comment"];
        if ([parentDic isKindOfClass:[NSDictionary class]])
        {
            NSString *content = parentDic[@"content"];
            if (content.length > 0) {
                self.parentContent = content;
            }
        }
        self.title = [MyCommon translateHTML:self.title];
        self.content = [MyCommon translateHTML:self.content];
        self.person_iname = [MyCommon translateHTML:self.person_iname];
        self.parentContent = [MyCommon translateHTML:self.parentContent];
        self.title = [MyCommon MyfilterHTML:self.title];
        self.content = [MyCommon MyfilterHTML:self.content];
        self.person_iname = [MyCommon MyfilterHTML:self.person_iname];
        self.parentContent = [MyCommon MyfilterHTML:self.parentContent];
        _cellHeight = [self getCellHeightWithString:self.comment_content];
    }
    return self;
}

-(instancetype)initWithGroupMessageTwoDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self)
    {
        self.yap_id = dic[@"yap_id"];
        self.is_read = dic[@"is_read"];
        self.push_type = dic[@"push_type"];
        self.msg_type = dic[@"msg_type"];
        self.title = dic[@"title"];
        self.content = dic[@"content"];
        self.idatetime = [MyCommon CompareCurrentTimeByTheEndOfDay:[MyCommon getDate:dic[@"idatetime"]]];
        self.person_id = dic[@"person_id"];
        self.person_iname = dic[@"person_iname"];
        if (self.person_iname.length == 0) {
            self.person_iname = @"匿名";
        }
        self.person_pic = dic[@"person_pic"];
        self.is_expert = dic[@"is_expert"];
        self.article_id = dic[@"aid"];
        _cellHeight = 80;
        
        self.title = [MyCommon translateHTML:self.title];
        self.content = [MyCommon translateHTML:self.content];
        self.person_iname = [MyCommon translateHTML:self.person_iname];
        self.parentContent = [MyCommon translateHTML:self.parentContent];
        self.title = [MyCommon MyfilterHTML:self.title];
        self.content = [MyCommon MyfilterHTML:self.content];
        self.person_iname = [MyCommon MyfilterHTML:self.person_iname];
        self.parentContent = [MyCommon MyfilterHTML:self.parentContent];
    }
    return self;
}

-(instancetype)initWithGroupMessageOneDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self)
    {
        self.yap_id = dic[@"yap_id"];
        self.is_read = dic[@"is_read"];
        self.push_type = dic[@"push_type"];
        self.msg_type = dic[@"msg_type"];
        self.idatetime = [MyCommon CompareCurrentTimeByTheEndOfDay:[MyCommon getDate:dic[@"idatetime"]]];
        self.person_iname = dic[@"person_iname"];
        if (self.person_iname.length == 0) {
            self.person_iname = @"匿名";
        }
        self.person_pic = dic[@"person_pic"];
        self.is_expert = dic[@"is_expert"];
        self.group_id = dic[@"group_id"];
        self.group_pic = dic[@"group_pic"];
        self.group_name = dic[@"group_name"];
        self.creater_id = dic[@"creater_id"];
        
        self.group_name = [MyCommon translateHTML:self.group_name];
        self.person_iname = [MyCommon translateHTML:self.person_iname];
        self.group_name = [MyCommon MyfilterHTML:self.group_name];
        self.person_iname = [MyCommon MyfilterHTML:self.person_iname];
        [self activityMessageContent];
    }
    return self;
}

-(CGFloat)getCellHeightWithString:(NSString *)content{
    CGFloat totalHeight = 0;
    CGFloat height = 0.0;
    NSString * contentOne = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    MLEmojiLabel *emojiLabel = [GroupInvite_DataModal emojiLabel:contentOne numberOfLines:3];
    emojiLabel.frame = CGRectMake(0, 0,ScreenWidth - 64, 0);
    [emojiLabel sizeToFit];
    height = emojiLabel.frame.size.height;
    CGFloat contentViewY = 8;
    CGFloat contentLbY = 30;
    CGFloat timeLbHeight = 21;
    totalHeight = contentViewY + contentLbY + height + timeLbHeight;
    return totalHeight;
}

+(MLEmojiLabel *)emojiLabel:(NSString *)text numberOfLines:(int)num
{
    MLEmojiLabel * emojiLabel;
    emojiLabel = [[MLEmojiLabel alloc]init];
    emojiLabel.numberOfLines = num;
    emojiLabel.font = TWEELVEFONT_COMMENT;
    emojiLabel.textColor = UIColorFromRGB(0xaaaaaa);
    emojiLabel.backgroundColor = [UIColor clearColor];
    emojiLabel.lineBreakMode = NSLineBreakByWordWrapping;
    emojiLabel.isNeedAtAndPoundSign = YES;
    emojiLabel.customEmojiRegex = Custom_Emoji_Regex;
    emojiLabel.customEmojiPlistName = @"emoticons.plist";
    [emojiLabel setEmojiText:text];
    return emojiLabel;
}

@end
