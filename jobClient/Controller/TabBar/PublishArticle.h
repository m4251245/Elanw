//
//  PublishArticle.h
//  jobClient
//
//  Created by YL1001 on 14/12/10.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseEditInfoCtl.h"
#import "ExRequetCon.h"
#import "Groups_DataModal.h"
#import "MessagePhotoView.h"

typedef enum
{
    Article,
    Topic,
    AllTopic,
}PublishType;

@protocol PublishArticleDelegate <NSObject>

@optional
-(void)publishSuccess;


@end

@interface PublishArticle : BaseEditInfoCtl<UIWebViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MessagePhotoViewDelegate, UITextViewDelegate>
{
    UITextField            * titleTf_;
    UIButton               * chooseImgBtn_;
    UIView                 * contentView_;
    UIView                 * tagView_;
    UIButton               * addTagBtn_;
    UITextField            * tag1TF_;
    UITextField            * tag2TF_;
    UITextField            * tag3TF_;
    UITextField            * tag4TF_;
    UITextField            * tag5TF_;
    UITextField            * tag6TF_;
    UILabel                * tipsLb_;
    UIImageView *_niMingImage;
    UIButton *_niMingBtn;
    UILabel *_niMingLable;
    UIButton *_faceBtn;
    int                             tagCount_;                  //标签数量
    BOOL                            imgFlag_;                  //YES设置了图片，NO未设置
    RequestCon                      * addCon_;
    RequestCon                      * uploadMyImgCon_;
    NSString                        *groupId;
}

@property (nonatomic,strong) MessagePhotoView * photoView;

@property(nonatomic,assign) PublishType type_;

@property(nonatomic,weak) id<PublishArticleDelegate>  delegate_;

@property(nonatomic,assign) BOOL isFromPublishList;

@property (nonatomic,assign) BOOL fromTodayList;

@property (nonatomic) BOOL resourcesLoaded;

@property (nonatomic,assign) BOOL isCompanyGroup;

@property(nonatomic,assign) NSInteger canImageCount;

@property(nonatomic, copy) NSString *titleTxt;
@property(nonatomic, copy) NSString *content;
@property (strong, nonatomic) NSArray *imageArr;


- (void)didFinishSelectPhoto:(NSArray *)imageArr;

-(void)fromTodayListRefreshWithType:(NSInteger)type imageArr:(NSArray *)arr;

@end
