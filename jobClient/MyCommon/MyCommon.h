//
//  MyCommon.h
//  MBA
//
//  Created by sysweal on 13-11-14.
//  Copyright (c) 2013年 job1001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyConfig.h"
#import "BaseUIViewController.h"
#import "AttributedLabel.h"
#import "Reachability.h"
#import "UIImageView+WebCache.h"

//CSS样式标签
#define Content_CSS_HTML                            @"<link rel=\"Stylesheet\" type=\"text/css\" href=\"web_content.css\" />"

@interface MyCommon : NSObject


//获取当前时间
+(NSString*)getNowTime;


//处理时间(eg:2013-10-1)
+(NSString *) getShortTime:(NSString *)timeStr;

//处理时间(eg:10-1)
+(NSString *) getMidTime:(NSString *)timeStr;

//获取NSDate
+(NSDate *) getDate:(NSString *)timeStr;

//毫秒级时间戳转换成时间
+(NSString *) getDateWithMsecTime:(NSString *)timeStr;

//获取时间Str
+(NSString *) getDateStr:(NSDate *)date format:(NSString *)format;

//给某视图添加点击事件
+(UITapGestureRecognizer *) addTapGesture:(UIView *)view target:(id)target numberOfTap:(int)cnt sel:(SEL)sel;

//移除某视图的点击事件
+(void) removeTapGesture:(UIView *)view ges:(UITapGestureRecognizer *)ges;

//从文件反序列化出数据
+(id) unArchiverFromFile:(NSString *)fileName;

//转换HTML实体
+(NSString *)translateHTML:(NSString*)html;

//将HTML标签去掉
+(NSString *)filterHTML:(NSString *)html;

//去掉双重\n
+(NSString *) filterDoubleWrapLine:(NSString *)str;

+(NSString*)removeStyleHtml:(NSString*)html;

+ (NSString *)removeHTML2:(NSString *)html;
//URL解码
+(NSString *)decodeFromPercentEscapeString: (NSString *) input;

//判断正确的邮箱格式
+(BOOL)isValidateEmail:(NSString *)email;

//判断正确的手机格式
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

//转换html实体
+(NSString *) convertHTML:(NSString *)html;

//处理上传内容中的特殊符号
+(NSString*)convertContent:(NSString *)str;

//过滤换行和空格
+(NSString*)removeWarpLine:(NSString *)str;

//转换html样式
+(NSMutableString*)convertHtmlStyle:(NSString*)str;

//获取tokenstr
+(NSString *) getTokenStr;

//将tokenStr已经收到
+(void) haveGetToken:(NSString *)tokenStr;

//获取设备唯一标识
+(NSString*)getUUID;

//拼接图片路径
+(NSString*)convertImagePath:(NSString*)imgpath;

//获取某个位置的字符串，可正序查询，也可反序查询
+(NSString *)getNSString:(NSString *)_string atIndex:(NSInteger)_index  type:(BOOL)type ;

//获取字符串中某个字符串的位置
+(NSInteger)IndexOfContainingString:(NSString *)findment FromString:(NSString *)scrString type:(BOOL)type;

//获取星期
+(NSString *) getWeekDay:(NSString *)dateStr;

//由星期获取颜色
+(UIColor *) getWeekDayColor:(NSString *)week;

//获取后台运行的状态
+(NSString*)getEnterBackgroundStatus;

//设置后台运行的状态
+(void)setEnterBackgroundStatus:(NSString*)status;


//时间戳转换成时间
+(NSString*)getDateStrFromTimestamp:(NSString*)timestamp;

/**
 * 计算指定时间与当前的时间差
 * @param compareDate   某一指定时间
 * @return 多少(秒or分or天or月or年)+前 (比如，3天前、10分钟前)
 */
+(NSString *) compareCurrentTime:(NSDate*) compareDate;

/**
 * 计算指定时间与当前的时间差
 * @param compareDate   某一指定时间
 * @return 多少(小时or天)+前 (比如，3天前、1小时前)
 */
+(NSString *) CompareCurrentTimeByTheEndOfDay:(NSDate*) compareDate;

//包含特殊字符
+(BOOL)checkSpacialCharacter:(NSString *)str inString:(NSString*)myString;

//获取多少天之前的时间字符串
+(NSString*)getdateStrBeforeSomeDay:(int)days;

//判断以1开头的十一位字符串
+(BOOL)isMobile:(NSString*)mobileNum;

//获取版本是否显示欢迎页
+(NSString *)getVersionShowLogo:(NSString*)aversion;

//设置每个版本的显示欢迎页面
+(void)setVersion:(NSString*)aVersion showLogo:(NSString*)value;


//获取某个页面是否显示功能引导
+(NSString*)getShowModalForView:(NSString*)view;

//设置某个页面是否显示功能引导
+(void)setShowModalForView:(NSString*)view status:(NSString*)status;

//去除内容首部的空格
+(NSString*)removeSpaceAtHead:(NSString*)content;

//去除内容所有的空格、回车、换行
+(NSString *)removeAllSpace:(NSString *)content;

//去除两边空格
+(NSString *)removeSpaceAtSides:(NSString *)content;

+(NSString *) utf8ToUnicode:(NSString *)string;

//判断字符串中是否包含emoji表情
+(BOOL)stringContainsEmoji:(NSString *)string;

// 去HTML 标签
+ (NSString *)removeHtmlTags:(NSString *)htmlString;

+(NSString *)MyfilterHTML:(NSString *)html;

+(NSString *)MyfilterHTMLExceptBr:(NSString *)html;

//查看数据库中是否存在此条职位
+(BOOL) checkMessageIsExistInDB:(NSString *)messageId  userId:(NSString*)userId;

//截取最后的表情字符串
+ (NSString *)substringExceptLastEmoji:(NSString *)emojiStr;

+(NSString *) compareCurrentTimePrestige:(NSDate*) compareDate currentString:(NSString *)prestigeDate;

//快速排序
+(NSMutableArray*)quickSort:(NSMutableArray *)arr left:(int)left right:(int)right;

//为nil时设置成空字符串
+(NSString*)getEmtyStrFromNil:(NSString*)str;

// 是否wifi
+ (BOOL) IsEnableWIFI ;

// 是否3G
+ (BOOL) IsEnable3G;

+ (NSString *)getTimeWithString:(NSString *)timeStr;

- (NSString*)getLianMengImage:(NSString*)str;

//随机生成两个数之间的随机数
+(int)getRandomNumber:(int)from to:(int)to;

//计算谁赞了我的时间戳
+(NSString *)getWhoLikeMeListCurrentTime:(NSDate *)date currentTimeString:(NSString *)str;

//swf格式链接转换图片
+(NSString *)getWithFileSwf:(NSString *)fileswf;

//删除手机中不是数字的字符
+(NSString *)removePhoneNumberSpaceString:(NSString *)str;

//删除字符串中的表情字符
+(NSString *)removeEmojiString:(NSString *)str;

//判断字符串中包含表情字符
+(BOOL)isContactEmojiString:(NSString *)string;

+(NSString *)getAddressBookUUID;

//用户id分享加密
+(NSString *)getRandString:(NSString *)personId;

//计算图片的相对大小
+(CGSize)creatHeightWidthSize:(CGSize)size andSize:(CGSize)sizeOne;

+(NSMutableAttributedString *)changeColorString:(NSString *)string changeString:(NSString *)changeString;

//浮点数判断
+(BOOL)isPureFloat:(NSString*)string;
+(BOOL)isPureNumber:(NSString *)string;

//UITextView字数限制处理
+(void)dealLabNumWithTipLb:(UILabel *)TipLb numLb:(UILabel *)numLb textView:(UITextView *)textView wordsNum:(NSInteger)wordsNum;

//UITextField字数限制处理
+(void)limitTextFieldTextNumberWithTextField:(UITextField *)textField wordsNum:(NSInteger)wordsNum numLb:(UILabel *)numLb;
+(void)dealTxtFiled:(UITextField *)textField maxLength:(NSInteger)maxNum;

//通过view获取到对应的控制器
+ (UIViewController *)viewController:(id)view;

//删除html中的img标签
+(NSString *)removeHtmlImg:(NSString *)str;

+(void)saveKeyUUID:(NSString *)uuid;
+(NSString *)getKeyUUID;

@end
