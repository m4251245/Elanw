//
//  SalaryCompareResultCtl.h
//  jobClient
//
//  Created by YL1001 on 14-9-26.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "ExRequetCon.h"
#import "SalaryResult_DataModal.h"


#define  UnderTen   @"哎呦我去！人艰不拆呀，这样下去变乞丐了，你被老板坑了吧？你的工资只打败了不足00%的同行？！醒醒吧，骚年！别原地踏步浪费青春了。"
#define  Ten        @"两个黄鹂鸣翠柳，咱的工资实在糗！你只比穷屌丝高一级，不过还是屌丝一枚。你的收入只打败了00%的同样情况的小伙伴。不想再背负屌丝之名？果断跳槽吧。"
#define  Twenty     @"啥？！像你这么努力的人，工资收入只打败了00%的小伙伴，瓜农收入都比你高了，与其这样，不如回家种地。老板周扒皮，员工可不做扒皮鱼！考虑下换个工作吧？"
#define  Thirty     @"我不得不说你是职场菜鸟了，你每天起早贪黑，工资还是只打败了00%的同行，为此我表示悲伤。想让薪资飞升，那就别再安于现状，崛起吧，新的机会等着你。"
#define  Fourty     @"房价涨了油价涨了白菜价都涨了，就是工资不涨。你的薪水原地踏步，你只打败了00%的小伙伴。亲，反抗的时候到了，是时候换份工作了。"
#define  Fifty      @"你的薪资处于中等水平，比上不足，比下有余，差一点你的工资就到及格线了。你的薪水只打败了00%的同行小伙伴。你还处于苦逼的房奴级别，每天处于温饱边缘，不想再这样了？那就换工作吧！"
#define  Sixty      @"孔子和奥巴马都说过，不会炒菜的司机不是好美工。恭喜你算是白领级人物了，你的薪水打败了00%的人，你也应该得到更广阔的发展平台，还不快来试试？"
#define  Seventy    @"大侠，在下佩服佩服！你的薪水打败了00%的人，你的事迹在江湖广为流传，以你的身份，这点薪水何以彰显你尊贵的身份？！各大帮派都迫切希望招纳像你这样的高手，快来接下英雄帖！"
#define  Eighty     @"一分耕耘一份收获，你的薪水打败了00%的人。难道你就是传说中的高富帅，求关注！不过像你这么优秀的人才，老板不给加薪合适嘛！下面这个职位都很nice，要不关注一下？~"
#define  Ninety     @"土豪，我们做朋友吧！你的收入已经逆天，人类已经不适合你居住了！你打败了00%的人！同行都在仰望膜拜你了。"

@interface SalaryCompareResultCtl : BaseListCtl
{
    IBOutlet    UIView          *   headView_;
    IBOutlet    UILabel         *   salaryLb_;
    IBOutlet    UIImageView     *   sexImgView_;
    IBOutlet    UILabel         *   nameLb_;
    IBOutlet    UILabel         *   percentLb_;
    IBOutlet    UILabel         *   contentLb_;
    
    IBOutlet    UIView          *   cityPercentView_;
    IBOutlet    UILabel         *   gzLb_;
    IBOutlet    UILabel         *   bjLb_;
    IBOutlet    UILabel         *   shLb_;
    IBOutlet    UILabel         *   szLb_;
    
    IBOutlet    UIButton        *   mybackBtn_;
    IBOutlet    UIButton        *   shareBtn_;
    
    IBOutlet    UIActivityIndicatorView  * activityView_;
    
    IBOutlet    UIView          *   footerView_;
    IBOutlet    UIButton        *   backBtn_;
    
    IBOutlet    AttributedLabel *   attributedLb_;
    User_DataModal              *   inModal_;
    SalaryResult_DataModal      *   myModal_;
    
    
    RequestCon                  *   shareLogsCon_;
}

@property(nonatomic,strong) NSString * kwFlag_;
@property(nonatomic,strong) NSString * regionId_;
@property (weak, nonatomic) IBOutlet UIButton *sendMsgBtn;

@property (weak, nonatomic) IBOutlet UITextView *msgTV;
@property (weak, nonatomic) IBOutlet UILabel *tipLb;

@property(nonatomic, copy) NSString *orderId;//查薪指的订单id

@property (weak, nonatomic) IBOutlet UIImageView *xiaoXinImgv;

@end
