//
//  School_DataModal.h
//  CampusClient
//
//  Created by job1001 job1001 on 13-3-5.
//
//

#import "PageInfo.h"

@interface School_DataModal : PageInfo
{
    NSString                *id_;
    NSString                *beAttentionId_;        //被关注时的主键id
    NSString                *regionId_;
    NSString                *name_;
    NSString                *logoPath_;
    NSString                *empWeb_;
    
    float                   lat_;
    float                   lng_;
    
    BOOL                    bAttention_;            //是否已经添加关注
    
    NSData                  *imageData_;
    
    BOOL                    bSelect_;
}

@property(nonatomic,retain) NSString                *id_;
@property(nonatomic,retain) NSString                *beAttentionId_;
@property(nonatomic,retain) NSString                *regionId_;
@property(nonatomic,retain) NSString                *name_;
@property(nonatomic,retain) NSString                *logoPath_;
@property(nonatomic,retain) NSString                *empWeb_;
@property(nonatomic,assign) float                   lat_;
@property(nonatomic,assign) float                   lng_;
@property(nonatomic,assign) BOOL                    bAttention_;
@property(nonatomic,retain) NSData                  *imageData_;
@property(nonatomic,assign) BOOL                    bSelect_;
@property(nonatomic,strong) NSString                *schoolNews_;
@property(nonatomic,assign) BOOL                     canEdit_;
@end
