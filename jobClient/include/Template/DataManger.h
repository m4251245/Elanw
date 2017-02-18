//
//  DataManger.h
//  Template
//
//  Created by sysweal on 13-9-18.
//  Copyright (c) 2013年 sysweal. All rights reserved.
//

/****************************
 
        数据管理类
 
 ****************************/

#import <Foundation/Foundation.h>
#import "Common.h"
#import "MyDataBase.h"

//数据缓存类型
typedef enum{
    Data_DB,
    Data_File,
}DataType;

@interface DataManger : NSObject{
    
}

//存放数据
+(void) saveData:(NSString *)key data:(NSData *)data type:(DataType)type;

//获取数据据(cacheSeconds 0:返回null <0:不会判断缓存时间 >0:根据缓存时间返回数据)
+(NSData *) getData:(NSString *)key cacheSeconds:(long)seconds type:(DataType)type;

@end
