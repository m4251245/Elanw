//
//  ELCommentModel.h
//  jobClient
//
//  Created by 一览ios on 16/6/6.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "PageInfo.h"


@interface ELCommentModel : PageInfo

@property(nonatomic, copy) NSString *user_id;//用户id
@property(nonatomic, copy) NSString *id_;
@property(nonatomic, copy) NSString *content;//内容
@property(nonatomic, copy) NSString *_pic;
@property(nonatomic, copy) NSString *client_id;
@property(nonatomic, copy) NSString *parent_id;
@property(nonatomic, assign) NSInteger _floor_num;//楼层数
@property(nonatomic, assign) NSInteger _is_lz;//楼主
@property(nonatomic, assign) NSInteger agree;
@property(nonatomic, strong) ELCommentModel *parent_;

@property (nonatomic,assign) BOOL isLike;

- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end

//@interface ELParentCommentModel : PageInfo
//@property(nonatomic, assign) NSInteger _floor_num;//层数
//@property(nonatomic, copy) NSString *content;
//@end
