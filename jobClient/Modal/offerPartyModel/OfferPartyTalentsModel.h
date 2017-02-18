//
//  OfferPartyTalentsModel.h
//  jobClient
//
//  Created by YL1001 on 16/6/12.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "PageInfo.h"

@interface OfferPartyTalentsModel : PageInfo

//offer派人才端
@property (nonatomic, copy) NSString *jobfair_members;
@property (nonatomic, copy) NSString *jobfair_banner;
@property (nonatomic, copy) NSString *jobfair_zhiwei;
@property (nonatomic, copy) NSString *jobfair_id;
@property (nonatomic, copy) NSString *jobfair_time;
@property (nonatomic, copy) NSString *jobfair_manageid;
@property (nonatomic, copy) NSString *jobfair_content;
@property (nonatomic, copy) NSString *jobfair_name;

@property (nonatomic, copy) NSString *logo_src;
@property (nonatomic, copy) NSString *banner_src;
@property (nonatomic, copy) NSString *team_code;
@property (nonatomic, copy) NSString *company_count;
@property (nonatomic, copy) NSString *filepath;
@property (nonatomic, copy) NSString *add_user;
@property (nonatomic, copy) NSString *link_manid;
@property (nonatomic, copy) NSString *offer_rate;
@property (nonatomic, copy) NSString *fromtype;
@property (nonatomic, copy) NSString *istuijian;
@property (nonatomic, copy) NSString *add_time;
@property (nonatomic, copy) NSString *classify_id;
@property (nonatomic, copy) NSString *tradeid;

@property (nonatomic, copy) NSString *share_friend_content;
@property (nonatomic, copy) NSString *share_pyq_content;
@property (nonatomic, copy) NSString *share_friend_title;
@property (nonatomic, copy) NSString *xuanchuan_url;
@property (nonatomic, copy) NSString *share_img;

@property (nonatomic, copy) NSString *place_regionname;
@property (nonatomic, copy) NSString *place_name;
@property (nonatomic, copy) NSString *place_id;

@property (nonatomic, assign) BOOL iscome;     //1已签到
@property (nonatomic, assign) BOOL isjoin;     //1已报名
@property (assign, nonatomic) BOOL isNew;

@property(nonatomic,strong) NSMutableAttributedString *attStringTitle;
@property(nonatomic,strong) NSMutableAttributedString *attStringContent;
@property(nonatomic,strong) NSMutableAttributedString *attStringDetial;

@property(nonatomic,strong) NSString *hrId;         /**<hr绑定的一览Id */
@property(nonatomic,strong) NSString *state;        /**<面试通知状态 */
@property(nonatomic,strong) NSString *recommendId;  /**<推荐Id */
@property(nonatomic,strong) NSString *companyId;    /**<公司Id */
@property(nonatomic,strong) NSString *companyName;  /**<公司名称 */
@property(nonatomic,strong) NSString *personId;
@property(nonatomic,strong) NSString *msgType;      /**<推送数据类型 */ //2：面试结果 30：取消面试通知。 100面试通知 200面试准备

@end

@interface ELOfferListModel : PageInfo

@property (nonatomic, copy) NSString *project_title;
@property (nonatomic, copy) NSString *fromtype;
@property (nonatomic, copy) NSString *holdtime_order;
@property (nonatomic, copy) NSString *project_place_id;
@property (nonatomic, copy) NSString *jjr_project_id;
@property (nonatomic, copy) NSString *jobfair_id;
@property (nonatomic, copy) NSString *fromtypestr;
@property (nonatomic, copy) NSString *place_name;
@property (nonatomic, copy) NSString *logo_src;
@property (nonatomic, copy) NSString *project_holdtime;
@property (nonatomic, strong) NSMutableArray *jobfairCnt;
@property (nonatomic,assign) CGRect lableViewFrame;
@property (nonatomic,assign) CGFloat cellHeight;
@property (nonatomic,strong) NSMutableArray *lableArr;

-(void)creatLabel;
-(id)initWithDic:(NSDictionary *)dic;

@end

@interface ELOfferCountModel : NSObject

@property (nonatomic, copy) NSString *labelName;
@property (nonatomic, copy) NSString *labelCount;

-(id)initWithDic:(NSDictionary *)dic;

@end
