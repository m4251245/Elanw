//
//  PreStatus_DataModal.h
//  HelpMe
//
//  Created by wang yong on 11/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

/***************************
 
 DataModal=>Status DataModal
 
 ***************************/

#import <Foundation/Foundation.h>


@interface PreStatus_DataModal : NSObject {

}

@property(nonatomic,retain) NSString		*msg_;
@property(nonatomic,retain) NSString		*code_;
@property(nonatomic,retain) NSString		*status_;
@property(nonatomic,retain) NSString		*id_;
@property(nonatomic,retain) NSString        *preId_;
@property(nonatomic,retain) NSString        *detail_;
@property(nonatomic,assign) BOOL            bHaveNewMsg_;

@end
