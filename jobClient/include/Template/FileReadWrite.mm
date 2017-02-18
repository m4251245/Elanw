////
////  FileReadWrite.m
////  Phone_Design
////
////  Created by wang yong on 4/18/11.
////  Copyright 2011 __MyCompanyName__. All rights reserved.
////
//
//#import "FileReadWrite.h"
//#import <Foundation/Foundation.h>
//#import "Common.h"
//
//bool checkFileExist(NSString *fileName)
//{
//    if( !fileName || fileName == nil )
//    {
//        return NO;
//    }
//    
//    BOOL bExist = YES;
//    
////    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
////	NSString *documentsDirectory = [paths objectAtIndex:0];
//
//    NSString *documentsDirectory = [Common getLocalStoreDir];
//    
//    if(!documentsDirectory)
//	{
//		bExist = NO;
//	}else
//    {
//        NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
//        
//        FILE *pFile;
//        pFile = fopen([appFile UTF8String], "r");
//        
//        if( pFile )
//        {
//            bExist = YES;
//            fclose(pFile);
//        }else
//            bExist = NO;
//    }
//    
//    return bExist;
//}
//
//bool writeData(NSData *_data, NSString *fileName)
//{
////	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
////	NSString *documentsDirectory = [paths objectAtIndex:0];
//
//    NSString *documentsDirectory = [Common getLocalStoreDir];
//    
//	if(!documentsDirectory)
//	{
//		return false;
//	}
//	
//	NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
//	
//	return [_data writeToFile:appFile atomically:YES];
//}
//
//bool writeDataByString(char *_data,NSString *fileName,bool _dataConterFlag)
//{
//	NSData *pData;
//
//	pData = (NSData*)_data;
//	
//	if(_dataConterFlag)
//	{
//		pData = [NSData dataWithBytes:_data length:strlen(_data)];
//		
//	}
//
//	return writeData((NSData*)pData,fileName);
//}
//
//char *readData(NSString *fileName,bool _dataConterFlag)
//{
////	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
////	NSString *documentsDirectory = [paths objectAtIndex:0];
//
//    NSString *documentsDirectory = [Common getLocalStoreDir];
//    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
//	
//	NSData *myData = [[[NSData alloc] initWithContentsOfFile:appFile] autorelease];
//	
//	if(_dataConterFlag && myData)
//	{
//		char *pData = (char *)[myData bytes];
//		int length = [myData length];
//		if(length == 0)
//			return nil;
//		
//		pData[length] = '\0';
//		return pData;
//	}
//	
//	return (char*)myData;
//}
//
//char *readDataByString(char *fileName,bool _dataConterFlag)
//{
//	return readData([NSString stringWithFormat:@"%s",fileName],_dataConterFlag);
//}
//
//
