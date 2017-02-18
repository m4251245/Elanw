//
//  Groups_DataModal.h
//  Association
//
//  Created by 一览iOS on 14-1-15.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Author_DataModal.h"
#import "PageInfo.h"
#import "Article_DataModal.h"
#import "Comment_DataModal.h"
#import "Expert_DataModal.h"

@interface Groups_DataModal : PageInfo

@property(nonatomic,strong) NSString * id_;
@property(nonatomic,strong) NSString * createrId_;
@property(nonatomic,strong) NSString * groupCode_;
@property(nonatomic,strong) NSString * name_;
@property(nonatomic,strong) NSString * code_;       //社群编号
@property(nonatomic,strong) NSString * tradeId_;    //行业id
@property(nonatomic,strong) NSString * totalId_;    //总网id
@property(nonatomic,strong) NSString * pic_;
@property(nonatomic,assign) BOOL       bImageLoad_;        //是否已经加载图片
@property(nonatomic,strong) NSData     *imageData_;        //图片data
@property(nonatomic,strong) NSString * intro_;
@property(nonatomic,strong) NSString * auditstatus_;  //审核状态  1为不通过 3为未审核 5为通过
@property(nonatomic,strong) NSString * openstatus_;   //公开状态  1为公开（申请加入） 3为私密  100为所有人可加入
@property(nonatomic,assign) NSInteger        personCnt_;
@property(nonatomic,assign) NSInteger        articleCnt_;
@property(nonatomic,assign) NSInteger        maxMemberCnt_;
@property(nonatomic,assign) NSInteger        msgCtn_;
@property(nonatomic,strong) NSString * idatetime_;
@property(nonatomic,strong) NSString * updatetime_;
@property(nonatomic,strong) NSString * updatetimeLast_;
@property(nonatomic,strong) NSString * tags_;
@property(nonatomic,assign) BOOL       istj_;          //是否推荐
@property(nonatomic,strong) Expert_DataModal   * creater_;

@property(nonatomic,assign) BOOL       isCreater_; //当前访问人是否为创建者
@property(nonatomic,assign) BOOL       invitePerm_; //邀请权限
@property(nonatomic,assign) BOOL       publishPerm_; // 发表权限

@property(nonatomic,strong) Article_DataModal * firstArt_;
@property(nonatomic,strong) Comment_DataModal * firstComm_;
@property(nonatomic,strong) NSMutableArray    *tagsArray_;
@property(nonatomic,strong) NSString    *groupRel_;   //是否加入社群
@property(nonatomic,strong) UIImage     *photoImg;
@property(nonatomic,copy)   NSString    *isUpdatePic;
@property(nonatomic,copy) NSString *groupSource;
@property(nonatomic,strong) NSMutableAttributedString *nameAttString;
@property(nonatomic,copy) NSString *backImageUrl;

-(instancetype)initWithRecommentListDictionary:(NSDictionary *)dic;
-(instancetype)initPersonCenterWithDictionary:(NSDictionary *)groupListDic;

@end
