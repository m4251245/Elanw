//
//  MyDes.h
//  Template
//
//  Created by YL1001 on 14/12/9.
//  Copyright (c) 2014年 sysweal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "desuntil.h"

@interface MyDes : NSObject

+ (NSMutableDictionary*)filterPost:(NSString*)postParams httpPath:(NSString*)path;
+ (NSString *)encodeToPercentEscapeString: (NSString *) input;
+ (NSString *)decodeFromPercentEscapeString: (NSString *) input;
+ (NSMutableDictionary*)getOverPost:(NSString*)get post:(NSString*)p;
+ (NSData*) encryptByte:(NSString*)data;
+ (NSData*)decrypt:(NSData*)data;
+ (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key;
+ (NSData *)DESDecrypt:(NSData *)data WithKey:(NSString *)key;
+ (NSData *)dataWithBase64EncodedString:(NSString *)string;
+ (NSString *)base64EncodedStringFrom:(NSData *)data;
+ (NSString*)dealpost:(NSMutableDictionary*)postParams;
+ (NSMutableDictionary*)convertPath:(NSString*)path;


@end
