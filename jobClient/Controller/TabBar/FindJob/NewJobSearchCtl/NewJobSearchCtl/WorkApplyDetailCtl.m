//
//  WorkApplyDetailCtl.m
//  jobClient
//
//  Created by YL1001 on 15/6/16.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "WorkApplyDetailCtl.h"
#import "PositionDetailCtl.h"
#import "NewApplyRecordDataModel.h"

@interface WorkApplyDetailCtl ()
{
    NSMutableArray *textLabelArr;
    NSMutableArray *timeLabelArr;
    
    NSMutableArray *typeArr;
}
@end

@implementation WorkApplyDetailCtl

@synthesize sendLb_,readLb_,collectLb_,mailLb_,sendTime_,readTime_,collectTime_,mailTime_,waitingTime_,spot1_,spot2_,spot3_,spot4_,verticalLine1_,verticalLine2_,verticalLine3_,waitingLb_,recentlyLb_,recentlyTime_,verticalLine4_,verticalLine5_,spot5_,spot6_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    
    workApplyModal_ = [[NewApplyRecordDataModel alloc] init];
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"申请记录"];
    spot1_.image = [UIImage imageNamed:@"icon_ios_lvli_def.png"];
    verticalLine1_.backgroundColor = GRAYCOLOR;
    
    companyLogo_.layer.borderColor = UIColorFromRGB(0xe5e5e5).CGColor;
    companyLogo_.layer.borderWidth = 0.5;
    companyLogo_.layer.masksToBounds = YES;
    
    //没有企业头像隐藏
    if ([workApplyModal_.logo isEqualToString:@"http://img3.job1001.com/uppic/nocypic.gif"]) {
        [companyLogo_ setImage:[UIImage imageNamed:@"positionDefaulLogo.png"]];
    }
    else
    {
        [companyLogo_ sd_setImageWithURL:[NSURL URLWithString:workApplyModal_.logo] placeholderImage:nil];
    }
    
    companyName_.text = workApplyModal_.cname;
    ZWName_.text = workApplyModal_.jtzw;
    salary_.text = workApplyModal_.salary;
    
    [sendTime_ setText:@""];
    [readTime_ setText:@""];
    [collectTime_ setText:@""];
    [mailTime_ setText:@""];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    textLabelArr = [[NSMutableArray alloc] init];
    typeArr = [[NSMutableArray alloc] init];
    
    if (workApplyModal_.readtime != nil) {
        [array addObject:workApplyModal_.readtime];
        [textLabelArr addObject:workApplyModal_.readtime];
        [typeArr addObject:@"readTime"];
    }
    if (workApplyModal_.collecttime != nil) {
        [array addObject:workApplyModal_.collecttime];
        [textLabelArr addObject:workApplyModal_.collecttime];
        [typeArr addObject:@"collectTime"];
    }
    if (workApplyModal_.mailtime != nil) {
        [array addObject:workApplyModal_.mailtime];
        [textLabelArr addObject:workApplyModal_.mailtime];
        [typeArr addObject:@"mailTime"];
    }
    
    timeLabelArr = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0 ; i < array.count; i++)
    {
        NSString *time = [array objectAtIndex:i];;
        time = [time stringByReplacingOccurrencesOfString:@"-" withString:@""];
        time = [time stringByReplacingOccurrencesOfString:@" " withString:@""];
        time =  [time stringByReplacingOccurrencesOfString:@":" withString:@""];
        
        NSMutableDictionary *timeDic = [[NSMutableDictionary alloc] init];
        [timeDic setValue:time forKey:[typeArr objectAtIndex:i]];
        
        [timeLabelArr addObject:timeDic];
    }
    
    timeLabelArr = [self compareTheSizeWith:timeLabelArr];
    
    sendLb_.hidden = YES;
    readLb_.hidden = YES;
    collectLb_.hidden = YES;
    mailLb_.hidden = YES;
    waitingLb_.hidden = YES;
    
    sendTime_.hidden = YES;
    readTime_.hidden = YES;
    collectTime_.hidden = YES;
    mailTime_.hidden = YES;
    waitingTime_.hidden = YES;
    
    spot1_.hidden = YES;
    spot2_.hidden = YES;
    spot3_.hidden = YES;
    spot4_.hidden = YES;
    spot5_.hidden = YES;
    
    verticalLine1_.hidden = YES;
    verticalLine2_.hidden = YES;
    verticalLine3_.hidden = YES;
    verticalLine4_.hidden = YES;
    verticalLine1_.hidden = YES;
    
    [self getDetail];
}


- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    workApplyModal_ = dataModal;
}

- (void)getDetail
{    
    switch (timeLabelArr.count)
    {
        case 0:
        {
            spot5_.hidden = NO;
            waitingLb_.hidden = NO;
            waitingTime_.hidden = NO;
            
            recentlyLb_.text = @"正等待HR查阅...";
            [recentlyTime_ setText:workApplyModal_.sendtime];
            
            [waitingLb_ setText:@"简历投递成功"];
            [waitingTime_ setText:workApplyModal_.sendtime];
            
        }
            break;
        case 1:
        {
            //（1）投递-->面试-->提示，
            //（2）投递-->查阅-->提示
            
            spot5_.hidden = NO;
            waitingLb_.hidden = NO;
            waitingTime_.hidden = NO;
            
            verticalLine4_.hidden = NO;
            spot4_.hidden = NO;
            mailLb_.hidden = NO;
            mailTime_.hidden = NO;
            
            if (workApplyModal_.readtime != nil)
            {
                recentlyLb_.text = @"HR正在拼命筛选中...";
                [recentlyTime_ setText:workApplyModal_.readtime];
                
                [waitingLb_ setText:@"HR查阅了你的简历"];
                [waitingTime_ setText:workApplyModal_.readtime];
            }
            
            if (workApplyModal_.mailtime != nil)
            {
                recentlyLb_.text = @"HR正等着你过去面试...";
                [recentlyTime_ setText:workApplyModal_.mailtime];
                
                [waitingLb_ setText:@"恭喜,HR已经给你发送了面试通知"];
                [waitingTime_ setText:workApplyModal_.mailtime];
            }
            
            [mailLb_ setText:@"简历投递成功"];
            [mailTime_ setText:workApplyModal_.sendtime];
            
        }
            break;
        case 2:
        {
            spot5_.hidden = NO;
            waitingLb_.hidden = NO;
            waitingTime_.hidden = NO;
            
            verticalLine4_.hidden = NO;
            spot4_.hidden = NO;
            mailLb_.hidden = NO;
            mailTime_.hidden = NO;
            
            verticalLine3_.hidden = NO;
            spot3_.hidden = NO;
            collectLb_.hidden = NO;
            collectTime_.hidden = NO;
            
            NSMutableDictionary *dic = [timeLabelArr objectAtIndex:0];
            NSString *typeStr  = [typeArr objectAtIndex:0];
            NSString *time = [textLabelArr objectAtIndex:0];
            [mailTime_ setText:time];
            
            //（1）投递-->查阅-->面试-->提示，
            //（3）投递-->面试-->查阅-->提示，
            if (workApplyModal_.mailtime != nil)
            {
                if ([typeStr isEqualToString:@"readTime"]){
                    [mailLb_ setText:@"HR查阅了你的简历"];
                    
                    dic = [timeLabelArr objectAtIndex:1];
                    time = [textLabelArr objectAtIndex:1];
                    
                    [waitingLb_ setText:@"恭喜,HR已经给你发送了面试通知"];
                    [waitingTime_ setText:time];
                    
                    [recentlyLb_ setText:@"HR正等着你过去面试..."];
                }
                else if ([typeStr isEqualToString:@"mailTime"]){
                    [mailLb_ setText:@"恭喜,HR已经给你发送了面试通知"];
                    
                    dic = [timeLabelArr objectAtIndex:1];
                    time = [textLabelArr objectAtIndex:1];
                    
                    [waitingLb_ setText:@"HR查阅了你的简历"];
                    [waitingTime_ setText:time];
                    
                    [recentlyLb_ setText:@"HR最近查阅了你的简历..."];
                }
                [recentlyTime_ setText:waitingTime_.text];
            }
            
            //（4）投递-->收藏-->查阅-->提示，
            //（2）投递-->查阅-->收藏-->提示
            if (workApplyModal_.collecttime != nil)
            {
                if ([typeStr isEqualToString:@"readTime"]){
                    [mailLb_ setText:@"HR查阅了你的简历"];
                    
                    dic = [timeLabelArr objectAtIndex:1];
                    time = [textLabelArr objectAtIndex:1];
                    
                    [waitingLb_ setText:@"恭喜,HR已经收藏了你的简历"];
                    [waitingTime_ setText:time];
                    
                    [recentlyLb_ setText:@"HR正在考虑当中..."];
                }
                else if ([typeStr isEqualToString:@"collectTime"]){
                    
                    [recentlyLb_ setText:@"HR最近查阅了你的简历..."];
                    
                    dic = [timeLabelArr objectAtIndex:1];
                    time = [textLabelArr objectAtIndex:1];
                    [waitingLb_ setText:@"HR查阅了你的简历"];
                    [waitingTime_ setText:time];
                    
                    [mailLb_ setText:@"恭喜,HR已经收藏了你的简历"];
                }
                [recentlyTime_ setText:waitingTime_.text];
            }
            
            [collectLb_ setText:@"简历投递成功"];
            [collectTime_ setText:workApplyModal_.sendtime];
            
        }
            break;
        case 3:
        {
            spot5_.hidden = NO;
            waitingLb_.hidden = NO;
            waitingTime_.hidden = NO;
            
            verticalLine4_.hidden = NO;
            spot4_.hidden = NO;
            mailLb_.hidden = NO;
            mailTime_.hidden = NO;
            
            verticalLine3_.hidden = NO;
            spot3_.hidden = NO;
            collectLb_.hidden = NO;
            collectTime_.hidden = NO;
            
            verticalLine2_.hidden = NO;
            spot2_.hidden = NO;
            readLb_.hidden = NO;
            readTime_.hidden = NO;
            
            
            NSMutableDictionary *dic = [timeLabelArr objectAtIndex:0];
            NSString *typeStr  = [typeArr objectAtIndex:0];
            NSString *time = [textLabelArr objectAtIndex:0];
            [collectTime_ setText:time];
            
            //（1）投递-->查阅-->收藏-->面试-->提示，
            //（2）投递-->查阅-->面试-->收藏-->提示，
            if ([typeStr isEqualToString:@"readTime"])
            {
                [collectLb_ setText:@"HR查阅了你的简历"];
                
                dic = [timeLabelArr objectAtIndex:1];
                NSString *typeStr2 = [typeArr objectAtIndex:1];
                time = [textLabelArr objectAtIndex:1];
                
                [mailTime_ setText:time];
                
                //（1）投递-->查阅-->收藏-->面试-->提示，
                if ([typeStr2 isEqualToString:@"collectTime"])
                {
                    [mailLb_ setText:@"恭喜,HR已经收藏了你的简历"];
                    
                    dic = [timeLabelArr objectAtIndex:2];
                    //NSString *str = [typeArr objectAtIndex:2];
                    time = [textLabelArr objectAtIndex:2];
                    
                    [waitingLb_ setText:@"恭喜,HR已经给你发送了面试通知"];
                    [waitingTime_ setText:time];
                    
                    [recentlyLb_ setText:@"HR正等着你过去面试..."];
                }
                else if ([typeStr2 isEqualToString:@"mailTime"])//（2）投递-->查阅-->面试-->收藏-->提示，
                {
                    [mailLb_ setText:@"恭喜,HR已经给你发送了面试通知"];
                    
                    dic = [timeLabelArr objectAtIndex:2];
                    //NSString *str = [typeArr objectAtIndex:2];
                    time = [textLabelArr objectAtIndex:2];
                    
                    [waitingLb_ setText:@"恭喜,HR已经收藏了你的简历"];
                    [waitingTime_ setText:time];
                    
                    [recentlyLb_ setText:@"HR正等着你过去面试..."];
                }
                [recentlyTime_ setText:waitingTime_.text];
            }
            
            //（3）投递-->面试-->查阅-->收藏-->提示，
            //（4）投递-->面试-->收藏-->查阅-->提示。
            if ([typeStr isEqualToString:@"mailTime"])
            {
                [collectLb_ setText:@"恭喜,HR已经给你发送了面试通知"];
                
                dic = [timeLabelArr objectAtIndex:1];
                NSString *typeStr2 = [typeArr objectAtIndex:1];
                time = [textLabelArr objectAtIndex:1];
                
                [mailTime_ setText:time];
                
                //（3）投递-->面试-->查阅-->收藏-->提示，
                if ([typeStr2 isEqualToString:@"readTime"])
                {
                    [mailLb_ setText:@"恭喜,HR最近查阅了你的简历"];
                    
                    dic = [timeLabelArr objectAtIndex:2];
                   // NSString *str = [typeArr objectAtIndex:2];
                    time = [textLabelArr objectAtIndex:2];
                    
                    [waitingLb_ setText:@"恭喜,HR已经收藏了你的简历"];
                    [waitingTime_ setText:time];
                    
                    [recentlyLb_ setText:@"HR正等着你过去面试..."];
                }
                else if ([typeStr2 isEqualToString:@"collectTime"])//（4）投递-->面试-->收藏-->查阅-->提示。
                {
                    [mailLb_ setText:@"恭喜,HR已经收藏了你的简历"];
                    
                    dic = [timeLabelArr objectAtIndex:2];
                    //NSString *str = [typeArr objectAtIndex:2];
                    time = [textLabelArr objectAtIndex:2];
                    
                    [waitingLb_ setText:@"恭喜,HR最近查阅了你的简历"];
                    [waitingTime_ setText:time];
                    
                    [recentlyLb_ setText:@"HR正等着你过去面试..."];
                }
                [recentlyTime_ setText:waitingTime_.text];
            }
            
            //（5）投递-->收藏-->查阅-->面试-->提示。
            //（6）投递-->收藏-->面试-->查阅-->提示。
            if ([typeStr isEqualToString:@"collectTime"])
            {
                [collectLb_ setText:@"恭喜,HR已经收藏了你的简历"];
                
                dic = [timeLabelArr objectAtIndex:1];
                NSString *typeStr2 = [typeArr objectAtIndex:1];
                time = [textLabelArr objectAtIndex:1];
                
                [mailTime_ setText:time];
                
                //（5）投递-->收藏-->查阅-->面试-->提示。
                if ([typeStr2 isEqualToString:@"readTime"])
                {
                    [mailLb_ setText:@"恭喜,HR已经查阅了你的简历"];
                    
                    dic = [timeLabelArr objectAtIndex:2];
                    //NSString *str = [typeArr objectAtIndex:2];
                    time = [textLabelArr objectAtIndex:2];
                    
                    [waitingLb_ setText:@"恭喜,HR已经给你发送了面试通知"];
                    [waitingTime_ setText:time];
                    
                    [recentlyLb_ setText:@"HR正等着你过去面试..."];
                }
                else if ([typeStr2 isEqualToString:@"mailTime"])//（6）投递-->收藏-->面试-->查阅-->提示。
                {
                    [mailLb_ setText:@"恭喜,HR已经给你发送了面试通知"];
                    
                    dic = [timeLabelArr objectAtIndex:2];
                    //NSString *str = [typeArr objectAtIndex:2];
                    time = [textLabelArr objectAtIndex:2];
                    
                    [waitingLb_ setText:@"恭喜,HR最近查阅了你的简历"];
                    [waitingTime_ setText:time];
                    
                    [recentlyLb_ setText:@"HR正等着你过去面试..."];
                }
                [recentlyTime_ setText:waitingTime_.text];
            }
            
            [readLb_ setText:@"简历投递成功"];
            [readTime_ setText:workApplyModal_.sendtime];
        }
            break;
        default:
        {
            
        }
            break;
    }

}

- (IBAction)positionClick:(id)sender
{
    PositionDetailCtl *positionDetailCtl_ = [[PositionDetailCtl alloc] init];
    [self.navigationController pushViewController:positionDetailCtl_ animated:YES];
    
    ZWDetail_DataModal *model = [[ZWDetail_DataModal alloc]init];
    model.zwID_ = workApplyModal_.jobid;
    model.companyName_ = workApplyModal_.cname;
    model.companyID_ = workApplyModal_.reid;
    model.zwName_ = workApplyModal_.jtzw;
    model.companyLogo_ = workApplyModal_.logo;
    [positionDetailCtl_ beginLoad:model exParam:nil];
}

- (NSMutableArray *)compareTheSizeWith:(NSMutableArray *)mutableArray
{
    for (NSInteger i = 0; i < mutableArray.count; i++)
    {
        for (NSInteger j = i+1; j < mutableArray.count; j++)
        {
            NSMutableDictionary *firstDic = [mutableArray objectAtIndex:i];
            NSMutableDictionary *lastDic = [mutableArray objectAtIndex:j];
            
            NSString *firstStr = [firstDic objectForKey:[typeArr objectAtIndex:i]];
            NSString *lastStr = [lastDic objectForKey:[typeArr objectAtIndex:j]];
            
            NSDate *firstDate = [firstStr dateFormStringCurrentLocaleFormat:@"yyyyMMddHHmm"];
            NSDate *lastDate = [lastStr dateFormStringCurrentLocaleFormat:@"yyyyMMddHHmm"];
            
            NSDate *time = [lastDate earlierDate:firstDate];
            
            if ([time isEqualToDate:lastDate])
            {
                [mutableArray exchangeObjectAtIndex:i withObjectAtIndex:j];
                [typeArr exchangeObjectAtIndex:i withObjectAtIndex:j];
                [textLabelArr exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
    return mutableArray;
}




//- (CGSize)labelAutoCalculateRectWith:(NSString*)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize
//{
//    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
//    
//    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
//    
//    NSDictionary* attributes =@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSParagraphStyleAttributeName:paragraphStyle.copy};
//
//    CGSize labelSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
//    
//    labelSize.height=ceil(labelSize.height);
//    
//    labelSize.width=ceil(labelSize.width);
//    
//    return labelSize;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
