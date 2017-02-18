//
//  FaceContentUtil.m
//  jobClient
//
//  Created by 一览ios on 15/1/21.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "FaceContentUtil.h"
#import "NSString+Size.h"

//#define BEGIN_FLAG @"["
//#define END_FLAG @"]"
#define FACE_FONT [UIFont fontWithName:@"STHeitiSC-Medium" size:12]

NSString *BEGIN_FLAG = @"[";
NSString *END_FLAG = @"]";

@implementation FaceContentUtil

#define KFacialSizeWidth  18
#define KFacialSizeHeight 18
#define KFacialPaddingLeft 2


+ (UIView *)assembleMessageView : (NSString *)message width:(CGFloat)width
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [FaceContentUtil getImageRange:message :array];
    UIView *returnView = [[UIView alloc] initWithFrame:CGRectZero];
    NSArray *data = array;
    UIFont *fon = FACE_FONT;
    CGFloat upX = 0;
    CGFloat upY = 0;
    CGFloat X = 0;
    CGFloat Y = 0;
    if (data) {
        for (int i=0;i < [data count];i++) {
            NSString *str=[data objectAtIndex:i];
            if ([str hasPrefix: BEGIN_FLAG] && [str hasSuffix: END_FLAG])
            {
                if (upX >= width)
                {
                    upY = upY + KFacialSizeHeight;
                    upX = 0;
                    X = width;//最大的宽度150
                    Y = upY;
                }
//                NSString *imageName=[str substringWithRange:NSMakeRange(2, str.length - 3)];
                NSString *imageName;
                NSString *filePath = [[NSBundle mainBundle] pathForResource:@"emoticons" ofType:@"plist"];
                NSArray *fileArray = [NSArray arrayWithContentsOfFile:filePath];
                for (NSDictionary *dict in fileArray) {
                    if ([dict[@"chs"] isEqualToString:str]) {
                        imageName = dict[@"png"];
                        break;
                    }
                }
                UIImageView *img=[[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
                upX = upX + KFacialPaddingLeft;
                img.frame = CGRectMake(upX, upY, KFacialSizeWidth, KFacialSizeHeight);
                [returnView addSubview:img];
                upX=KFacialSizeWidth+upX;
                if (X<width) X = upX;
                
                
            } else {
                for (int j = 0; j < [str length]; j++) {
                    NSString *temp = [str substringWithRange:NSMakeRange(j, 1)];//一个字一个字的切割
                    CGSize size=[temp sizeNewWithFont:fon constrainedToSize:CGSizeMake(width, 40)];
                    CGFloat tempX = upX+size.width;
                    if (tempX >= width)
                    {
                        upY = upY + KFacialSizeHeight;
                        upX = 0;
                        X = width;
                        Y =upY;
                    }
                    
                    UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(upX,upY,size.width,size.height)];
                    la.font = fon;
                    la.text = temp;
                    la.backgroundColor = [UIColor clearColor];
                    [returnView addSubview:la];
                    upX=upX+size.width;
                    if (X<width) {
                        X = upX;
                    }
                }
            }
        }
        Y += KFacialSizeHeight;
    }
    returnView.frame = CGRectMake(15.0f,1.0f, X, Y); //@ 需要将该view的尺寸记下，方便以后使用
    NSLog(@"%.1f %.1f", X, Y);
    return returnView;
}


//图文混排
+ (void)getImageRange:(NSString*)message : (NSMutableArray*)array {
    NSRange range=[message rangeOfString: BEGIN_FLAG];
    NSRange range1=[message rangeOfString: END_FLAG];
    if (range.length>0 && range1.length>0) {
        if (range.location > 0) {
            [array addObject:[message substringToIndex:range.location]];
            [array addObject:[message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)]];
            NSString *str=[message substringFromIndex:range1.location+1];
            [self getImageRange:str :array];
        }else {
            NSString *nextstr=[message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)];
            //排除文字是“”的
            if (![nextstr isEqualToString:@""]) {
                [array addObject:nextstr];
                NSString *str=[message substringFromIndex:range1.location+1];
                [self getImageRange:str :array];
            }else {
                return;
            }
        }
        
    } else if (message != nil) {
        [array addObject:message];
    }
}



@end
