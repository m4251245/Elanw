//
//  TabView.h
//  MBA
//
//  Created by sysweal on 13-12-7.
//  Copyright (c) 2013年 job1001. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    Tab_First,
    Tab_Second,
    Tab_Third,
    Tab_Fourth,
    Tab_Fifth,
}TabType;

@class TabView;
@protocol TabViewDelegate <NSObject>

-(void) tabViewModalChanged:(TabView *)tab type:(TabType)type;

@end

@interface TabView : UIView
{
    UIButton *selectBtn;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthOne;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthTwo;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthThree;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthFour;

@property(nonatomic,weak)   IBOutlet    UILabel           *lbGroupModular;  //社群有新消息到达的标记
@property(nonatomic,weak)   IBOutlet    UILabel           *lbMessageModular; //消息模块红点数量
@property(nonatomic,weak)   IBOutlet    UILabel           *lbMineModular;   //我的管理中心模块红点数量

@property(nonatomic,weak)   IBOutlet    UIImageView *firstImg_;
@property(nonatomic,weak)   IBOutlet    UIImageView *secondImg_;
@property(nonatomic,weak)   IBOutlet    UIImageView *thirdImg_;
@property(nonatomic,weak)   IBOutlet    UIImageView *fourthImg_;
@property(nonatomic,weak)   IBOutlet    UIImageView *fifthImg_;

@property(nonatomic,weak)   IBOutlet    UILabel     *firstLb_;
@property(nonatomic,weak)   IBOutlet    UILabel     *secondLb_;
@property(nonatomic,weak)   IBOutlet    UILabel     *thirdLb_;
@property(nonatomic,weak)   IBOutlet    UILabel     *fourthLb_;
@property(nonatomic,weak)   IBOutlet    UILabel     *fifthLb_;

@property(nonatomic,weak)   IBOutlet    UIButton    *firstBtn_;
@property(nonatomic,weak)   IBOutlet    UIButton    *secondBtn_;
@property(nonatomic,weak)   IBOutlet    UIButton    *thirdBtn_;
@property(nonatomic,weak)   IBOutlet    UIButton    *fourthBtn_;
@property(nonatomic,weak)   IBOutlet    UIButton    *fifthBtn_;
@property(nonatomic,assign) TabType     type_;
@property(nonatomic,assign) id          delegate_;
@property (weak, nonatomic) IBOutlet UILabel *sameTradeMessageLb;

@property(nonatomic,assign) NSInteger changeBtnType;

//改变模块
-(void) changeModel:(TabType)type;
//设置消息
-(void)setTabBarNewMessage;
-(IBAction) btnClick:(id)sender;

- (void)addGesture;
@end
