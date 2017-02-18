//
//  JSONParser.h
//  SmartMarketClient
//
//  Created by sysweal on 13-3-26.
//  Copyright (c) 2013年 sysweal. All rights reserved.
//

/****************************
 
        JSON数据解析
 
 ****************************/

#import <Foundation/Foundation.h>
#import "Common.h"
#import "MyDes.h"

@class JSONParser;

@protocol ParserDelegate <NSObject>

-(void) parserFinish:(JSONParser *)parser code:(ErrorCode)code dataArr:(NSArray *)arr requestType:(int)type;

@end

@interface JSONParser : NSObject
{
    ErrorCode                   errorCode_;
    NSMutableArray              *dataArr_;
}

@property(nonatomic,assign) id<ParserDelegate>          delegate_;
@property(nonatomic,assign) BOOL                        bUploadFile_;


//开始解析
-(void) parserJSON:(NSData *)data strData:(NSString *)strData requestType:(int)type;

//解析数据(子类来重写)
-(void) parserDic:(NSDictionary *)dic requestType:(int)type;

@end
