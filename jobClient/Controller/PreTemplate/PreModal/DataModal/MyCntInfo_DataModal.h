//
//  MyCntInfo_DataModal.h
//  CampusClient
//
//  Created by job1001 job1001 on 13-3-14.
//
//

//数量信息

#import <Foundation/Foundation.h>

@interface MyCntInfo_DataModal : NSObject
{
    int                 xjhCnt_;
    int                 zphCnt_;
    int                 msgCnt_;
    int                 newMsgCnt_;
}

@property(nonatomic,assign) int                 xjhCnt_;
@property(nonatomic,assign) int                 zphCnt_;
@property(nonatomic,assign) int                 msgCnt_;
@property(nonatomic,assign) int                 newMsgCnt_;

@end
