//
//  ELMessageImage_Cell.m
//  jobClient
//
//  Created by 一览iOS on 15/9/1.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ELMessageImage_Cell.h"

@implementation ELMessageImage_Cell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = UIColorFromRGB(0xf0f0f0);
        self.titleImage = [[UIImageView alloc] init];
        self.dateLb = [[UILabel alloc] init];
        self.bgBtnView = [UIButton buttonWithType:UIButtonTypeCustom];
        self.contentImage = [[UIImageView alloc] init];
        CALayer *layer = _dateLb.layer;
        _dateLb.font = [UIFont systemFontOfSize:9];
        layer.masksToBounds = YES;
        layer.cornerRadius = 4.f;
        _dateLb.backgroundColor = UIColorFromRGB(0xcecece);
        _dateLb.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_titleImage];
        [self.contentView addSubview:_dateLb];
        [self.contentView addSubview:_bgBtnView];
        [self.contentView addSubview:_contentImage];
        [self.contentView sendSubviewToBack:_bgBtnView];
        
        _nameLb = [[UILabel alloc] init];
        _nameLb.textColor = UIColorFromRGB(0x757575);
        _nameLb.font = [UIFont systemFontOfSize:12.0f];
        [self.contentView addSubview:_nameLb];
        
        _retryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _retryBtn.frame = CGRectMake(0, 0, 20, 20);
        [_retryBtn setImage:[UIImage imageNamed:@"groupChat_send_failure.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:_retryBtn];
        [_retryBtn setHidden:YES];
        
        self.titleImage.clipsToBounds = YES;
        self.contentImage.clipsToBounds = YES;
        self.titleImage.layer.cornerRadius = 4.0;
        self.contentImage.layer.cornerRadius = 4.0;
        _dateLb.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)giveDataModal:(LeaveMessage_DataModel *)modal
{
    inModal = modal;
    UIImage *bgImage;
    
    [self.titleImage sd_setImageWithURL:[NSURL URLWithString:modal.personPic] placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"]];
    if ([modal.isSend isEqualToString:@"1"])
    {
        self.titleImage.frame = CGRectMake(ScreenWidth-50,29,40,40);
        bgImage = [UIImage imageNamed:@"icon_dailog1.png"];
        bgImage = [bgImage stretchableImageWithLeftCapWidth:bgImage.size.width*0.4 topCapHeight:bgImage.size.height*0.8];
    }
    else
    {
        self.titleImage.frame = CGRectMake(8,29,40,40);
        bgImage = [UIImage imageNamed:@"icon_dailog2.png"];
        bgImage = [bgImage stretchableImageWithLeftCapWidth:bgImage.size.width*0.6 topCapHeight:bgImage.size.height*0.8];
    }
    
    [self.bgBtnView addTarget:self action:@selector(btnResponeOne:) forControlEvents:UIControlEventTouchUpInside];
    CGSize sizeOne = [modal.date sizeNewWithFont:[UIFont systemFontOfSize:9]];
    _dateLb.frame = CGRectMake((ScreenWidth-sizeOne.width-5)/2,10,sizeOne.width + 8,11);
    if (!modal.date) {
        _dateLb.hidden = YES;
    }else{
        _dateLb.hidden = NO;
        _dateLb.text = modal.date;
    }
    
    NSString *strUrl;
    if([modal.imageUrl_ containsString:@"#"])
    {
        NSRange range = [modal.imageUrl_ rangeOfString:@"#"];
        strUrl = [modal.imageUrl_ substringFromIndex:range.location+1];
    }
    else
    {
        strUrl = modal.imageUrl_;
    }
    
    __block CGSize nameSize;
    if (self.isShowNameLb) {
        self.nameLb.text = modal.personIName;
        [_nameLb sizeToFit];
        nameSize = _nameLb.frame.size;
    }
    
    if (!modal.image) {
        [self.contentImage sd_setImageWithURL:[NSURL URLWithString:strUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
         {
             if (image)
             {
                 [self calculateFrame:image nameSize:nameSize model:modal bgImage:bgImage];
             }
         }];
    }
    else{
        if (modal.image)
        {
            self.contentImage.image = modal.image;
            [self calculateFrame:modal.image nameSize:_nameLb.frame.size model:modal bgImage:bgImage];
        }
    }
    
}

- (void)calculateFrame:(UIImage *)image nameSize:(CGSize)nameSize model:(LeaveMessage_DataModel *)modal bgImage:(UIImage *)bgImage
{
    CGSize size = [self creatHeightWidthSize:image.size andSize:CGSizeMake(ScreenWidth-120,80)];
    [self.contentImage setImage:image];
    [self.bgBtnView setBackgroundImage:bgImage forState:UIControlStateNormal];
    if ([modal.isSend isEqualToString:@"1"])
    {
        self.bgBtnView.frame = CGRectMake(ScreenWidth-55-size.width-14, 30, size.width+14, size.height+4);
        self.contentImage.frame = CGRectMake(ScreenWidth-55-size.width-12, 32, size.width, size.height);
        self.retryBtn.frame = CGRectMake(ScreenWidth-55-size.width-14-25, _bgBtnView.frame.size.height/2+15, 30, 30);
    }
    else
    {
        if (self.isShowNameLb) {
            self.bgBtnView.frame = CGRectMake(55, 30+nameSize.height, size.width+14, size.height+4);
            self.contentImage.frame = CGRectMake(67, 32+nameSize.height, size.width, size.height);
            self.nameLb.frame = CGRectMake(55, 29, nameSize.width, nameSize.height);
        }
        else {
            self.bgBtnView.frame = CGRectMake(55,30,size.width+14,size.height+4);
            self.contentImage.frame = CGRectMake(67,32,size.width,size.height);
        }
    }

}

-(CGSize)creatHeightWidthSize:(CGSize)size andSize:(CGSize)sizeOne
{
    CGFloat frameW = size.width;
    CGFloat frameH = size.height;
    CGFloat height = 0;
    CGFloat width = 0;
    if (frameW/(frameH*1.0) >= sizeOne.width/(sizeOne.height*1.0)) {
        if (frameW <= sizeOne.width) {
            height = frameH;
            width = frameW;
        }
        else
        {
            height = (sizeOne.width * frameH)/(frameW * 1.0);
            width = sizeOne.width;
        }
    }
    else
    {
        if (frameH <= sizeOne.height) {
            width = frameW;
            height = frameH;
        }
        else
        {
            width = (sizeOne.height *frameW)/(frameH *1.0);
            height = sizeOne.height;
        }
    }
    return CGSizeMake(width,height);
}

-(void)btnResponeOne:(UIButton *)sender
{
    photoBrowser_ = [[MJPhotoBrowser alloc] init];
    photoBrowser_.isposition_ = YES;
    NSString *strUrl;
    if([inModal.imageUrl_ containsString:@"#"])
    {
        NSRange range = [inModal.imageUrl_ rangeOfString:@"#"];
        strUrl = [inModal.imageUrl_ substringToIndex:range.location];
    }
    else
    {
        strUrl = inModal.imageUrl_;
    }
    MJPhoto *photo = [[MJPhoto alloc] init];
    photo.url = [NSURL URLWithString:strUrl];
    
    //photos 是一个array 里面的每一个元素都一个NSString的图片URL
    photoBrowser_.photos = [[NSMutableArray alloc] initWithObjects:photo,nil];
    [photoBrowser_ show];
    [_cellDelegate hideKeyBord];
}

@end
