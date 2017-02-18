//
//  CycleScrollView.m
//  CycleScrollView
//
//  Created by YL1001 on 16/8/26.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "CycleScrollView.h"
#import "CycleScrollViewCell.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"

#define kCycleScrollViewInitialPageControlDotSize CGSizeMake(10, 10)

NSString *const ID = @"cycleCell";

@interface CycleScrollView () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, weak) UICollectionView *collectionView; // 显示图片的collectionView
@property (nonatomic, weak) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSArray *imgPathsGroup;
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, assign) NSInteger totalItemsCount;
@property (nonatomic, weak) UIControl *pageControl;

@property (nonatomic, strong) UIImageView *backgroundImageView;

@end


@implementation CycleScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initialization];
        [self setupcollectionView];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initialization];
    [self setupcollectionView];
}

- (void)initialization
{
    _autoScrollTimeInterval = 10.0f;
    _titleLabelTextColor = [UIColor blackColor];
    _titleLabelTextFont = [UIFont systemFontOfSize:9];
    _titleLabelBackgroundColor = [UIColor clearColor];
    _titleLabelHeight = 30;
    
    _autoScroll = YES;
    _infiniteLoop = YES;
    _showPageControl = YES;
    
    _pageControlDotSize = kCycleScrollViewInitialPageControlDotSize;
    _pageControlBottomOffset = 0;
    _pageControlRightOffset = 0;
    _hidesForSinglePage = YES;
    _currentPageDotColor = [UIColor whiteColor];
    _pageDotColor = [UIColor lightGrayColor];
    _bannerImageViewContentMode = UIViewContentModeScaleToFill;
    
    self.backgroundColor = [UIColor lightGrayColor];
}

+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame imageNameGroup:(NSArray *)imageNameGroup
{
    CycleScrollView *cycleScrollView = [[self alloc] initWithFrame:frame];
    cycleScrollView.localizationImageNamesGroup = [NSMutableArray arrayWithArray:imageNameGroup];
    return cycleScrollView;
}

+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame shouldInfiniteLoop:(BOOL)infiniteLoop imageNameGroup:(NSArray *)imageNameGroup
{
    CycleScrollView *cycleScrollView = [[self alloc] initWithFrame:frame];
    cycleScrollView.infiniteLoop = YES;
    cycleScrollView.localizationImageNamesGroup = [NSMutableArray arrayWithArray:imageNameGroup];
    return cycleScrollView;
}

+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame imageURLStringsGroup:(NSArray *)imageURLsGroup
{
    CycleScrollView *cycleScrollView = [[self alloc] initWithFrame:frame];
    cycleScrollView.imageURLStringGroup = [NSMutableArray arrayWithArray:imageURLsGroup];
    return cycleScrollView;
}

+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame delegate:(id<CycleScrollViewDelegate>)delegate placeholderImage:(UIImage *)placeholderImage
{
    CycleScrollView *cycleScrollView = [[self alloc] initWithFrame:frame];
    cycleScrollView.delegate = delegate;
    cycleScrollView.placeholderImage = placeholderImage;
    
    return cycleScrollView;
}

- (void)setupcollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _flowLayout = flowLayout;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.pagingEnabled = YES;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    [collectionView registerClass:[CycleScrollViewCell class] forCellWithReuseIdentifier:ID];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.scrollsToTop = NO;
    [self addSubview:collectionView];
    
    _collectionView = collectionView;
}

#pragma mark - properties
- (void)setPlaceholderImage:(UIImage *)placeholderImage
{
    _placeholderImage = placeholderImage;
    
    if (!self.backgroundImageView) {
        UIImageView *bgImgView = [UIImageView new];
        bgImgView.contentMode = UIViewContentModeScaleToFill;
        [self insertSubview:bgImgView belowSubview:self.collectionView];
        self.backgroundImageView = bgImgView;
    }
    
    self.backgroundImageView.image = placeholderImage;
}

- (void)setPageControlDotSize:(CGSize)pageControlDotSize
{
    _pageControlDotSize = pageControlDotSize;
    [self setupPageControl];
}

- (void)setShowPageControl:(BOOL)showPageControl
{
    _showPageControl = showPageControl;
    _pageControl.hidden = !showPageControl;
}

- (void)setCurrentPageDotColor:(UIColor *)currentPageDotColor
{
    _currentPageDotColor = currentPageDotColor;
    UIPageControl *pageControl = (UIPageControl *)_pageControl;
    pageControl.currentPageIndicatorTintColor = currentPageDotColor;
}

- (void)setPageDotColor:(UIColor *)pageDotColor
{
    _pageDotColor = pageDotColor;
    if ([self.pageControl isKindOfClass:[UIPageControl class]]) {
        UIPageControl *pageControl = (UIPageControl *)_pageControl;
        pageControl.currentPageIndicatorTintColor = pageDotColor;
    }
}

- (void)setInfiniteLoop:(BOOL)infiniteLoop
{
    _infiniteLoop = infiniteLoop;
    if (self.imgPathsGroup.count) {
        self.imgPathsGroup = self.imgPathsGroup;
    }
}

- (void)setAutoScroll:(CGFloat)autoScroll
{
    _autoScroll = autoScroll;
    [self invalidateTimer];
    
    if (_autoScroll) {
        [self setupTimer];
    }
}

- (void)setAutoScrollTimeInterval:(CGFloat)autoScrollTimeInterval
{
    _autoScrollTimeInterval = autoScrollTimeInterval;
    [self setAutoScroll:self.autoScroll];
}

- (void)setPageControlStyle:(CycleScrollViewPageContolStyle)pageControlStyle
{
    _pageControlStyle = pageControlStyle;
    [self setupPageControl];
}

- (void)setImgPathsGroup:(NSArray *)imgPathsGroup
{
    [self invalidateTimer];
    
    _imgPathsGroup = imgPathsGroup;
    
    _totalItemsCount = self.infiniteLoop ? self.imgPathsGroup.count * 100 : self.imgPathsGroup.count;
    
    if (imgPathsGroup.count != 1) {
        self.collectionView.scrollEnabled = YES;
        [self setAutoScroll:self.autoScroll];
    }
    else {
        self.collectionView.scrollEnabled = NO;
    }
    
    [self setupPageControl];
    [self.collectionView reloadData];
}

- (void)setImageURLStringGroup:(NSArray *)imageURLStringGroup
{
    _imageURLStringGroup = imageURLStringGroup;
    
    NSMutableArray *temp = [NSMutableArray new];
    [_imageURLStringGroup enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *urlString;
        if ([obj isKindOfClass:[NSString class]]) {
            urlString = obj;
        }
        else if ([obj isKindOfClass:[NSURL class]]) {
            NSURL *url = (NSURL *)obj;
            urlString = [url absoluteString];
        }
        
        if (urlString) {
            [temp addObject:urlString];
        }
    }];
    
    self.imgPathsGroup = [temp copy];
}

- (void)setLocalizationImageNamesGroup:(NSArray *)localizationImageNamesGroup
{
    _localizationImageNamesGroup = localizationImageNamesGroup;
    self.imgPathsGroup = [localizationImageNamesGroup copy];
}

- (void)setTitlesGroup:(NSArray *)titlesGroup
{
    _titlesGroup = titlesGroup;
}

#pragma mark - actions
- (void)setupTimer
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)invalidateTimer
{
    [_timer invalidate];
    _timer = nil;
}

- (void)setupPageControl
{
    if (_pageControl) [_pageControl removeFromSuperview]; // 重新加载数据时调整
    
    if ((self.imgPathsGroup.count == 1) && self.hidesForSinglePage)
    {
        return;
    }
    
    int indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:[self currentIndex]];

    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = self.imgPathsGroup.count;
    pageControl.currentPageIndicatorTintColor = self.currentPageDotColor;
    pageControl.pageIndicatorTintColor = self.pageDotColor;
    pageControl.userInteractionEnabled = NO;
    pageControl.currentPage = indexOnPageControl;
    [self addSubview:pageControl];
    _pageControl = pageControl;
}

- (void)automaticScroll
{
    if (0 == _totalItemsCount) {
        return;
    }
    
    int currentIndex = [self currentIndex];
    int targetIndex = currentIndex + 1;
    [self scrollToIndex:targetIndex];
}

- (void)scrollToIndex:(int)targetIndex
{
    if (targetIndex >= _totalItemsCount) {
        if (self.infiniteLoop) {
            targetIndex = _totalItemsCount * 0.5;
            [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
        return;
    }
    
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

- (int)currentIndex
{
    if (_collectionView.frame.size.width == 0 || _collectionView.frame.size.height == 0) {
        return 0;
    }
    
    int index = 0;
    if (_flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        index = (_collectionView.contentOffset.x + _flowLayout.itemSize.width * 0.5) / _flowLayout.itemSize.width;
    } else {
        index = (_collectionView.contentOffset.y + _flowLayout.itemSize.height * 0.5) / _flowLayout.itemSize.height;
    }
    
    return MAX(0, index);
}

- (int)pageControlIndexWithCurrentCellIndex:(NSInteger)index
{
    return (int)index % self.imgPathsGroup.count;
}

- (void)clearCache
{
    [[self class] clearImagesCache];
}

+ (void)clearImagesCache
{
    [[[SDWebImageManager sharedManager] imageCache] clearDisk];
}

#pragma mark - life circles
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _flowLayout.itemSize = self.frame.size;
    
    _collectionView.frame = self.bounds;
    if (_collectionView.contentOffset.x == 0 && _totalItemsCount) {
        int targetIndex = 0;
        if (self.infiniteLoop) {
            targetIndex = _totalItemsCount * 0.5;
        }
        else
        {
            targetIndex = 0;
        }
        
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    
    CGSize size = CGSizeZero;
    size = CGSizeMake(self.imgPathsGroup.count * self.pageControlDotSize.width * 1.5, self.pageControlDotSize.height);
    
    CGFloat x = (self.frame.size.width - size.width) * 0.5;
    if (self.pageControlAliment == CycleScrollViewPageContolAlimentRight) {
        x = self.collectionView.frame.size.width - size.width - 10;
    }
    
    CGFloat y = self.collectionView.frame.size.height - size.height - 10;
    
    CGRect pageControlFrame = CGRectMake(x, y, size.width, size.height);
    pageControlFrame.origin.y -= self.pageControlBottomOffset;
    pageControlFrame.origin.x -= self.pageControlRightOffset;
    self.pageControl.frame = pageControlFrame;
    self.pageControl.hidden = !_showPageControl;
    
    if (self.backgroundImageView) {
        self.backgroundImageView.frame = self.bounds;
    }
}

//解决当父View释放时，当前视图因为被Timer强引用而不能释放的问题
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview) {
        [self invalidateTimer];
    }
}

//解决当timer释放后 回调scrollViewDidScroll时访问野指针导致崩溃
- (void)dealloc
{
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
}

#pragma mark - public actions
- (void)adjustWhenControlllerViewWillAppera
{
    long targetIndex = [self currentIndex];
    if (targetIndex < _totalItemsCount) {
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}

#pragma mark - UICollectinViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  _totalItemsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CycleScrollViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    long itemIndex = [self pageControlIndexWithCurrentCellIndex:indexPath.item];
    
    
    if (!cell.hasConfigured) {
        cell.titleLabelBackgroundColor = self.titleLabelBackgroundColor;
        cell.titleLabelHeight = self.titleLabelHeight;
        cell.hasConfigured = YES;
        cell.imgView.contentMode = self.bannerImageViewContentMode;
        cell.clipsToBounds = YES;
        
        if (_titleLabelStyle == CycleScrollViewCellTitleLabelRight) {
            cell.titleColor = self.titleLabelTextColor;
            cell.titleFont = self.titleLabelTextFont;
        }
        else {
            cell.titleColor = [UIColor whiteColor];
            cell.titleFont = [UIFont systemFontOfSize:15];
        }
    }
    
    NSString *imagePath = self.imgPathsGroup[itemIndex];
    if ([imagePath isKindOfClass:[NSString class]]) {
        if ([imagePath hasPrefix:@"http"] || [imagePath hasPrefix:@"https"]) {
            
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:self.placeholderImage];
        }
        else {
            UIImage *image = [UIImage imageNamed:imagePath];
            if (!image) {
                [UIImage imageWithContentsOfFile:imagePath];
            }
            cell.imgView.image = image;
        }
    }
    else if ([imagePath isKindOfClass:[UIImage class]]) {
        cell.imgView.image = (UIImage *)imagePath;
    }
    
    if (_titlesGroup.count < _imgPathsGroup.count) {
        if (itemIndex == _imgPathsGroup.count -1) {
            cell.titleLabel.hidden = YES;
        }
    }
    
    if (_titlesGroup.count && itemIndex < _titlesGroup.count) {
        NSString *string = _titlesGroup[itemIndex];
        NSMutableAttributedString *attString;
        if (_titleLabelStyle == CycleScrollViewCellTitleLabelRight) {
            attString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@  ",string]];
            [attString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(4,string.length-5)];
            [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(4,string.length-5)];
            cell.titleLabel.attributedText = attString;
        }
        else {
            cell.titleLabel.text = [NSString stringWithFormat:@"    %@", string];
        }
        
        [cell.titleLabel sizeToFit];
        
        CGFloat titleLabelH;
        CGFloat titleLabelW;
        CGFloat titleLabelX;
        CGFloat titleLabelY;
        if (_titleLabelStyle == CycleScrollViewCellTitleLabelRight) {
            titleLabelW = cell.titleLabel.frame.size.width + 5;
            titleLabelX = cell.imgView.frame.size.width - titleLabelW + 5;
            titleLabelY = 15;
            titleLabelH = 20;
            
            cell.titleLabel.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
        }
        else {
            titleLabelH = 30;
            titleLabelX = 0;
            titleLabelW = cell.imgView.frame.size.width;
            titleLabelY = cell.imgView.frame.size.height - titleLabelH;
            
            cell.titleLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        }
        
        cell.titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
        
        cell.titleLabel.layer.cornerRadius = 4.0f;
        cell.titleLabel.layer.masksToBounds = YES;
        cell.titleLabel.hidden = NO;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didSelectItemAtIndex:)]) {
        [self.delegate cycleScrollView:self didSelectItemAtIndex:[self pageControlIndexWithCurrentCellIndex:indexPath.item]];
    }
    
    if (self.clickItemOperationBlock) {
        self.clickItemOperationBlock([self pageControlIndexWithCurrentCellIndex:indexPath.item]);
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 解决清除timer时偶尔会出现的问题
    if (!self.imgPathsGroup.count) {
        return;
    }
    
    int itemIndex = [self currentIndex];
    int indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:itemIndex];
    
    UIPageControl *pageControl = (UIPageControl *)_pageControl;
    pageControl.currentPage = indexOnPageControl;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.autoScroll) {
        [self invalidateTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.autoScroll) {
        [self setupTimer];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:self.collectionView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 解决清除timer时偶尔会出现的问题
    if (!self.imgPathsGroup.count) {
        return;
    }
}

@end
