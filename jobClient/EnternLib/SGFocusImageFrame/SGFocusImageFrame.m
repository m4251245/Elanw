//
//  SGFocusImageFrame.m
//  SGFocusImageFrame
//
//  Created by Shane Gao on 17/6/12.
//  Copyright (c) 2012 Shane Gao. All rights reserved.
//

#import "SGFocusImageFrame.h"
#import <objc/runtime.h>

static const void *SG_FOCUS_ITEM_ASS_KEY = &SG_FOCUS_ITEM_ASS_KEY;

#define HEIGHT_OF_PAGE_CONTROL 20.f

#pragma mark - SGFocusImageItem Definition
@implementation SGFocusImageItem
- (id)initWithTitle:(NSString *)title image:(UIImage *)image tag:(NSInteger)tag
{
    self = [super init];
    if (self) {
        self.title = title;
        self.image = image;
        self.tag = tag;
    }
    return self;
}

- (id)initWithTitle:(NSString *)title imageUrl:(NSString *)url tag:(NSInteger)tag
{
    self = [super init];
    if (self) {
        self.title = title;
        self.url = url;
        self.tag = tag;
    }
    return self;
}

+ (id)itemWithTitle:(NSString *)title image:(UIImage *)image tag:(NSInteger)tag
{
    return [[SGFocusImageItem alloc] initWithTitle:title image:image tag:tag];
}

@end

#pragma mark - SGFocusImageFrame Definition

@interface SGFocusImageFrame ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@end

@implementation SGFocusImageFrame

- (void)dealloc
{
    objc_setAssociatedObject(self, SG_FOCUS_ITEM_ASS_KEY, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)initWithFrame:(CGRect)frame delegate:(id<SGFocusImageFrameDelegate>)delegate focusImageItemsArrray:(NSArray *)items
{
    self = [super initWithFrame:frame];
    if (self) {
        objc_setAssociatedObject(self, SG_FOCUS_ITEM_ASS_KEY, items, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        self.delegate = delegate;
        [self initImageFrame];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame delegate:(id<SGFocusImageFrameDelegate>)delegate focusImageItems:(SGFocusImageItem *)firstItem, ...
{
    self = [super initWithFrame:frame];
    if (self) {
        NSMutableArray *imageItems = [NSMutableArray array];  
        SGFocusImageItem *eachItem;
        va_list argumentList;
        if (firstItem) {
            [imageItems addObject: firstItem];
            va_start(argumentList, firstItem);       
            while((eachItem = va_arg(argumentList, SGFocusImageItem *))) {
                [imageItems addObject: eachItem];            
            }
            va_end(argumentList);
        }
        objc_setAssociatedObject(self, SG_FOCUS_ITEM_ASS_KEY, imageItems, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        self.delegate = delegate;
        [self initImageFrame];
    }
    return self;
}

- (void)initImageFrame
{
    [self initParameters];
    [self setupViews];
}

#pragma mark - private methods

- (void)initParameters
{
    self.switchTimeInterval = 10.f;
    self.autoScrolling = YES;
}

- (void)setupViews
{
    CGFloat mainWidth = self.frame.size.width, mainHeight = self.frame.size.height;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.f, 0.f, mainWidth, mainHeight)];
    
    CGSize size = CGSizeMake(mainWidth, HEIGHT_OF_PAGE_CONTROL);
    CGRect pcFrame = CGRectMake(mainWidth *.5 - size.width *.5, mainHeight - size.height, size.width, size.height);
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:pcFrame];
    [pageControl addTarget:self action:@selector(pageControlTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:scrollView];
    [self addSubview:pageControl];
    
    scrollView.delegate = self;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.directionalLockEnabled = YES;
    scrollView.alwaysBounceHorizontal = YES;
    
    pageControl.currentPage = 0;
    
    // single tap gesture recognizer
    UITapGestureRecognizer *tapGestureRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureRecognizer:)];
    tapGestureRecognize.delegate = self;
    [scrollView addGestureRecognizer:tapGestureRecognize];
    
    NSArray *imageItems = objc_getAssociatedObject(self, SG_FOCUS_ITEM_ASS_KEY);
    if (imageItems.count == 1) {
        pageControl.hidden = YES;
    }
    else
    {
        pageControl.numberOfPages = imageItems.count;
    }
    
    CGSize scrollViewSize = scrollView.frame.size;
    
    for (int i = 0; i < imageItems.count; i++) {
        SGFocusImageItem *item = [imageItems objectAtIndex:i];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * scrollViewSize.width, 0.f, scrollViewSize.width, scrollViewSize.height)];
        if (item.image) {
            imageView.image = item.image;
        }
        else if(item.url)
        {
            [imageView sd_setImageWithURL:[NSURL URLWithString:item.url] placeholderImage:[UIImage imageNamed:@"ad_default.png"]];
        }
        imageView.contentMode = UIViewContentModeScaleToFill;
        [scrollView addSubview:imageView];
        
        if (item.articleCount.length > 0)
        {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(imageView.frame.origin.x+[UIScreen mainScreen].bounds.size.width-110,15,110,20)];
            view.backgroundColor = [UIColor clearColor];
            view.clipsToBounds = YES;
            
            UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0,0,130,20)];
            view1.backgroundColor = [UIColor whiteColor];
            view1.alpha = 0.8;
            view1.clipsToBounds = YES;
            view1.layer.cornerRadius = 3.0;
            [view addSubview:view1];
            
            UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(0,1,110,15)];
            lable1.font = [UIFont systemFontOfSize:9];
            lable1.textColor = [UIColor blackColor];
            lable1.textAlignment = NSTextAlignmentCenter;
            [view addSubview:lable1];
            
            NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:item.articleCount];
            [attString addAttribute:NSForegroundColorAttributeName value:FONEREDCOLOR range:NSMakeRange(2,item.articleCount.length-5)];
            [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(2,item.articleCount.length-5)];
            
            CGSize size = attString.size;
            lable1.attributedText = attString;
            
            view.frame = CGRectMake(imageView.frame.origin.x+[UIScreen mainScreen].bounds.size.width-size.width-2,15,size.width+2,20);
            lable1.frame = CGRectMake(0,1,size.width+2,15);
            view1.frame = CGRectMake(0,0,size.width+30,20);
            [scrollView addSubview:view];
        }
    }
    
    scrollView.contentSize = CGSizeMake(scrollViewSize.width * imageItems.count, mainHeight);
    self.scrollView = scrollView;
    self.pageControl = pageControl;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - Actions

- (void)pageControlTapped:(id)sender
{
    UIPageControl *pc = (UIPageControl *)sender;
    [self moveToTargetPage:pc.currentPage];
}

- (void)singleTapGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    int targetPage = (int)(self.scrollView.contentOffset.x / self.scrollView.frame.size.width);
    NSArray *imageItems = objc_getAssociatedObject(self, SG_FOCUS_ITEM_ASS_KEY);
    if (targetPage > -1 && targetPage < imageItems.count) {
        SGFocusImageItem *item = [imageItems objectAtIndex:targetPage];
        //delegate 
        if (_delegate && [_delegate respondsToSelector:@selector(foucusImageFrame:didSelectItem:)]) {
            [_delegate foucusImageFrame:self didSelectItem:item];
        }
        
        //block
        if (_didSelectItemBlock) {
            _didSelectItemBlock(item);
        }
    }
}

#pragma mark - ScrollView MOve
- (void)moveToTargetPage:(NSInteger)targetPage
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(switchFocusImageItems) object:nil];
    CGFloat targetX = targetPage * self.scrollView.frame.size.width;
    [self moveToTargetPosition:targetX];
    [self performSelector:@selector(switchFocusImageItems) withObject:nil afterDelay:self.switchTimeInterval];
}

- (void)switchFocusImageItems
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(switchFocusImageItems) object:nil];
    
    CGFloat targetX = self.scrollView.contentOffset.x + self.scrollView.frame.size.width;
    [self moveToTargetPosition:targetX];
    
    if (self.autoScrolling) {
        [self performSelector:@selector(switchFocusImageItems) withObject:nil afterDelay:self.switchTimeInterval];
    }
}

- (void)moveToTargetPosition:(CGFloat)targetX
{
    //NSLog(@"moveToTargetPosition : %f" , targetX);
    if (targetX >= self.scrollView.contentSize.width) {
        targetX = 0.0;
    }
    
    [self.scrollView setContentOffset:CGPointMake(targetX, 0) animated:YES] ;
    self.pageControl.currentPage = (int)(self.scrollView.contentOffset.x / self.scrollView.frame.size.width);
}

- (void)setAutoScrolling:(BOOL)enable
{
    _autoScrolling = enable;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(switchFocusImageItems) object:nil];
    if (_autoScrolling) {
         [self performSelector:@selector(switchFocusImageItems) withObject:nil afterDelay:self.switchTimeInterval];
    }
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = (int)(scrollView.contentOffset.x / scrollView.frame.size.width);
}

@end
