//
//  FileReadWrite.h
//  Phone_Design
//
//  Created by wang yong on 4/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/****************************
 
        文件读写类
 
 ****************************/

bool writeDataByString(char *_data,NSString *fileName,bool _dataConterFlag = true);
char *readData(NSString *fileName,bool _dataConterFlag);
char *readDataByString(char *fileName,bool _dataConterFlag = true);
bool writeData(NSData *_data, NSString *fileName);
bool checkFileExist(NSString *fileName);
