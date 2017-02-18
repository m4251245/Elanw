//
//  Logo_DataModal.h
//  CampusClient
//
//  Created by job1001 job1001 on 13-2-28.
//
//

#import "PageInfo.h"

@interface Logo_DataModal : PageInfo
{
    NSString                    *id_;
    NSString                    *modelKey_;     //模块key
    NSString                    *url_;          //链接地址
    NSString                    *name_;         //名称
    NSString                    *path_;         //路径
    
    NSData                      *imageData_;    //图像数据
}

@property(nonatomic,retain) NSString                    *id_;
@property(nonatomic,retain) NSString                    *modelKey_;
@property(nonatomic,retain) NSString                    *url_;
@property(nonatomic,retain) NSString                    *name_;
@property(nonatomic,retain) NSString                    *path_;
@property(nonatomic,retain) NSData                      *imageData_;
@property(nonatomic,strong) UIImage                     *photoImage;

@end
