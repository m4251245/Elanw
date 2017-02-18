//
//  AnswerListModal.m
//  jobClient
//
//  Created by YL1001 on 16/6/3.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "AnswerListModal.h"

@implementation AnswerListModal

-(instancetype)init{
    self = [super init];
    if (self) {
        self.answer_person_detail = [[ELSameTradePeopleModel alloc] init];
    }
    return self;
}

-(instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"_comment_list"])
    {
        NSMutableArray *commentArr = [[NSMutableArray alloc] init];
        NSArray *commentListArr = value;
        for (id dict in commentListArr) {
            ReplyCommentModal *commentModal = [[ReplyCommentModal alloc] init];
            [commentModal setValuesForKeysWithDictionary:dict];
            commentModal.comment_content = [MyCommon MyfilterHTML:commentModal.comment_content];
            commentModal.comment_content = [MyCommon translateHTML:commentModal.comment_content];
            [commentArr addObject:commentModal];
        }
        self.comment_list = commentArr;
    }
    else if ([key isEqualToString:@"answer_person_detail"] || [key isEqualToString:@"answer_person_deatil"])
    {
        NSDictionary *dict = value;
        if ([dict isKindOfClass:[NSDictionary class]]) {
            self.answer_person_detail = [[ELSameTradePeopleModel alloc] initWithDictionary:dict];
        }
    }
    else if ([key isEqualToString:@"_dashang_total"]) {
            self.dashang_total = value;
    }else{
        [super setValue:value forKey:key];
    }
}

-(void)creatAttString{
    NSMutableAttributedString *personStr;
    if (self.answer_person_detail.person_job_now && ![self.answer_person_detail.person_job_now isEqualToString:@""]){
        personStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ · %@",self.answer_person_detail.person_iname,self.answer_person_detail.person_job_now]];
        [personStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xbdbdbd) range:NSMakeRange(self.answer_person_detail.person_iname.length,personStr.string.length - self.answer_person_detail.person_iname.length)];
        [personStr addAttribute:NSFontAttributeName value:THIRTEENFONT_CONTENT range:NSMakeRange(self.answer_person_detail.person_iname.length,personStr.string.length - self.answer_person_detail.person_iname.length)];
    }else if (self.answer_person_detail.person_zw && ![self.answer_person_detail.person_zw isEqualToString:@""]){
        personStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ · %@",self.answer_person_detail.person_iname,self.answer_person_detail.person_zw]];
        [personStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xbdbdbd) range:NSMakeRange(self.answer_person_detail.person_iname.length,personStr.string.length - self.answer_person_detail.person_iname.length)];
        [personStr addAttribute:NSFontAttributeName value:THIRTEENFONT_CONTENT range:NSMakeRange(self.answer_person_detail.person_iname.length,personStr.string.length - self.answer_person_detail.person_iname.length)];
    }
    else{
        personStr = [[NSMutableAttributedString alloc] initWithString:self.answer_person_detail.person_iname];
    }
    self.personNameAttString = personStr;
}

-(void)changeAnswerContent:(ELButtonView *)view{
    NSMutableParagraphStyle *paragraphStyleOne = [[NSMutableParagraphStyle alloc] init];
    paragraphStyleOne.lineSpacing = 4;
    NSDictionary *attributes = @{
                                 NSParagraphStyleAttributeName:paragraphStyleOne,
                                 NSForegroundColorAttributeName:UIColorFromRGB(0x666666),
                                 NSFontAttributeName:THIRTEENFONT_CONTENT,
                                 };
    NSString *content = self.answer_content;
    content = [NSString stringWithFormat:@"<!DOCTYPE html><html><head><meta charset=\"utf-8\"><style type=\"text/css\">img{display: inline-block;height:auto;}</style></head><body>%@</body></html>",content];
    
    content = [content stringByReplacingOccurrencesOfString:@"<img " withString:[NSString stringWithFormat:@"<img style=\"max-width:%fpx\" ",ScreenWidth-60]];
    
    //content = [NSString stringWithFormat:@"<!DOCTYPE html><html><head><meta charset=\"utf-8\"><style type=\"text/css\">img{display: inline-block;max-width:%f;height:auto;}</style></head><body>%@</body></html>",ScreenWidth-60,content];
    NSMutableAttributedString *string = [content getHtmlAttString];
    [string addAttributes:attributes range:NSMakeRange(0,string.length)];
    string = [[Manager shareMgr] getEmojiStringWithAttString:string withImageSize:CGSizeMake(18,18)];
    view.frame = CGRectMake(0,0,ScreenWidth-60,30);
    [view setAttributedText:string];
    [view layoutFrame];
    self.answerContentAttString = string;
    self.answerFrame = CGRectMake(50,45,ScreenWidth-60,view.frame.size.height);
    self.cellHeight = CGRectGetMaxY(self.answerFrame)+28;
}

-(void)changeReplyContent:(ELButtonView *)view{
    [view setNumberlines:0];
    CGFloat startY = self.cellHeight;
    NSInteger count = self.comment_list.count <= 2 ? self.comment_list.count:2;
    for (NSInteger i = 0; i < count; i++){
        ReplyCommentModal *commentModel = [self.comment_list objectAtIndex:i];
        NSString * str;
        NSMutableAttributedString *mutableStr;
        NSString *pUserName;
        if (commentModel.parent_person_iname && ![commentModel.parent_person_iname isEqualToString:@""]) {
            str = [NSString stringWithFormat:@"[%@回复%@]：",commentModel.person_iname, commentModel.parent_person_iname];
            pUserName = commentModel.parent_person_iname;
        }
        else
        {
            str = [NSString stringWithFormat:@"[%@回复%@]：",commentModel.person_iname, self.answer_person_detail.person_iname];
            pUserName = self.answer_person_detail.person_iname;
        }
        NSString *content = [NSString stringWithFormat:@"%@%@",str,commentModel.comment_content];
        mutableStr = [content getHtmlAttString];
        [mutableStr addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x666666),NSFontAttributeName:THIRTEENFONT_CONTENT} range:NSMakeRange(str.length,mutableStr.length-str.length)];
        if (commentModel.person_iname && ![commentModel.person_iname isEqualToString:@""]) {
            [mutableStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x416ca2) range:NSMakeRange(1, commentModel.person_iname.length)];
        }
        if (pUserName && ![pUserName isEqualToString:@""]) {
            NSInteger start =1 +2;
            if (commentModel.person_iname.length) {
                start = start + commentModel.person_iname.length;
            }
            [mutableStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x416ca2) range:NSMakeRange(start, pUserName.length)];
        }
        mutableStr = [[Manager shareMgr] getEmojiStringWithAttString:mutableStr withImageSize:CGSizeMake(18,18)];
        commentModel.contentAttString = mutableStr;
        view.frame = CGRectMake(0,0,ScreenWidth-60,20);
        [view setAttributedText:mutableStr];
        [view layoutFrame];
        commentModel.contentFrame = CGRectMake(50,startY,ScreenWidth-60,view.frame.size.height);
        startY = CGRectGetMaxY(commentModel.contentFrame);
        if (i == 0) {
            startY += 5;
        }
    }
    if (self.comment_list.count > 2){
        startY += 23;
    }
    self.cellHeight = startY;
}

@end
