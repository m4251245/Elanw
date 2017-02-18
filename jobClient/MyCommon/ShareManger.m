//
//  ShareManger.m
//  jobClient
//
//  Created by 一览ios on 15-1-6.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ShareManger.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "BaseUIViewController.h"
#import "shareHeaderView.h"

#define distance    21
#define imageWidth  (ScreenWidth-distance*5)/4

@interface ShareManger () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSString *btnType;
    NSString *titleName;
    UIViewController *controller;
    NSString *contentName;
    UIImage *titleImage;
    NSString *titleUrl;
    
    NSInteger shareTypeOne; //标识分享的类型，10为默认，20为已图片为主的分享
    CGFloat shareViewheight;
    
    UICollectionView *_colloctionView;
    NSMutableArray *dataArr;
    NSMutableArray *saveDataArr;
    UIView *shareView;
}

@property (nonatomic,strong) UIView *shareBackView;
@property (nonatomic,assign) ShareType lastShareType;

@end

@implementation ShareManger

+ (ShareManger *)sharedManager
{
    static ShareManger *shareManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareManagerInstance = [[self alloc] init];
    });
    return shareManagerInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _lastShareType = ShareDefault;
        [self creatView];
    }
    return self;
}

#pragma mark - 创建UI及生成数据
-(void)creatView
{
    dataArr = [[NSMutableArray alloc] init];
    
    //    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    //    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    //    flowLayout.headerReferenceSize = CGSizeZero;
    //    flowLayout.footerReferenceSize = CGSizeZero;
    //    _colloctionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,ScreenWidth) collectionViewLayout:flowLayout];
    //    _colloctionView.delegate = self;
    //    _colloctionView.dataSource = self;
    //    _colloctionView.backgroundColor = [UIColor whiteColor];
    //    _colloctionView.bounces = NO;
    //    _colloctionView.scrollEnabled = NO;
    //    [_colloctionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"colloctionCell"];
    //
    //    [_colloctionView registerClass:[shareHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    shareView = [[UIView alloc] init];
    shareView.backgroundColor = [UIColor whiteColor];
    
    _shareBackView = [[UIView alloc] init];
    _shareBackView.alpha = 0.0f;
    _shareBackView.backgroundColor = [UIColor blackColor];
    
    shareHeaderView *headerView = [[shareHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 35)];
    [shareView addSubview:headerView];
    
    UITapGestureRecognizer *tapBack = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    _shareBackView.tag = 100;
    _shareBackView.userInteractionEnabled = YES;
    [_shareBackView addGestureRecognizer:tapBack];
    NSDictionary *wechatDic = @{@"name":@"微信好友",@"image":@"ios_fenxiang_logo_weixin.png",@"type":[NSString stringWithFormat:@"%ld",(long)UMSocialPlatformType_WechatSession]};
    NSDictionary *wechatTimeDic = @{@"name":@"朋友圈",@"image":@"ios_fenxiang_logo_pengyouquan.png",@"type":[NSString stringWithFormat:@"%ld",(long)UMSocialPlatformType_WechatTimeLine]};
    NSDictionary *qqDic = @{@"name":@"QQ",@"image":@"ios_fenxiang_logo_QQ.png",@"type":[NSString stringWithFormat:@"%ld",(long)UMSocialPlatformType_QQ]};
    NSDictionary *qqzoneDic = @{@"name":@"QQ空间",@"image":@"ios_fenxiang_logo_zone.png",@"type":[NSString stringWithFormat:@"%ld",(long)UMSocialPlatformType_Qzone]};
    NSDictionary *sinaDic = @{@"name":@"微博",@"image":@"sina_logo.png",@"type":[NSString stringWithFormat:@"%ld",(long)UMSocialPlatformType_Sina]};
    NSDictionary *copyDic = @{@"name":@"复制链接",@"image":@"copy_logo.png",@"type":@"copy"};
    NSDictionary *ylFriendDic = @{@"name":@"一览好友",@"image":@"ios_fenxiang_logo_yilan.png",@"type":@"ylfriend"};
    NSDictionary *ylFriendCricleDic = @{@"name":@"一览朋友圈",@"image":@"ios_fenxiang_logo_yilan.png",@"type":@"ylfriendcricle"};
    NSDictionary *emailDic = @{@"name":@"邮件",@"image":@"email_logo.png",@"type":@"email"};
    
    
    NSArray *arrDefault = @[wechatDic,wechatTimeDic,qqDic,qqzoneDic,sinaDic,copyDic];
    NSArray *arrOne = @[wechatDic,qqDic,sinaDic,ylFriendDic,copyDic];
    NSArray *arrTwo = @[wechatDic,wechatTimeDic,qqDic,qqzoneDic,sinaDic,ylFriendCricleDic,copyDic];
    NSArray *arrThree = @[wechatDic,wechatTimeDic,qqDic,qqzoneDic,sinaDic,ylFriendDic,copyDic];
    NSArray *arrFour = @[wechatDic,qqDic,emailDic,sinaDic,ylFriendDic,copyDic];
    saveDataArr = [[NSMutableArray alloc] initWithObjects:arrDefault,arrOne,arrTwo,arrThree,arrFour,nil];
    
    [self changeDataWithType:ShareDefault];
    [self configUI];
}

- (void)shareSingleWithctl:(UIViewController *)ctl title:(NSString *)title content:(NSString *)content image:(UIImage *)image url:(NSString *)url shareType:(ShareType)shareType
{
    if (shareType < 1) {
        return;
    }
    [self changeDataWithType:shareType];
    controller = ctl;
    titleName = title;
    contentName = content;
    titleImage = image;
    titleUrl = url;
    if (shareType != _lastShareType) {
        [self configUI];
    }
    _lastShareType = shareType;
    [self showView];
}

-(void)changeDataWithType:(ShareType)type{
    NSArray *arr = saveDataArr[type-1];
    dataArr = [[NSMutableArray alloc] initWithArray:arr];
    
    BOOL qqisHave =  [QQApiInterface isQQInstalled];
    BOOL wxisHave = [WXApi isWXAppInstalled];
    
    for (NSInteger i = arr.count-1;i>=0;i--) {
        NSDictionary *dic = arr[i];
        NSString *name = dic[@"name"];
        if (!qqisHave){
            if ([name isEqualToString:@"QQ"] || [name isEqualToString:@"QQ空间"]) {
                [dataArr removeObjectAtIndex:i];
            }
        }
        if (!wxisHave) {
            if ([name isEqualToString:@"微信好友"] || [name isEqualToString:@"朋友圈"]) {
                [dataArr removeObjectAtIndex:i];
            }
        }
    }
    CGFloat height = 80;
    if (dataArr.count%4 > 0) {
        height = (imageWidth+5+12)*((dataArr.count/4)+1)+35+15+16+12;
    }else{
        height = (imageWidth+5+12)*(dataArr.count/4)+35+15+16;
    }
    shareViewheight = height;
    shareView.frame = CGRectMake(0,0,ScreenWidth,height);
    //    shareView.contentSize = CGSizeMake(ScreenWidth,height);
    //    [shareView reloadData];
}

-(void)hideView{
    CGPoint point = shareView.center;
    point.y += shareView.bounds.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        _shareBackView.alpha = 0.0f;
        shareView.center = point;
    } completion:^(BOOL finished) {
        _shareBackView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width,0,_shareBackView.bounds.size.width,_shareBackView.bounds.size.height);
        shareView.hidden = YES;
    }];
}

- (void)configUI
{
    [shareView removeFromSuperview];
    shareView = nil;
    shareView = [[UIView alloc] init];
    shareView.backgroundColor = [UIColor whiteColor];
    
    shareHeaderView *headerView = [[shareHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 35)];
    [shareView addSubview:headerView];
    
    [dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        double originY = (idx > 3)?(79+imageWidth):50;
        btn.frame = CGRectMake(imageWidth*(idx%4)+distance*(idx%4+1), originY, imageWidth, imageWidth);
        NSDictionary *dic = dataArr[idx];
        [btn setImage:[UIImage imageNamed:dic[@"image"]] forState:UIControlStateNormal];
        btn.tag = idx;
        [btn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
        [shareView addSubview:btn];
        
        UILabel *label = [[UILabel alloc] init];
        label.center = CGPointMake(btn.center.x, btn.bottom+11);
        label.bounds = CGRectMake(0, 0, 100, 12);
        label.text = dic[@"name"];
        label.textColor = UIColorFromRGB(0x666666);
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        [shareView addSubview:label];
    }];

}

-(void)showView{
    
//    [_shareBackView removeFromSuperview];

//    [shareView removeFromSuperview];
    
    [[UIApplication sharedApplication].keyWindow addSubview:_shareBackView];
    [[UIApplication sharedApplication].keyWindow addSubview:shareView];
    
    shareView.hidden = NO;
    _shareBackView.frame = [UIScreen mainScreen].bounds;
    shareView.frame = CGRectMake(0,ScreenHeight,ScreenWidth,shareViewheight);
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:_shareBackView];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:shareView];
    
    CGPoint point = shareView.center;
    point.y -= shareViewheight;
    [UIView animateWithDuration:0.3 animations:^{
        _shareBackView.alpha = 0.5f;
        shareView.center = point;
    }];
}

-(void)tap:(UITapGestureRecognizer *)tap
{
    [self hideView];
}

- (void)shareClick:(UIButton *)btn
{
    NSDictionary *dic = dataArr[btn.tag];
    NSString *type = dic[@"type"];
    if ([type isEqualToString:@"copy"]){
        if ([_shareDelegare respondsToSelector:@selector(copyChaining)]) {
            [_shareDelegare copyChaining];
        }else{
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            NSString * url = titleUrl;
            pasteboard.string = url;
            if(url.length > 0)
            {
                [BaseUIViewController showAutoDismissSucessView:nil msg:@"复制链接成功" seconds:1.0];
            }
        }
    }else if ([type isEqualToString:@"email"]){
        if ([_shareDelegare respondsToSelector:@selector(emailShare)]) {
            [_shareDelegare emailShare];
        }
    }else if ([type isEqualToString:@"ylfriend"]){
        if ([_shareDelegare respondsToSelector:@selector(shareYLFriendBtn)]) {
            [_shareDelegare shareYLFriendBtn];
        }
    }else if ([type isEqualToString:@"ylfriendcricle"]){
        if ([_shareDelegare respondsToSelector:@selector(shareYlBtn)]) {
            [_shareDelegare shareYlBtn];
        }
    }else{
        if (shareTypeOne == 20) {
            [self shareTwoWithType:dic[@"type"] Ctl:controller title:titleName image:titleImage];
        }
        else if(shareTypeOne == 10)
        {
            [self shareSingleWithType:dic[@"type"] ctl:controller title:titleName content:contentName image:titleImage url:titleUrl];
        }
    }
    [self hideView];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([dataArr count]!=0) {
        return  [dataArr count];
    }
    return 0;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(ScreenWidth_Four, ScreenWidth_Four);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    shareHeaderView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
    
    return reusableView;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(ScreenWidth, 35);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"colloctionCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellName forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    UIImageView *image = [cell.contentView viewWithTag:1000];
    UILabel *lable = [cell.contentView viewWithTag:2000];
    if (!image) {
        image = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth_Four-imageWidth)/2,(ScreenWidth_Four-imageWidth-20)/2,imageWidth,imageWidth)];
        image.tag = 1000;
        lable = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth_Four-60)/2,CGRectGetMaxY(image.frame)+3,60,21)];
        //        lable.center = CGPointMake(image.center.x, image.bottom+3);
        //        lable.bounds = CGRectMake(0, 0, ScreenWidth_Four, 15);
        lable.tag = 2000;
        lable.font = [UIFont systemFontOfSize:12];
        lable.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:image];
        [cell.contentView addSubview:lable];
    }
    NSDictionary *dic = dataArr[indexPath.row];
    image.image = [UIImage imageNamed:dic[@"image"]];
    lable.text = dic[@"name"];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = dataArr[indexPath.row];
    NSString *type = dic[@"type"];
    if ([type isEqualToString:@"copy"]){
        if ([_shareDelegare respondsToSelector:@selector(copyChaining)]) {
            [_shareDelegare copyChaining];
        }else{
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            NSString * url = titleUrl;
            pasteboard.string = url;
            if(url.length > 0)
            {
                [BaseUIViewController showAutoDismissSucessView:nil msg:@"复制链接成功" seconds:1.0];
            }
        }
    }else if ([type isEqualToString:@"email"]){
        if ([_shareDelegare respondsToSelector:@selector(emailShare)]) {
            [_shareDelegare emailShare];
        }
    }else if ([type isEqualToString:@"ylfriend"]){
        if ([_shareDelegare respondsToSelector:@selector(shareYLFriendBtn)]) {
            [_shareDelegare shareYLFriendBtn];
        }
    }else if ([type isEqualToString:@"ylfriendcricle"]){
        if ([_shareDelegare respondsToSelector:@selector(shareYlBtn)]) {
            [_shareDelegare shareYlBtn];
        }
    }else{
        if (shareTypeOne == 20) {
            [self shareTwoWithType:dic[@"type"] Ctl:controller title:titleName image:titleImage];
        }
        else if(shareTypeOne == 10)
        {
            [self shareSingleWithType:dic[@"type"] ctl:controller title:titleName content:contentName image:titleImage url:titleUrl];
        }
    }
    [self hideView];
}
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - shareUM
//其他分享
- (void)shareWithCtl:(UIViewController *)ctl title:(NSString *)title content:(NSString *)content image:(UIImage *)image url:(NSString *)url shareType:(ShareType)shareType{
    if ([url isEqualToString:@""] || url == nil) {
        return;
    }
    shareTypeOne = 10;
    [self shareSingleWithctl:ctl title:title content:content image:image url:url shareType:shareType];
}

//默认的分享
- (void)shareWithCtl:(UIViewController *)ctl title:(NSString *)title content:(NSString *)content image:(UIImage *)image url:(NSString *)url
{
    if ([url isEqualToString:@""] || url == nil) {
        return;
    }
    url = [NSString httpToHttps:url];
    shareTypeOne = 10;
    [self shareSingleWithctl:ctl title:title content:content image:image url:url shareType:ShareDefault];
}

//分享内容以图片为主的分享
- (void)shareWithCtl:(UIViewController *)ctl title:(NSString *)title image:(UIImage *)image
{
    shareTypeOne = 20;
    [self shareSingleWithctl:ctl title:title content:@"" image:image url:@"" shareType:ShareDefault];
}

/**
 *  直接分享
 *
 *  @param type      分享类型,例如(UMShareToWechatTimeline,UMShareToQQ,UMShareToWechatSession等)
 *  @param ctl         调用分享的ViewController
 *  @param title       分享标题
 *  @param content 分享内容
 *  @param image   分享插图
 *  @param url         点击链接的Url
 */
- (void)shareSingleWithType:(NSString *)type ctl:(UIViewController *)ctl title:(NSString *)title content:(NSString *)content image:(UIImage *)image url:(NSString *)url
{
    if ([url isEqualToString:@""] || url == nil) {
        return;
    }
    if (image == nil) {
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"1024" ofType:@"png"];
        image = [UIImage imageWithContentsOfFile:imagePath];
    }

    // 分享数据对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    
    
    if ([Manager shareMgr].haveLogin)
    {
        NSString *str = @"?";
        if ([url containsString:str]) {
            str = @"&";
        }
        url = [url stringByAppendingString:[NSString stringWithFormat:@"%@shcd=%@",str,[MyCommon getRandString:[Manager getUserInfo].userId_]]];
    }
    
  
    //设置新浪微博分享内容
    if ([type integerValue] == UMSocialPlatformType_Sina && (url.length + content.length) >= 140) {
        NSString *encodedValue = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil,(CFStringRef)url, nil,                                                                                     (CFStringRef)@"!*'();:@&=+$,/ %#[]", kCFStringEncodingUTF8));
        [ELRequest getMsgWithUrl:[NSString stringWithFormat:@"http://api.t.sina.com.cn/short_url/shorten.json?source=1855347614&url_long=%@",encodedValue] parameters:nil success:^(NSURLSessionDataTask *operation, id result) {
            NSArray *arr = result;
            if ([arr isKindOfClass:[NSArray class]]) {
                if (arr.count > 0) {
                    NSDictionary *dic = arr[0];
                    NSString *shortUrl = dic[@"url_short"];
                    NSString *shareContent = [content stringByAppendingString:shortUrl];
                    if (shareContent.length >= 140) {
                        shareContent = [[content substringWithRange:NSMakeRange(0,140-shortUrl.length)] stringByAppendingString:shortUrl];
                    }
                    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:shareContent thumImage:image];
                    // [shareObject setShareImage:image];
                    shareObject.webpageUrl = shortUrl;
                    messageObject.shareObject = shareObject;
                    [[UMSocialManager defaultManager] shareToPlatform:[type integerValue] messageObject:messageObject currentViewController:nil completion:^(id result, NSError *error) {
                        
                    }];
                }
            }
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            
        }];
        return;
    }else{
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:content thumImage:image];
        // [shareObject setShareImage:image];
        shareObject.webpageUrl = url;
        messageObject.shareObject = shareObject;
        [[UMSocialManager defaultManager] shareToPlatform:[type integerValue] messageObject:messageObject currentViewController:nil completion:^(id result, NSError *error) {
            
        }];    
    }
}

- (void)shareTwoWithType:(NSString *)type Ctl:(UIViewController *)ctl title:(NSString *)title image:(UIImage *)image
{
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    [shareObject setShareImage:image];
    messageObject.shareObject = shareObject;
    [[UMSocialManager defaultManager] shareToPlatform:[type integerValue] messageObject:messageObject currentViewController:nil completion:^(id result, NSError *error) {
        
    }];   
}

/*
 - (void)shareTwoTextWithType:(NSString *)type Ctl:(UIViewController *)ctl title:(NSString *)title content:(NSString *)content image:(UIImage *)image url:(NSString *)url
 {
 if (image == nil) {
 NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"1024" ofType:@"png"];
 image = [UIImage imageWithContentsOfFile:imagePath];
 }
 //调用友盟快速分享接口---------------------
 
 [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
 [UMSocialData defaultData].extConfig.qqData.shareImage = nil;
 [UMSocialData defaultData].extConfig.qzoneData.shareImage = nil;
 [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeNone;
 [UMSocialData defaultData].extConfig.yxsessionData.yxMessageType = UMSocialYXMessageTypeNone;
 
 //设置QQ跳转URL
 [UMSocialData defaultData].extConfig.qqData.url = url;
 //设置QQ空间跳转URL
 [UMSocialData defaultData].extConfig.qzoneData.url = url;
 //设置微信朋友圈跳转URL
 [UMSocialData defaultData].extConfig.wechatSessionData.url = url;
 //设置微信好友跳转URL
 [UMSocialData defaultData].extConfig.wechatTimelineData.url = url;
 //设置新浪微博分享内容
 [UMSocialData defaultData].extConfig.sinaData.shareText = [content stringByAppendingString:url];
 //设置腾讯微博分享内容
 [UMSocialData defaultData].extConfig.tencentData.shareText = [content stringByAppendingString:url];
 //设置title
 [UMSocialData defaultData].extConfig.title = title;
 [[UMSocialControllerService defaultControllerService] setShareText:content shareImage:image socialUIDelegate:self];        //设置分享内容和回调对象
 [UMSocialSnsPlatformManager getSocialPlatformWithName:type].snsClickHandler(ctl,[UMSocialControllerService defaultControllerService],YES);
 }
 */

@end
