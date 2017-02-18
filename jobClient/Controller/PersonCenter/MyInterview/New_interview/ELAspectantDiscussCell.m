//
//  ELAspectantDiscussCell.m
//  jobClient
//
//  Created by YL1001 on 15/9/4.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ELAspectantDiscussCell.h"


@implementation ELAspectantDiscussCell

@synthesize stasuBtn;

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.contentBgView_.layer.cornerRadius = 8;
   
    _quizzerImg_.layer.cornerRadius = 17.5f;
    _quizzerImg_.layer.masksToBounds = YES;
    
    _answerImg_.layer.cornerRadius = 17.5f;
    _answerImg_.layer.masksToBounds = YES;
}

-(void)giveDataModel:(ELAspectantDiscuss_Modal *)dataModal
{
    self.titleLb_.text = [MyCommon translateHTML:dataModal.course_title];
    self.costLb_.text = [NSString stringWithFormat:@"￥%@ 元/次",dataModal.course_price];
    
    [self.quizzerImg_ sd_setImageWithURL:[NSURL URLWithString:dataModal.user_pic] placeholderImage:[UIImage imageNamed:@"bg__xinwen"]];
    self.quizzerName_.text = [MyCommon translateHTML:dataModal.user_name];
    self.quizzerJob_.text = [MyCommon translateHTML:dataModal.user_zw];
    
    [self.answerImg_ sd_setImageWithURL:[NSURL URLWithString:dataModal.dis_pic] placeholderImage:[UIImage imageNamed:@"bg__xinwen"]];
    self.answerName_.text = dataModal.dis_personName;
    self.answerJob_.text = dataModal.dis_zw;
    
    self.TimeLb.text = dataModal.dataTime;
    
    [stasuBtn setTitle:dataModal.yuetan_status_desc forState:UIControlStateNormal];
    
    if ([dataModal.YTZ_id isEqualToString:[Manager getUserInfo].userId_]) {//约谈发起者
//      0等待中 1确认约谈 3约谈中 5已完成约 7已评价(暂不使用) 10不约谈 11终止约谈
        switch ([dataModal.status integerValue]) {
            case 0:
            {//待回应      (用户等待行家回应)
                [stasuBtn setTitle:@"待回应" forState:UIControlStateNormal];
            }
                break;
            case 1:
            {//表示行家接受约谈，用户进行支付操作
                if ([dataModal.payStatus isEqualToString:@"0"]) {//表示未支付;
                    [stasuBtn setTitle:@"待付款" forState:UIControlStateNormal];
                }
                else if ([dataModal.payStatus isEqualToString:@"100"])
                {//表示已支付
                    [stasuBtn setTitle:@"待确认完成" forState:UIControlStateNormal];
                }
            }
                break;
            case 5:
            {//表示至少有一个确认
                if ([dataModal.user_confirm isEqualToString:@"1"]) {
                    if ([dataModal.isComment isEqualToString:@"1"]) {
                        [stasuBtn setTitle:@"已评价" forState:UIControlStateNormal];
                    }
                    else
                    {
                        [stasuBtn setTitle:@"待评价" forState:UIControlStateNormal];
                    }
                }
                else if ([dataModal.user_confirm isEqualToString:@"0"])
                {
                    [stasuBtn setTitle:@"待确认完成" forState:UIControlStateNormal];
                }
            }
                break;
            case 10:
            {//拒绝约谈
                [stasuBtn setTitle:@"行家已拒绝" forState:UIControlStateNormal];
            }
                break;
            case 11:
            {//取消订单
                [stasuBtn setTitle:@"已取消" forState:UIControlStateNormal];
            }
                break;
            default:
            {
                [stasuBtn setTitle:@"已结束" forState:UIControlStateNormal];
            }
                break;
        }
    }
    else
    {
        switch ([dataModal.status integerValue]) {//被约谈者
            case 0:
            {//用户发起约谈，行家接受或者拒绝
                [stasuBtn setTitle:@"待接受约谈" forState:UIControlStateNormal];
            }
                break;
            case 1:
            {//表示行家接受约谈，等待用户进行支付操作
                if ([dataModal.payStatus isEqualToString:@"0"]) {//表示未支付
                    [stasuBtn setTitle:@"等待用户支付" forState:UIControlStateNormal];
                }
                else if ([dataModal.payStatus isEqualToString:@"100"])
                {//表示已支付
                    [stasuBtn setTitle:@"待确认完成" forState:UIControlStateNormal];
                }
            }
                break;
            case 5:
            {
                if ([dataModal.dis_confirm isEqualToString:@"0"]) {//表示行家未确认完成
                    [stasuBtn setTitle:@"待确认完成" forState:UIControlStateNormal];
                }
                else if([dataModal.dis_confirm isEqualToString:@"1"])//表示行家已确认完成
                {
                    if ([dataModal.user_confirm isEqualToString:@"1"]) {//表示用户已确认完成
                        [stasuBtn setTitle:@"待收款" forState:UIControlStateNormal];
                    }
                    else
                    {//表示用户未确认完成
                        [stasuBtn setTitle:@"等待用户确认" forState:UIControlStateNormal];
                    }
                }
            }
                break;
            case 10:
            {
                [stasuBtn setTitle:@"你已拒绝" forState:UIControlStateNormal];
            }
                break;
            case 11:
            {//取消订单
                [stasuBtn setTitle:@"已取消" forState:UIControlStateNormal];
            }
                break;
            default:
            {
                [stasuBtn setTitle:@"已结束" forState:UIControlStateNormal];
            }
                break;
        }
        
        //款项相关
        if ([dataModal.dis_confirm isEqualToString:@"1"]) {
            if ([dataModal.isInCome isEqualToString:@"1"]) {
                [stasuBtn setTitle:@"已结束" forState:UIControlStateNormal];
            }
            else if ([dataModal.isInCome isEqualToString:@"0"])
            {
                [stasuBtn setTitle:@"待收款" forState:UIControlStateNormal];
            }
        }
        else
        {
            if ([dataModal.isInCome isEqualToString:@"3"]) {
                [stasuBtn setTitle:@"已结束" forState:UIControlStateNormal];
            }
        }
    }
    
    if (dataModal.refund_id != nil) {
        [self refundStatus:dataModal];
    }
}

- (void)refundStatus:(ELAspectantDiscuss_Modal *)dataModal
{
    if ([dataModal.YTZ_id isEqualToString:[Manager getUserInfo].userId_]) {
        //退款状态 0申请中 1同意退款（行家） 3拒绝退款（行家）100已退款（行家同意） 110已申诉 120调解成功（已退款给用户） 130调解失败（打钱给行家）
        switch ([dataModal.refund_status integerValue]) {
            case 0:
            {//申请中
                [stasuBtn setTitle:@"待同意退款" forState:UIControlStateNormal];
            }
                break;
            case 1:
            {//同意退款
                [stasuBtn setTitle:@"等待退款" forState:UIControlStateNormal];
            }
                break;
            case 3:
            {//拒绝退款
                [stasuBtn setTitle:@"等待申述调解" forState:UIControlStateNormal];
            }
                break;
            case 100:
            {//已退款（行家同意）
                [stasuBtn setTitle:@"退款成功" forState:UIControlStateNormal];
            }
                break;
            case 130:
            {//调解失败（打钱给行家）
                [stasuBtn setTitle:@"退款未成功" forState:UIControlStateNormal];
            }
                break;
            case 120:
            {//调解成功（已退款给用户）
                [stasuBtn setTitle:@"退款成功" forState:UIControlStateNormal];
            }
                break;
            case 110:
            {//已申诉
                [stasuBtn setTitle:@"等待申诉结果" forState:UIControlStateNormal];
            }
                break;
            default:
                break;
        }
    }
    else
    {
        switch ([dataModal.refund_status integerValue]) {
            case 0:
            {//申请中
                [stasuBtn setTitle:@"待同意退款" forState:UIControlStateNormal];
            }
                break;
            case 1:
            {//同意退款
                [stasuBtn setTitle:@"等待退款" forState:UIControlStateNormal];
            }
                break;
            case 3:
            {//拒绝退款
                [stasuBtn setTitle:@"等待申述调解" forState:UIControlStateNormal];
            }
                break;
            case 100:
            {//退款成功
                [stasuBtn setTitle:@"已退款" forState:UIControlStateNormal];
            }
                break;
            case 130:
            {//调解失败（打钱给行家）
                [stasuBtn setTitle:@"已结束" forState:UIControlStateNormal];
            }
                break;
            case 120:
            {//调解成功（已退款给用户）
                [stasuBtn setTitle:@"已退款" forState:UIControlStateNormal];
            }
                break;
            case 110:
            {//已申诉
                [stasuBtn setTitle:@"等待申诉结果" forState:UIControlStateNormal];
            }
                break;
            default:
                break;
        }
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
