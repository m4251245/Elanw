//
//  SearchHistory_DataModal.h
//  iPadJobClient
//
//  Created by job1001 job1001 on 11-12-15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

/********************************************
 历史搜索记录数据模块
 ********************************************/

#import <Foundation/Foundation.h>


@interface SearchHistory_DataModal : NSObject {
    NSString                        *searchNameStr_;                //搜索记录的名称
    NSString                        *searchResultStr_;              //搜索记录的结果
    
    NSString                        *searchURLStr_;                 //搜索时所用的url
    
    NSString                        *searchUpdateTime_;             //更新时间
    
    //地图搜索时需要保存的具体条件
    NSString                        *keywords_;
    NSString                        *keyType_;
    NSString                        *rangId_;
    NSString                        *rangStr_;
    NSString                        *majorId_;
    NSString                        *majorStr_;
    NSString                        *tradeId_;
    NSString                        *tradeStr_;
}

@property(nonatomic,retain) NSString                        *searchNameStr_;
@property(nonatomic,retain) NSString                        *searchResultStr_;
@property(nonatomic,retain) NSString                        *searchURLStr_;
@property(nonatomic,retain) NSString                        *searchUpdateTime_;
@property(nonatomic,retain) NSString                        *keywords_;
@property(nonatomic,retain) NSString                        *keyType_;
@property(nonatomic,retain) NSString                        *rangId_;
@property(nonatomic,retain) NSString                        *rangStr_;
@property(nonatomic,retain) NSString                        *majorId_;
@property(nonatomic,retain) NSString                        *majorStr_;
@property(nonatomic,retain) NSString                        *tradeId_;
@property(nonatomic,retain) NSString                        *tradeStr_;

@end
