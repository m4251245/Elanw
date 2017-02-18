//
//  ELAspectantDiscuss_Modal.h
//  jobClient
//
//  Created by YL1001 on 15/9/6.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "PageInfo.h"

@interface ELAspectantDiscuss_Modal : PageInfo

@property(nonatomic,copy) NSString *recordId;
@property(nonatomic,copy) NSString *personId;
@property(nonatomic,copy) NSString *YTZ_id;
@property(nonatomic,copy) NSString *BYTZ_Id;
@property(nonatomic,copy) NSString *status;
@property(nonatomic,copy) NSString *dataTime;
@property(nonatomic,copy) NSString *isComment;
@property(nonatomic,copy) NSString *isInCome;
@property(nonatomic,copy) NSString *phoneNum;
@property(nonatomic,strong) NSMutableArray  *regionArr;
@property(nonatomic,copy) NSString *payStatus; /**<'0表示未支付  100表示支付成功 */
@property(nonatomic,copy) NSString *yuetan_status_desc;   /**<约谈状态描述 */

//退款信息
@property(nonatomic,copy) NSString *refund_id;
@property(nonatomic,copy) NSString *ordco_id;          //'订单编号'
@property(nonatomic,copy) NSString *refund_reason;     //申请理由（用户）
@property(nonatomic,copy) NSString *refuse_reason;     //拒绝理由（行家）
@property(nonatomic,copy) NSString *refund_status;     //退款状态
@property(nonatomic,copy) NSString *refund_idatetime;  //退款时间，包括给用户退款或者行家到款
@property(nonatomic,copy) NSString *refuse_idatetime;  //拒绝退款时间
@property(nonatomic,copy) NSString *acceptRefuseTime;  //接受退款时间
@property(nonatomic,copy) NSString *appeal_idatetime;  //提出申诉时间
@property(nonatomic,copy) NSString *apply_idatetime;   //申请退款时间

//时间地点
@property(nonatomic,copy) NSString *ydrId;
@property(nonatomic,copy) NSString *ydyrId;    //时间地点组合Id
@property(nonatomic,copy) NSString *ydyrIsmain;    //1 约谈发起者已经选择时间地点
@property(nonatomic,copy) NSString *ydyrDatetime;    //
@property(nonatomic,copy) NSString *region;   //约谈地点
@property(nonatomic,copy) NSString *regionId; //

@property(nonatomic,strong) NSMutableArray *regionArray;


//约谈者信息
@property(nonatomic,copy) NSString *user_personId;
@property(nonatomic,copy) NSString *user_name;
@property(nonatomic,copy) NSString *user_nickName;
@property(nonatomic,copy) NSString *user_pic;
@property(nonatomic,copy) NSString *user_zw;
@property(nonatomic,copy) NSString *user_confirm; //确认完成

//约谈的行家信息
@property(nonatomic,copy) NSString *dis_personId;
@property(nonatomic,copy) NSString *dis_personName;
@property(nonatomic,copy) NSString *dis_nickname;
@property(nonatomic,copy) NSString *dis_pic;
@property(nonatomic,copy) NSString *dis_zw;
@property(nonatomic,copy) NSString *personCount; //约谈人数
@property(nonatomic,copy) NSString *isExpert;
@property(nonatomic,copy) NSString *dis_confirm; //确认完成

@property(nonatomic,copy) NSString *course_title;
@property(nonatomic,copy) NSString *course_id;
@property(nonatomic,copy) NSString *course_price;
@property(nonatomic,copy) NSString *course_info; //课程介绍
@property(nonatomic,copy) NSString *course_long;
@property(nonatomic,copy) NSString *course_status;
@property(nonatomic,copy) NSString *course_visit_cnt;
@property(nonatomic,copy) NSString *verifyReason; //审核失败原因

@property(nonatomic,copy) NSString *question;    //咨询问题
@property(nonatomic,copy) NSString *quizzerIntro; //提问者情况
@property(nonatomic,copy) NSString *hasOrder; //有约谈订单

-(instancetype)initWithAspectantDictionary:(NSDictionary *)dic;


@end
