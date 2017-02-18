//
//  RequestViewCtl.m
//  jobClient
//
//  Created by 一览iOS on 14-9-25.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "RequestViewCtl.h"
#import "ResumeHeaderViewController.h"
#import "Companyinfo_ViewController.h"
@interface RequestViewCtl ()
{
    NSInteger index;
    
    NSString *imagePath;
}
@end

@implementation RequestViewCtl
@synthesize delegate_,type_,replacePhotoId_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    //1 添加图片
    if ([type_ isEqualToString:@"1"]) {
        if (!tempArr) {
            tempArr = [[NSMutableArray alloc]init];
        }
        tempArr = dataModal;
    }
    // 3删除图片
    if ([type_ isEqualToString:@"3"]) {
        inPhoto_ = dataModal;
    }
    index = 0;
}

- (void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
}

-(void)getDataFunction:(RequestCon *)con
{
    if ([type_ isEqualToString:@"1"]) {
        [self upLoadPhotoToService];
    }else if ([type_ isEqualToString:@"2"]){
        [self upLoadResumePhoto];
    }else if([type_ isEqualToString:@"3"]){
        [self deleteResumePhoto];
    }
    
}

-(void)upLoadPhotoToService
{
    if (index == tempArr.count)
    {
        return;
    }
    //以时间命名图片
    NSDate * now = [NSDate date];
    NSString * timeStr = [now stringWithFormat:@"yyyy-MM-dd_HHmmss" timeZone:[NSTimeZone systemTimeZone] behavior:NSDateFormatterBehaviorDefault];
    RequestCon *uploadCon = [self getNewRequestCon:NO];
    [uploadCon uploadPhotoData:tempArr[index] name:[NSString stringWithFormat:@"%@.jpg",timeStr]];
    
}

- (void)upLoadResumePhoto
{
    if (!infoCon_) {
        infoCon_ = [self getNewRequestCon:NO];
    }
    [infoCon_ getResumePhotoAndVoice:[Manager getUserInfo].userId_];
}

- (void)deleteResumePhoto
{
    if (!deleteCon_) {
        deleteCon_ = [self getNewRequestCon:NO];
    }
    [deleteCon_ deleteResumeImage:[Manager getUserInfo].userId_ photoId:inPhoto_];
}

-(void) finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_UploadPhotoFile:
        {
            if (_logotype == 1) {
                Upload_DataModal *model = [dataArr objectAtIndex:0];
                NSString *imgPath = model.path_;
                NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
                [conditionDic setObject:_logoPath forKey:@"logopath_before"];
                [conditionDic setObject:imgPath forKey:@"logopath"];
                SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
                NSString *conDicStr = [jsonWriter stringWithObject:conditionDic];
                NSString * bodyMsg = [NSString stringWithFormat:@"company_id=%@&contact_arr=%@",_companyId,conDicStr];
                NSString *function = @"editCompanyInfo";
                NSString *op = @"company_info_busi";
                [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
                    NSString *status = result[@"status"];
                    if ([status isEqualToString:@"TRUE"]) {
                        if ([delegate_ isKindOfClass:[Companyinfo_ViewController class]]) {
                            [delegate_ upLoadImageSuccess:nil withImagePath:imgPath Image:nil];
                        }
                    }
                    [BaseUIViewController showLoadView:NO content:nil view:nil];
                } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                    [BaseUIViewController showLoadView:NO content:nil view:nil];
                }];
            }
            else{
                SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
                //photo_info
                Upload_DataModal *model = [dataArr objectAtIndex:0];
                
                NSMutableDictionary * photoInfoDic = [[NSMutableDictionary alloc] init];
                [photoInfoDic setObject:model.name_ forKey:@"name"];
                [photoInfoDic setObject:model.size_ forKey:@"size"];
                [photoInfoDic setObject:model.exe_ forKey:@"exe"];
                [photoInfoDic setObject:model.path_ forKey:@"path"];
                for (Upload_DataModal *dataModel in model.pathArr_) {
                    if ([dataModel.size_ isEqualToString:@"960"]) {
                        [photoInfoDic setObject:dataModel.path_ forKey:@"path_960"];
                    }else if ([dataModel.size_ isEqualToString:@"670"]){
                        [photoInfoDic setObject:dataModel.path_ forKey:@"path_670"];
                    }else if ([dataModel.size_ isEqualToString:@"220"]){
                        [photoInfoDic setObject:dataModel.path_ forKey:@"path_220"];
                    }else if ([dataModel.size_ isEqualToString:@"140"]){
                        [photoInfoDic setObject:dataModel.path_ forKey:@"path_140"];
                        imagePath = dataModel.path_;
                    }else if ([dataModel.size_ isEqualToString:@"80"]){
                        [photoInfoDic setObject:dataModel.path_ forKey:@"path_80"];
                    }
                }
                NSString * photoInfoStr = [jsonWriter stringWithObject:photoInfoDic];
                
                NSMutableDictionary * conditionArr = [[NSMutableDictionary alloc] init];
                if (replacePhotoId_ != nil) {
                    [conditionArr setObject:replacePhotoId_ forKey:@"photo_id"];
                }
                [conditionArr setObject:@"1" forKey:@"scene"];
                NSString * conditionStr = [jsonWriter stringWithObject:conditionArr];
                
                //设置请求参数
                
                NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@&photo_info=%@&condition_arr=%@",[Manager getUserInfo].userId_,photoInfoStr,conditionStr];
                
                NSString * function = @"addPersonPhoto";
                NSString * op   =   @"person_sub_busi";
                
                [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result)
                 {
                     NSDictionary *dic = result;
                     Status_DataModal *model = [[Status_DataModal alloc]init];
                     model.status_ = [dic objectForKey:@"status"];
                     model.exObj_ = [[dic objectForKey:@"info"] objectForKey:@"id"];
                     
                     if ([model.status_ isEqualToString:@"OK"]) {
                         
                         if([delegate_ isKindOfClass:[PhotoListCtl class]])
                         {
                             [delegate_ upLoadImageSuccess:model.exObj_ withImage:[UIImage imageWithData:tempArr[index]]];
                         }
                         else if ([delegate_ isKindOfClass:[ResumeHeaderViewController class]])
                         {
                             [delegate_ upLoadImageSuccess:model.exObj_ withImagePath:imagePath Image:[UIImage imageWithData:tempArr[index]]];
                         }
                         else{
                             [delegate_ upLoadImageSuccess:model.exObj_];
                         }
                         
                         index += 1;
                         [self performSelector:@selector(upLoadPhotoToService) withObject:self afterDelay:0.1];//延时处理
                         
                         //                    if (index == tempArr.count) {
                         //                        [BaseUIViewController showAutoDismissSucessView:@"上传成功" msg:nil];
                         //                    }
                     }else{
                         [BaseUIViewController showAutoDismissFailView:@"上传失败" msg:nil];
                     }
                     
                 } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                     
                 }];
            }
        }
            
            break;
        case Request_AddResumePhoto:
        {
//            Status_DataModal *model = [dataArr objectAtIndex:0];
//            if ([model.status_ isEqualToString:@"OK"]) {
//                //[BaseUIViewController showAutoDismissSucessView:@"上传成功" msg:nil];
//                [delegate_ upLoadImageSuccess:model.exObj_];
//                index += 1;
//                [self performSelector:@selector(upLoadPhotoToService) withObject:self afterDelay:0.8];//延时处理
//                //[self upLoadPhotoToService];
//            }else{
//                [BaseUIViewController showAutoDismissFailView:@"上传失败" msg:nil];
//            }
        }
            break;
        case Request_GetResumePhotoAndVoice:
        {
            [delegate_ getResumePhotoAndVoiceSuccess:dataArr];
        }
            break;
        case Request_DeleteResumeImage:
        {
            if ([[dataArr objectAtIndex:0] isEqualToString:@"OK"]) {
                [delegate_ delegatePhotoSuccess];
                [BaseUIViewController showAutoDismissSucessView:@"删除成功" msg:nil];
            }else{
                [BaseUIViewController showAutoDismissFailView:@"删除失败" msg:nil];
            }
        }
            break;
        default:
            break;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
