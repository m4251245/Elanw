//
//  CompanyHRAnswer_DataModal.h
//  Association
//
//  Created by YL1001 on 14-6-25.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "PageInfo.h"

@interface CompanyHRAnswer_DataModal : PageInfo

@property(nonatomic,strong)  NSString       * id_;              //对应id
@property(nonatomic,strong)  NSString       * companyId_;       //公司id
@property(nonatomic,strong)  NSString       * cname_;           //公司名称
@property(nonatomic,strong)  NSString       * quizzerId_;       //提问者id
@property(nonatomic,strong)  NSString       * quizzerName_;     //提问者姓名
@property(nonatomic,strong)  NSString       * quizzerPic_;      //提问者头像
@property(nonatomic,strong)  NSString       * questionTitle_;   //问题标题
@property(nonatomic,strong)  NSString       * questionType_;    //问题类型
@property(nonatomic,strong)  NSString       * questionIdate_;   //提问时间
@property(nonatomic,strong)  NSString       * answerContent_;   //回答内容
@property(nonatomic,strong)  NSString       * answerPerson_;    //回答者
@property(nonatomic,strong)  NSString       * answerIdate_;     //回答时间
@property(nonatomic,assign)  BOOL             isAnswered_;      //是否已回答
@property(nonatomic,assign)  BOOL             isShow_;          //是否显示
@property(nonatomic,strong)  NSString       * answerId_;        //回答的id
@property(nonatomic,strong)  NSString       * tradeId_;         //行业id
@property(nonatomic,strong)  NSString       * totalId_;         //总网id
@property(nonatomic,strong)  NSString       * quizzerSex_;      //提问者性别


@end
