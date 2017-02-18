//
//  NoDataErrorCtl.h
//  HelpMe
//
//  Created by wang yong on 11/26/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

/***************************
 
 No Data Error Class
 
 ***************************/

#import <UIKit/UIKit.h>

#define NoDataErrorCtl_Xib_Name			@"NoDataErrorCtl"

@class NoDataErrorCtl;
@protocol NoDataErrorDelegate

-(void) reloadData:(NoDataErrorCtl *)ctl sender:(id)sender;

@end


@interface NoDataErrorCtl : UIViewController {
	IBOutlet	UIButton				*clickBtn_;
	IBOutlet	UIImageView				*imageView_;
	IBOutlet	UILabel					*textLb_;
	
}

@property(nonatomic,retain) UIButton					*clickBtn_;
@property(nonatomic,retain) UIImageView					*imageView_;
@property(nonatomic,retain) UILabel						*textLb_;
@property(nonatomic,assign) id<NoDataErrorDelegate>		delegate_;

-(IBAction) buttonClick:(id)sender;

@end
