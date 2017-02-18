//
//  ELGroupCommentModel.m
//  jobClient
//
//  Created by 一览iOS on 16/6/2.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELGroupCommentModel.h"
#import "MLEmojiLabel.h"
#import "CommentImageListView.h"
#import "ResumeCommentTag_DataModal.h"

//评论内容的宽度
#define COMMENT_WIDTH [UIScreen mainScreen].bounds.size.width-80
//单元格分成3段，每一段最小高度为50
//#define CELL_PER_HEIGHT 50
//评论内容的边界
//#define COMMENT_MARGIN 15
//行距
//#define LINE_MARGIN 8
//iphone5计算高度差
//#define DELTA_HEIGHT 2
static double LINE_MARGIN = 8;
//static double COMMENT_MARGIN = 15;
//static double CELL_PER_HEIGHT = 50;

@implementation ELGroupCommentModel

-(id)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        NSMutableDictionary *subDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
        [subDic removeObjectForKey:@"_person_detail"];
        NSDictionary *personDic = dic[@"_person_detail"];
        if ([personDic isKindOfClass:[NSDictionary class]]){
            [subDic addEntriesFromDictionary:personDic];
        }
        [self setValuesForKeysWithDictionary:subDic];
        self.content = [MyCommon translateHTML:self.content];
        self.person_iname = [MyCommon translateHTML:self.person_iname];
        self.user_name = [MyCommon translateHTML:self.user_name];
        self.parent_name = [MyCommon translateHTML:self.parent_name];
    }
    return self;
}

-(id)initWithDictionaryOne:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        NSMutableDictionary *subDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
        [subDic removeObjectForKey:@"_person_detail"];
        NSDictionary *personDic = dic[@"_person_detail"];
        if ([personDic isKindOfClass:[NSDictionary class]]){
            [subDic addEntriesFromDictionary:personDic];
        }
        [self setValuesForKeysWithDictionary:subDic];
        self.content = [MyCommon removeHtmlImg:self.content];
        self.person_iname = [MyCommon translateHTML:self.person_iname];
        self.user_name = [MyCommon translateHTML:self.user_name];
        self.parent_name = [MyCommon translateHTML:self.parent_name];
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.id_ = value;
    }
    else if([key isEqualToString:@"_parent_person_detail"]){
        if ([value isKindOfClass:[NSDictionary class]]) {
            self._parent_person_detail = [[ELGroupPersonModel alloc] initWithDictionary:value];
        }
    }
    else if ([key isEqualToString:@"_floor_num"]){
        self._floor_num = [NSString stringWithFormat:@"%@楼",value];
    }
    else if ([key isEqualToString:@"_parent_comment"]){
        if ([value isKindOfClass:[NSDictionary class]]) {
            self._parent_comment = [[ELGroupCommentModel alloc] initWithDictionary:value]; 
        }
    }
    else if ([key isEqualToString:@"tags"]){
        NSMutableArray *tagsArr = [[NSMutableArray alloc] init];
        if ([value isKindOfClass:[NSArray class]]) {
            NSArray *tagsListArr = value;
            for (id dict in tagsListArr) {
                ResumeCommentTag_DataModal *model = [[ResumeCommentTag_DataModal alloc] init];
                model.tagId_ = [dict objectForKey:@"ylt_id"];
                model.tagName_ = [dict objectForKey:@"ylt_name"];
                [tagsArr addObject:model];
            }
        }
        
        self.tagsList = tagsArr;
    }
//    else if ([key isEqualToString:@"share"]){
//        NSDictionary *shareDic = value;
//        self.slave = [shareDic objectForKey:@"slave"];
//    }
    else{
       [super setValue:value forKey:key]; 
    }
}

-(void)changeCellHeight{
    CGFloat totalHeight = 50;
    //计算引用的评论的高度
    if (self._parent_comment){
        //评论引用
        ELGroupCommentModel *parentComment = self._parent_comment;
        //过滤html字符串除了br
        parentComment.content = [MyCommon MyfilterHTMLExceptBr:parentComment.content];
        //用户名
        NSString *pUserName = @"";
        if (self._parent_person_detail.person_iname && ![self._parent_person_detail.person_iname isEqualToString:@""]) {
            pUserName = self._parent_person_detail.person_iname;
        }else if (self._parent_person_detail.person_nickname && ![self._parent_person_detail.person_nickname isEqualToString:@""]){
            pUserName = self._parent_person_detail.person_nickname;
        }else{
            //未知用户
            pUserName = @"匿名";
        }
        //删除评论的空格
        NSString *patten = @"\\n|\\t";
        NSError *error = NULL;
        NSRegularExpression *expression = [[NSRegularExpression alloc]initWithPattern:patten options:NSRegularExpressionCaseInsensitive error:&error];
        NSMutableString *temp = [[NSMutableString alloc] initWithString:parentComment.content];
        [expression replaceMatchesInString:temp options:0 range:NSMakeRange(0, temp.length) withTemplate:@""];
        //引用的内容
        NSString *pContent;
        if ([temp hasPrefix:@"http://"]) {
            pContent = [NSString stringWithFormat:@"|%@：", pUserName];
        }else{
            pContent = [NSString stringWithFormat:@"|%@：%@", pUserName, temp];
        }
        NSMutableAttributedString *string = [pContent getHtmlAttStringWithFont:FOURTEENFONT_CONTENT color:[UIColor colorWithRed:166.0/255 green:166.0/255 blue:166.0/255 alpha:1.0]];
        NSMutableParagraphStyle *paragraphStyleOne = [[NSMutableParagraphStyle alloc] init];
        paragraphStyleOne.lineSpacing = 4;
        [string addAttribute:NSParagraphStyleAttributeName value:paragraphStyleOne range:NSMakeRange(0,string.length)];
        self.parentAttString = [[Manager shareMgr] getEmojiStringWithAttString:string withImageSize:CGSizeMake(18,18)];
        UILabel *lable = [[UILabel alloc] init];
        lable.frame = CGRectMake(56, 50+LINE_MARGIN, COMMENT_WIDTH,MAXFLOAT);
        lable.numberOfLines = 2;
        [lable setAttributedText:self.parentAttString];
        [lable sizeToFit];
        self.parentFrame = CGRectMake(56, 50+LINE_MARGIN,lable.frame.size.width,lable.frame.size.height);
        totalHeight = CGRectGetMaxY(self.parentFrame);
    }
    
    //self.content = [MyCommon MyfilterHTMLExceptBr:self.content];
    NSMutableAttributedString *string = [self.content getHtmlAttStringWithFont:FOURTEENFONT_CONTENT color:BLACKCOLOR];
    NSMutableParagraphStyle *paragraphStyleOne = [[NSMutableParagraphStyle alloc] init];
    paragraphStyleOne.lineSpacing = 4;
    [string addAttribute:NSParagraphStyleAttributeName value:paragraphStyleOne range:NSMakeRange(0,string.length)];
    self.commentAttString = [[Manager shareMgr] getEmojiStringWithAttString:string withImageSize:CGSizeMake(18,18)];
    UILabel *lable = [[UILabel alloc] init];
    lable.numberOfLines = 0;
    lable.frame = CGRectMake(56,totalHeight+LINE_MARGIN, COMMENT_WIDTH,MAXFLOAT);
    [lable setAttributedText:self.commentAttString];
    [lable sizeToFit];
    
    self.commentFrame = CGRectMake(56,totalHeight+LINE_MARGIN,lable.frame.size.width,lable.frame.size.height);
    totalHeight = CGRectGetMaxY(self.commentFrame)+LINE_MARGIN;
    ;

    if([self._pic_list isKindOfClass:[NSArray class]]){
        if (self._pic_list.count > 0) {
            CGSize size = [CommentImageListView imageSizeWithCount:self._pic_list.count];
            totalHeight += size.height;
        }
    }
    totalHeight += LINE_MARGIN;//底部的行间距
    //行间距的高度为10
    self.cellHeight = totalHeight;
}
 
@end
