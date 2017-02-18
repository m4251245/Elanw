//
//  Comment_DataModal.h
//  MBA
//
//  Created by sysweal on 13-11-20.
//  Copyright (c) 2013年 job1001. All rights reserved.
//

#import "PageInfo.h"
#import "Author_DataModal.h"

@interface Comment_DataModal : PageInfo


@property(nonatomic,strong) NSString        *id_;
@property(nonatomic,strong) NSString        *userId_;
@property(nonatomic,strong) NSString        *objectId_;
@property(nonatomic,strong) NSString        *datetime_;
@property(nonatomic,strong) NSString        *content_;
@property(nonatomic,strong) Comment_DataModal   *next_;
@property(nonatomic,assign) CGFloat           cellHeight_;
@property(nonatomic,strong) NSData          *imageData_;
@property(nonatomic,assign) BOOL            bImageLoad_;
@property(nonatomic,strong) NSString        *parentId;
@property(nonatomic,copy) NSString *parentContent;
@property(nonatomic,strong) Author_DataModal * author;//评论人信息
@property(nonatomic,strong) Author_DataModal * parentAuthor;//父评论人信息
@property(nonatomic,strong) Comment_DataModal   * parent_;
@property(nonatomic,strong) NSMutableArray  * childList_;
@property(nonatomic,strong) NSString        *userName_;
@property(nonatomic,strong) NSString        *imageUrl_;
@property(nonatomic,strong) NSString        *nickName_;
@property(nonatomic,strong) NSString        *objectTitle_;
@property(nonatomic,strong) NSString        *researchId;
@property(nonatomic,assign) BOOL            bRead_;
@property(nonatomic,assign) BOOL            isLiked;//是否点赞
@property(nonatomic,assign) NSInteger             agreeCount;//赞的数量
@property(nonatomic,assign) NSInteger             isLZ;//是否是楼主 1是 0否
@property(nonatomic,assign) NSInteger             floorNum;//楼层数
@property(nonatomic,strong) NSArray         *picList;//评论的图片
@property(nonatomic,assign) CGFloat           contentHeight;//楼层数
@property(nonatomic,copy) NSString *articleType;



//职导行家评价
@property(nonatomic,strong) NSString        *zpcId;
@property(nonatomic,strong) NSString        *zpcPersonId;
@property(nonatomic,strong) NSString        *zpcExpertId;
@property(nonatomic,strong) NSString        *zpcType;
@property(nonatomic,strong) NSString        *zpcTypeId;
@property(nonatomic,strong) NSString        *zpcStar;
@property(nonatomic,strong) NSString        *zpcTitle;
@property(nonatomic,strong) NSString        *zpcProductId;

@property(nonatomic,assign) CGFloat cellHeight;
@property(nonatomic,strong) NSMutableAttributedString *contentAttString;

-(instancetype)initWithDictionary:(NSDictionary *)dic;

@end
