//
//  ShowImageView.m
//  jobClient
//
//  Created by 一览ios on 15-1-23.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ShowImageView.h"
#import "MJPhoto.h"
#import "SDWebImageOperation.h"
#import "UIButton+WebCache.h"
#import "UIButton+WebCache.h"

#define inWidth 5
#define InHeight 5

@implementation ShowImageView


- (instancetype)init
{
    self = [super init];
    if (self) {
        //[self setBackgroundColor:[UIColor redColor]];
    }
    return self;
}

- (void)returnShowImageSizeWith:(NSArray *)imageArray
{
    imageArray_ = [imageArray mutableCopy];
    switch ([imageArray_ count]) {
        case 1:
        {
//            __weak typeof(UIButton) *weakImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
//            __block CGSize tempSize = CGSizeMake(76, 76);
//            [weakImageButton sd_setImageWithURL:[NSURL URLWithString:[imageArray_ objectAtIndex:0]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"bg__xinwen3.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                if (image == nil) {
//                    image = [UIImage imageNamed:@"bg__xinwen3.png"];
//                }
//                tempSize.width = image.size.width/image.size.height * 76;
//            }];
            [self setFrame:CGRectMake(0, 0, 76+inWidth*2, 76 + 2*InHeight)];
        }
            break;
        case 2:
        {
            [self setFrame:CGRectMake(0, 0, 76*[imageArray_ count]+inWidth*3, 76+InHeight*2)];
        }
            break;
        case 3:
        {
            [self setFrame:CGRectMake(0, 0, 76*[imageArray_ count]+inWidth*4, 76 +InHeight*2)];
        }
            break;
        case 4:
        {
            [self setFrame:CGRectMake(0, 0, 76*[imageArray_ count]/2+inWidth*3, 76*2+InHeight*3)];
        }
            break;
        case 5:
        case 6:
        {
            [self setFrame:CGRectMake(0, 0, 76*3+inWidth*4, 76*2+InHeight *3)];
        }
            break;
        case 7:
        {
            [self setFrame:CGRectMake(0, 0, 76*[imageArray_ count]/3+inWidth*4, 76*3+InHeight*4)];
        }
            break;
        case 8:
        case 9:
        {
            [self setFrame:CGRectMake(0, 0, 76*3+inWidth*4, 76*3+InHeight *4)];
        }
            break;
        default:
            break;
    }
    
}

- (void)returnShowImageViewWith:(NSArray *)imageArray
{
    imageArray_ = [imageArray mutableCopy];
   
    switch ([imageArray_ count]) {
        case 1:
        {
            UIButton *tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            __weak typeof(UIButton) *weakImageButton = tempBtn;
            __block CGSize tempSize = CGSizeMake(76, 76);
            [weakImageButton sd_setImageWithURL:[NSURL URLWithString:[imageArray_ objectAtIndex:0]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"bg__xinwen3.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (image == nil) {
                    [[SDWebImageManager sharedManager].imageDownloader downloadImageWithURL:imageURL options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                        
                    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                        if (finished) {
                            if (image == nil) {
                                [weakImageButton setImage:[UIImage imageNamed:@"bg__xinwen3.png"] forState:UIControlStateNormal];
                            }else{
                                [weakImageButton setImage:image forState:UIControlStateNormal];
                            }
                        }
                    }];
                }
                
                if (image == nil) {
                    image = [UIImage imageNamed:@"bg__xinwen3.png"];
                }
                tempSize.width = image.size.width/image.size.height*76;
                [weakImageButton setFrame:CGRectMake(inWidth, InHeight, tempSize.width, tempSize.height)];
                [weakImageButton setImage:image forState:UIControlStateNormal];
            }];
            weakImageButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
            [weakImageButton addTarget:self action:@selector(imageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [weakImageButton setTag:1000];
            [self addSubview:weakImageButton];
            [self setFrame:CGRectMake(0, 0, tempSize.width+inWidth*2, 76 + 2*InHeight)];
        }
            break;
        case 2:
        {
            for (NSInteger i=0; i<[imageArray_ count]; i++) {
                UIButton *weakImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [weakImageButton sd_setImageWithURL:[NSURL URLWithString:[imageArray_ objectAtIndex:i]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"bg__xinwen3.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (image == nil) {
                        [[SDWebImageManager sharedManager].imageDownloader downloadImageWithURL:imageURL options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                            
                        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                            if (finished) {
                                if (image == nil) {
                                    [weakImageButton setImage:[UIImage imageNamed:@"bg__xinwen3.png"] forState:UIControlStateNormal];
                                }else{
                                    [weakImageButton setImage:image forState:UIControlStateNormal];
                                }
                                
                            }
                        }];
                    }
                }];
                [weakImageButton addTarget:self action:@selector(imageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                [weakImageButton setFrame:CGRectMake(inWidth+(76+inWidth)*i, InHeight, 76, 76)];
                [weakImageButton setTag:1000+i];
                weakImageButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
                [self addSubview:weakImageButton];
            }
            [self setFrame:CGRectMake(0, 0, 76*[imageArray_ count]+inWidth*3, 76+InHeight*2)];
        }
            break;
        case 3:
        {
            for (NSInteger i=0; i<[imageArray_ count]; i++) {
                UIButton *weakImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [weakImageButton sd_setImageWithURL:[NSURL URLWithString:[imageArray_ objectAtIndex:i]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"bg__xinwen3.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (image == nil) {
                        [[SDWebImageManager sharedManager].imageDownloader downloadImageWithURL:imageURL options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                            
                        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                            if (finished) {
                                if (image == nil) {
                                    [weakImageButton setImage:[UIImage imageNamed:@"bg__xinwen3.png"] forState:UIControlStateNormal];
                                }else{
                                    [weakImageButton setImage:image forState:UIControlStateNormal];
                                }
                                
                            }
                        }];
                    }
                }];
                [weakImageButton addTarget:self action:@selector(imageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                [weakImageButton setFrame:CGRectMake(inWidth+(76+inWidth)*i, InHeight, 76, 76)];
                [weakImageButton setTag:1000+i];
                weakImageButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
                [self addSubview:weakImageButton];

            }
            [self setFrame:CGRectMake(0, 0, 76*[imageArray_ count]+inWidth*4, 76 +InHeight*2)];
        }
            break;
        case 4:
        {
            for (NSInteger i=0; i<[imageArray_ count]; i++) {
                UIButton *weakImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [weakImageButton sd_setImageWithURL:[NSURL URLWithString:[imageArray_ objectAtIndex:i]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"bg__xinwen3.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (image == nil) {
                        [[SDWebImageManager sharedManager].imageDownloader downloadImageWithURL:imageURL options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                            
                        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                            if (finished) {
                                if (image == nil) {
                                    [weakImageButton setImage:[UIImage imageNamed:@"bg__xinwen3.png"] forState:UIControlStateNormal];
                                }else{
                                    [weakImageButton setImage:image forState:UIControlStateNormal];
                                }
                                
                            }
                        }];
                    }
                    
                }];
                [weakImageButton addTarget:self action:@selector(imageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                [weakImageButton setTag:1000+i];
                weakImageButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
                if (i<2) {
                    [weakImageButton setFrame:CGRectMake(inWidth +(76+inWidth)*i, InHeight, 76, 76)];
                }else{
                    [weakImageButton setFrame:CGRectMake(inWidth +(76+inWidth)*(i-2), 76+InHeight*2, 76, 76)];
                }
                [self addSubview:weakImageButton];
            }
            [self setFrame:CGRectMake(0, 0, 76*[imageArray_ count]/2+inWidth*3, 76*2+InHeight*3)];
        }
            break;
        case 5:
        case 6:
        {
            for (NSInteger i=0; i<[imageArray_ count]; i++) {
                UIButton *weakImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [weakImageButton sd_setImageWithURL:[NSURL URLWithString:[imageArray_ objectAtIndex:i]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"bg__xinwen3.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (image == nil) {
                        [[SDWebImageManager sharedManager].imageDownloader downloadImageWithURL:imageURL options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                            
                        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                            if (finished) {
                                if (image == nil) {
                                    [weakImageButton setImage:[UIImage imageNamed:@"bg__xinwen3.png"] forState:UIControlStateNormal];
                                }else{
                                    [weakImageButton setImage:image forState:UIControlStateNormal];
                                }
                                
                            }
                        }];
                    }
                    
                }];
                weakImageButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
                [weakImageButton addTarget:self action:@selector(imageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                if (i<3) {
                    [weakImageButton setFrame:CGRectMake(inWidth + (76+inWidth)*i, InHeight, 76, 76)];
                }else{
                    [weakImageButton setFrame:CGRectMake(inWidth +(76+inWidth)*(i-3), 76+InHeight*2, 76, 76)];
                }
                [weakImageButton setTag:1000+i];
                [self addSubview:weakImageButton];
            }
            [self setFrame:CGRectMake(0, 0, 76*3+inWidth*4, 76*2+InHeight *3)];
        }
            break;
        case 7:
        case 8:
        case 9:
        {
            for (NSInteger i=0; i<[imageArray_ count]; i++) {
                UIButton *weakImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [weakImageButton sd_setImageWithURL:[NSURL URLWithString:[imageArray_ objectAtIndex:i]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"bg__xinwen3.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (image == nil) {
                        [[SDWebImageManager sharedManager].imageDownloader downloadImageWithURL:imageURL options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                            
                        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                            if (finished) {
                                if (image == nil) {
                                    [weakImageButton setImage:[UIImage imageNamed:@"bg__xinwen3.png"] forState:UIControlStateNormal];
                                }else{
                                    [weakImageButton setImage:image forState:UIControlStateNormal];
                                }
                                
                            }
                        }];
                    }
                    
                }];
                [weakImageButton addTarget:self action:@selector(imageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                [weakImageButton setTag:1000+i];
                weakImageButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
                if (i < 3) {
                    [weakImageButton setFrame:CGRectMake(inWidth +(76+inWidth)*i, InHeight, 76, 76)];
                }
                else if (i >= 3 && i < 6){
                    [weakImageButton setFrame:CGRectMake(inWidth +(76+inWidth)*(i-3), 76+InHeight*2, 76, 76)];
                }
                else
                {
                    [weakImageButton setFrame:CGRectMake(inWidth +(76+inWidth)*(i-6), 76+InHeight*3, 76, 76)];
                }
                [self addSubview:weakImageButton];
            }
            [self setFrame:CGRectMake(0, 0, 76*[imageArray_ count]/2+inWidth*3, 76*2+InHeight*3)];
        }
            break;
        default:
            break;
    }
    
//    [self createWeakImageButton:imageArray];
//    [self setBackgroundColor:[UIColor blueColor]];
}


/*
- (void)createWeakImageButton:(NSArray *)imgArr
{
    
    int totalloc = 3;
    CGFloat appvieww = 76;
    CGFloat appviewh = 76;
    
    
    for (NSInteger i = 0; i < [imgArr count]; i++) {
        
        int row = i / totalloc;//行号
        //1/3=0,2/3=0,3/3=1;
        int loc = i % totalloc;//列号
        
        CGFloat appviewx = inWidth + (inWidth + appvieww) * loc;
        CGFloat appviewy = InHeight + (InHeight + appviewh) * row;
        
        
        UIButton *weakImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [weakImageButton sd_setImageWithURL:[NSURL URLWithString:[imgArr objectAtIndex:i]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"bg__xinwen3.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (image == nil) {
                [[SDWebImageManager sharedManager].imageDownloader downloadImageWithURL:imageURL options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    
                } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                    if (finished) {
                        if (image == nil) {
                            [weakImageButton setImage:[UIImage imageNamed:@"bg__xinwen3.png"] forState:UIControlStateNormal];
                        }else{
                            [weakImageButton setImage:image forState:UIControlStateNormal];
                        }
                        
                    }
                }];
            }
            
        }];
        weakImageButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [weakImageButton addTarget:self action:@selector(imageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        if (i<3) {
//            [weakImageButton setFrame:CGRectMake(inWidth + (76+inWidth)*i, InHeight, 76, 76)];
//        }else{
//            [weakImageButton setFrame:CGRectMake(inWidth +(76+inWidth)*(i-3), 76+InHeight*2, 76, 76)];
//        }
        
        [weakImageButton setFrame:CGRectMake(appviewx, appviewy, appvieww, appviewh)];
        [weakImageButton setTag:1000+i];
        [self addSubview:weakImageButton];
        [self setFrame:CGRectMake(0, 0, (appvieww + inWidth) * totalloc + inWidth, (appviewh + InHeight) * (row + 1) + InHeight)];
    }
//    [self setFrame:CGRectMake(0, 0, 76*3+inWidth*4, 76*2+InHeight *3)];
    
}
*/


- (void)imageButtonClick:(UIButton *)button
{
    if (_noBtnClick) {
        return;
    }
        if (self.imageClickBlock) {
            self.imageClickBlock();
        }
        NSMutableArray *photos = [NSMutableArray arrayWithCapacity:[imageArray_ count]];
        for (int i=0; i<[imageArray_ count]; i++) {
            MJPhoto *photo = [[MJPhoto alloc] init];
            NSString *urlStr = [imageArray_ objectAtIndex:i];
            urlStr = [urlStr stringByReplacingOccurrencesOfString:@"_360_270" withString:@""];
            photo.url = [NSURL URLWithString:urlStr]; //图片URL
            [photos addObject:photo];
        }
        NSInteger indexInt = [imageArray_ indexOfObject:[imageArray_ objectAtIndex:button.tag-1000]]; //index索引你 你懂得
        MJPhotoBrowser *photoBrowser_ = [[MJPhotoBrowser alloc] init];
        photoBrowser_.isposition_ = YES;
        photoBrowser_.delegate = self;    
        photoBrowser_.currentPhotoIndex = indexInt; //显示第几张照片
        photoBrowser_.photos = photos; //photos 是一个array 里面的每一个元素都一个NSString的图片URL
        [photoBrowser_ show];
}

#pragma MJPhotoBrowserDelegate
-(void) photoBrowserHide:(MJPhotoBrowser *)photoBrowser
{
    
}

@end
