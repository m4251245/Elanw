//
//  JSONParser.m
//  SmartMarketClient
//
//  Created by sysweal on 13-3-26.
//  Copyright (c) 2013年 sysweal. All rights reserved.
//

#import "JSONParser.h"

@implementation JSONParser

@synthesize delegate_,bUploadFile_;

-(id) init
{
    self = [super init];
    
    dataArr_ = [[NSMutableArray alloc] init];
    
    return self;
}

//初始化状态
-(void) initStat
{
    errorCode_ = Success;
    [dataArr_ removeAllObjects];
}

//开始解析
-(void) parserJSON:(NSData *)data strData:(NSString *)strData requestType:(int)type
{
    //回到初始状态
    [self initStat];
 
    @try {
        //如果是图片资源
        if( type <= 0 ){
            [self parserDic:(NSDictionary *)data requestType:type];
        }else{
            if (type == 1 ||type == 2 ) {
                bUploadFile_ = YES;
            }
            NSDictionary*  dicData = [self getDataDic:data strData:strData];
            
            if( dicData ){
                [self parserDic:dicData requestType:type];
            }
        }
    }
    @catch (NSException *exception) {
        errorCode_ = Parser_Error;
    }
    @finally {
        [MyLog Log:[NSString stringWithFormat:@"parserFinish code=%d size=%lu",errorCode_,(unsigned long)[dataArr_ count]] obj:self];
        @try {
            if ([delegate_ respondsToSelector:@selector(parserFinish:code:dataArr:requestType:)]) {
                [delegate_ parserFinish:self code:errorCode_ dataArr:dataArr_ requestType:type];
            }
        }
        @catch (NSException *exception) {
            
        }
        
        //再次回到初始状态
        [self initStat];
    }
}

//获取字典数据
-(NSDictionary* ) getDataDic:(NSData *)data strData:(NSString *)strData{
    NSDictionary* dic = NULL;
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString * str = [[NSString alloc] initWithData:data encoding:enc];
    if (!bUploadFile_) {
        data = [MyDes dataWithBase64EncodedString:str];
        data = [MyDes decrypt:data];
        str = [[NSString alloc] initWithData:data encoding:enc];
    }
    
    @try {
       
        NSError* error = nil;
        if (data) {
            dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        }
        
    }
    @catch (NSException *exception) {
        errorCode_ = Parser_Error;
        
        if (!str) {
            str = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        }
        NSMutableDictionary * strDic = [[NSMutableDictionary alloc] init];
        [strDic setObject:str forKey:@"result"];
        dic = strDic;

    }
    @finally {
        if(!dic || dic == NULL ){
            //errorCode_ = Parser_Error;
            if (!str) {
                str = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            }
            NSMutableDictionary * strDic = [[NSMutableDictionary alloc] init];
            [strDic setObject:str forKey:@"result"];
            dic = strDic;

        }
    }

    
    
    return dic;
}

//解析数据
-(void) parserDic:(NSDictionary *)dic  requestType:(int)type
{
    
}

@end
