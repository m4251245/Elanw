//
//  ShareManger.h
//  jobClient
//
//  Created by 一览ios on 15-1-6.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyConfig.h"
#import <UMSocialCore/UMSocialCore.h>

typedef enum{
    ShareDefault = 1, //@[@"微信好友",@"朋友圈",@"QQ",@"QQ空间",@"微博",@"复制链接"]
    ShareTypeOne, //@"微信好友",@"QQ",@"微博",@"一览好友",@"复制链接"
    ShareTypeTwo, //@[@"微信好友",@"朋友圈",@"QQ",@"QQ空间",@"微博",@"一览朋友圈",@"复制链接"]
    ShareTypeThree, //@[@"微信好友",@"朋友圈",@"QQ",@"QQ空间",@"微博",@"一览好友",@"复制链接"]
    ShareTypeFour, //@[@"微信好友",@"QQ",@"邮件",@"微博",@"一览好友",@"复制链接"]
}ShareType;

@protocol ELShareManagerDelegate <NSObject>

@optional
-(void)shareYlBtn; //一览朋友圈
-(void)shareYLFriendBtn;//一览好友
-(void)copyChaining;//复制链接
-(void)emailShare;//邮件

@end

@interface ShareManger : NSObject

@property (weak,nonatomic) id <ELShareManagerDelegate> shareDelegare;

+ (ShareManger *)sharedManager;

//默认的分享
- (void)shareWithCtl:(UIViewController *)ctl title:(NSString *)title content:(NSString *)content image:(UIImage *)image url:(NSString *)url;

/*
//分享内容以图片为主的分享
- (void)shareWithCtl:(UIViewController *)ctl title:(NSString *)title image:(UIImage *)image;
*/
 
//不同样式的弹框分享
- (void)shareWithCtl:(UIViewController *)ctl title:(NSString *)title content:(NSString *)content image:(UIImage *)image url:(NSString *)url shareType:(ShareType)shareType;

//直接分享
- (void)shareSingleWithType:(NSString *)type ctl:(UIViewController *)ctl title:(NSString *)title content:(NSString *)content image:(UIImage *)image url:(NSString *)url;


@end
