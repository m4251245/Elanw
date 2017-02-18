//
//  ELMacro.h
//  jobClient
//
//  Created by 一览ios on 16/4/1.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#ifndef ELMacro_h
#define ELMacro_h

typedef NS_ENUM(NSInteger,ENTRANCE)//入口
{
    DEFAULT,
    POSITION,//通过职位跳转进来
};

//RGB转UIColor（不带alpha值）
#define UIColorFromRGB(rgbValue) [UIColor  colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0  green:((float)((rgbValue & 0xFF00) >> 8))/255.0  blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define Color(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define  Color1         [UIColor colorWithRed:68.0/255.0 green:154.0/255.0 blue:201.0/255.0 alpha:1.0]
#define  Color2         [UIColor colorWithRed:240.0/255.0 green:77.0/255.0 blue:72.0/255.0 alpha:1.0]
#define  Color3         [UIColor colorWithRed:65.0/255.0 green:48.0/255.0 blue:86.0/255.0 alpha:1.0]
#define  Color4         [UIColor colorWithRed:68.0/255.0 green:154.0/255.0 blue:201.0/255.0 alpha:1.0]
#define  Color5         [UIColor colorWithRed:240.0/255.0 green:77.0/255.0 blue:72.0/255.0 alpha:1.0]
#define  Color6         [UIColor colorWithRed:65.0/255.0 green:48.0/255.0 blue:86.0/255.0 alpha:1.0]
#define  WhiteColor     [UIColor whiteColor]

//获取屏幕宽度和高度
#define ScreenWidth               [UIScreen mainScreen].bounds.size.width
#define ScreenHeight              [UIScreen mainScreen].bounds.size.height
#define NavBarHeight                    64
#define ToolBarHeight                   49
#define ScreenWidth_Four           ScreenWidth/4

#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)]?CGSizeEqualToSize(CGSizeMake(1024*2,768*2),[[UIScreen mainScreen] currentMode].size):NO)


#define WS(weakSelf)              __weak __typeof(self)weakSelf = self;
#define SS(strongSelf)            __block __typeof(self)strongSelf = self;


#define ChooseResume_Null_DefaultValue          @"请选择"
#define WriteResume_Null_DefaultValue          @"请填写"
#define GPS_Place_Loading                       @"     正在获取您的当前位置..."

#pragma mark - 输出
#if DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"\nfunction:%s line:%d content:%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

#else
#define NSLog(FORMAT, ...) nil
#endif

//分页参数
#define pageParams  @"20"

//#define ELOAHttps         @"crm1001https.job1001.com"
//#define ELHttps_M         @"m.job1001.com"


#endif /* ELMacro_h */
