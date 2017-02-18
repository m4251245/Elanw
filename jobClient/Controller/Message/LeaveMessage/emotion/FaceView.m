//
// 
//  jobClient
//
//  Created by 一览ios on 14/12/8.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//  表情

#import "FaceView.h"

//#define item_width  30
//#define item_height 45
//#define RowNum 3
//#define ColumnNum 7
//#define MarginPadding 10
//#define PageNum RowNum*ColumnNum

static int item_width = 30;
static int item_height = 45;
static int RowNum = 3;
static int ColumnNum = 7;
static int MarginPadding = 10;
static int PageNum = 21;
//中间的间隙
#define Padding ([UIScreen mainScreen].bounds.size.width- item_width*ColumnNum - MarginPadding*2)/(ColumnNum-1)


@implementation FaceView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        self.pageNumber = items.count;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


- (void)initData {
    items = [[NSMutableArray alloc] init];
    
    //整理表情成2维数组
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"emoticons" ofType:@"plist"];
    NSArray *fileArray = [NSArray arrayWithContentsOfFile:filePath];
    
    NSMutableArray *items2D = nil;
    for (int i = 0; i<fileArray.count; i++) {
        NSDictionary *item = [fileArray objectAtIndex:i];
        if (i % (PageNum) == 0) {
            items2D = [NSMutableArray arrayWithCapacity:PageNum];
            [items addObject:items2D];
        }
        [items2D addObject:item];
    }
    
    //设置尺寸
    self.width = items.count * [UIScreen mainScreen].bounds.size.width;
    self.height = RowNum * item_height;
    
}


//绘制表情
- (void)drawRect:(CGRect)rect
{
    //定义列 行
    int row = 0 , colum = 0;
    for (int i = 0; i<items.count; i++) {
        NSArray *items2D = [items objectAtIndex:i];
        
        for (int j = 0; j<items2D.count; j++) {
            NSDictionary *item = [items2D objectAtIndex:j];
            NSString *imageString = [item objectForKey:@"png"];
            UIImage *image= [UIImage imageNamed:imageString];
            
            CGFloat pad =  Padding;//中间的间隙
            CGRect frame = CGRectMake(MarginPadding +(item_width+pad) * colum, item_height*row + 15, 30, 30);
            
            //考虑页数,需要加上前几页的宽度
            float x = (i * [UIScreen mainScreen].bounds.size.width) + frame.origin.x;
            frame.origin.x = x;
            [image drawInRect:frame];
            
            //更新列 行
            colum++;
            if (colum % ColumnNum == 0) {
                row++;
                colum = 0;
            }
            if (row == RowNum) {
                row = 0;
            }
        }
    }
}

- (void)touchFace:(CGPoint)point {
    //页数
    int page = point.x / [UIScreen mainScreen].bounds.size.width;
    
    float x = point.x - (page*[UIScreen mainScreen].bounds.size.width) - MarginPadding;
    float y = point.y - 10;
    
    int colum = (x-item_width-MarginPadding) / (Padding + item_width) +1;
    int row = y / item_height;
    
    if (colum > 6) {
        colum = 6;
    }
    if (colum < 0) {
        colum = 0;
    }
    
    if (row > 3) {
        row = 3;
    }
    if (row < 0) {
        row = 0;
    }
    
    int index = colum + row*ColumnNum;
    NSArray *items2D = [items objectAtIndex:page];
    @try {
        if (index>items2D.count -1) {
            self.selectedFaceName = @"";
            return;
        }
        NSDictionary *item = [items2D objectAtIndex:index];
        NSString *itemName = [item objectForKey:@"chs"];
        if (![self.selectedFaceName isEqualToString:itemName] || self.selectedFaceName == nil) {
            self.selectedFaceName = itemName;
        }
    }
    @catch (NSException *exception) {
        
    } @finally {
        
    }
}

//touch事件
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch  locationInView:self];
    [self touchFace:point];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch  locationInView:self];
    [self touchFace:point];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (self.block != nil) {
        _block(self.selectedFaceName);
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
   
    
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        scrollView.scrollEnabled = YES;
    }
}

- (void)setFrame:(CGRect)frame
{
    frame = CGRectMake(frame.origin.x, frame.origin.y, self.width, self.height);
    [super setFrame:frame];
}

@end
