//
//  SalaryGuideCtl.h
//  jobClient
//
//  Created by YL1001 on 14-9-24.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "GCPlaceholderTextView.h"
#import "ExRequetCon.h"
#import "SalaryResult_DataModal.h"
#import "AttributedLabel.h"
#import "GXS_SectionHeaderView.h"
#import "SalaryIrrigationDetailCtl.h"
#import "ELSalaryResultModel.h"

//查看别人薪资时显示的文案
#define  UnderTen2   @"哎呦我去！Ta的工资只打败了不足00%的同行？时间等于金钱，Ta已经挥金如土了。这么低的薪资，Ta到底弱在哪里，马上看看："
#define  Ten2        @"两个黄鹂鸣翠柳，咱的工资实在糗！！Ta的收入只打败了00%的同样情况的小伙伴。这么低的薪资，Ta到底弱在哪里，马上看看："
#define  Twenty2     @"Ta这么努力的人，工资收入只打败了00%的小伙伴，不甘心啊！老板周扒皮，员工可不做扒皮鱼！这么低的薪资，Ta到底弱在哪里，马上看看："
#define  Thirty2     @"请允许我做一个悲伤的表情，Ta每天起早贪黑，可工资还是只打败了00%的同行。这么低的薪资，Ta到底弱在哪里，马上看看："
#define  Fourty2     @"房价涨了油价涨了白菜价都涨了，就是工资不涨。Ta的薪水原地停留有一段时间了吧？！Ta只打败了00%的小伙伴。这么低的薪资，Ta到底弱在哪里，马上看看："
#define  Fifty2      @"差一点Ta的工资就到及格线了。老板给Ta的薪水只打败了00%的同行小伙伴。这么低的薪资，Ta到底弱在哪里，马上看看："
#define  Sixty2      @"孔子和奥巴马都说过，不会炒菜的司机不是好美工。Ta的薪水打败了00%的人！Ta需要更广阔的发展平台啊！这么高的薪资，Ta到底厉害在哪里，马上看看："
#define  Seventy2    @"一分耕耘一份收获，Ta的薪水打败了00%的人。不过像！Ta这么优秀的人才，老板不给加薪合适嘛！这么高的薪资，Ta到底厉害在哪里，马上看看："
#define  Eighty2     @"Ta的薪水打败了00%的人，Ta的事迹在江湖广为流传，各大帮派都迫切希望招纳像Ta这样的高手！这么高的薪资，Ta到底厉害在哪里，马上看看："
#define  Ninety2     @"收入逆天！Ta打败了00%的人！系统程序都感觉好累不会再爱。这么高的薪资，Ta到底厉害在哪里，马上看看："


@interface SalaryGuideCtl : BaseListCtl<UITextFieldDelegate,UITextViewDelegate>
{
    IBOutlet    UIView          *   headView_;
    IBOutlet    UIView          *   bgView_;
    IBOutlet    UILabel         *   salaryLb_;
    IBOutlet    UIImageView     *   sexImgView_;
    IBOutlet    UILabel         *   nameLb_;
    IBOutlet    UILabel         *   percentLb_;
    IBOutlet    UILabel         *   contentLb_;
    
    IBOutlet    UIView          *   resumeView_;
    IBOutlet    UILabel         *   educationLb_;
    IBOutlet    UILabel         *   schoolLb_;
    IBOutlet    UILabel         *   zwLb_;
    IBOutlet    UILabel         *   ageLb_;
    IBOutlet    UILabel         *   jobageLb_;
    IBOutlet    UILabel         *   regionLb_;
    IBOutlet    UILabel         *   jobLb_;
    IBOutlet    UIView          *   lineView_;
    
    IBOutlet    UIButton        *   backBtn_;
    IBOutlet    UIButton        *   shareBtn_;
    
    IBOutlet    UIView          *   footerView_;
    IBOutlet    UIButton        *   compareBtn_;
    
    IBOutlet    UIActivityIndicatorView  * activityView_;
    
    IBOutlet    AttributedLabel *   attributedLb_;
    
    GXS_SectionHeaderView       *gxsSectionHeaderView_;
    
//    User_DataModal              *   inModal_;
//    SalaryResult_DataModal      *   myModal_;
//    ELSalaryResultModel           *myModal_;
    
    RequestCon                  *   addlikeCon_;
    RequestCon                  *   shareLogsCon_;
    RequestCon                  *   addCommentCon_;
    RequestCon                  *   submitCon_;
    RequestCon                  *   updateNickNameCon_;
    
    RequestCon                  *   myModalCon_;
    
    BOOL                                bNickName_;
    NSString                            * nickNameStr_;
    
    UITapGestureRecognizer  *singleTapRecognizer_;  //单击的事件
    
}

@property(nonatomic,strong) NSString * kwFlag_;
@property(nonatomic,strong) NSString * regionId_;
@property(nonatomic,strong) UIColor  * bgColor_;

@property(nonatomic,weak) IBOutlet UIView       *commentView_;
@property(nonatomic,weak) IBOutlet UITextField  *commentTF_;
@property(nonatomic,weak) IBOutlet UIButton     *giveCommentBtn_;

@property(nonatomic,assign) BOOL                 noFromMessage_;

@property (nonatomic,assign) BOOL isPop;

@end
