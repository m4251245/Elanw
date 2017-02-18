//
//  Companyinfo_ViewController.m
//  jobClient
//
//  Created by 一览ios on 16/7/27.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "Companyinfo_ViewController.h"
#import "CompanyName_settingViewController.h"
#import "RequestViewCtl.h"
#import "PhotoVoiceDataModel.h"
#import "AlbumListCtl.h"
#import "Enterprise_scaleViewController.h"
#import "ELTradeChangeCtl.h"
#import "New_PhotoSelectionViewController.h"
#import "New_CompanyDataModel.h"

@interface Companyinfo_ViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,LogoPhotoSelectCtlDelegate,RequestViewCtlDelegate,EditorTradeDelegate>
{
    NSArray *dataArr;
    RequestViewCtl * requestVoiceAndPhotoCtl;
    UIImage *uploadImage;       //相册选择的img
    RequestCon *uploadMyImgCon_;
    PhotoVoiceDataModel *model;//照片model
    NSString *cnameStr;//企业简称
    NSString *scaleCname;//企业规模
    NSString *belongTo;//所属行业
    NSString *mainCname;//企业主页
}
@property (weak, nonatomic) IBOutlet UITableView *companyTable;
@end

@implementation Companyinfo_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self loadData];
}
#pragma mark--配置界面
-(void)configUI{
    _companyTable.backgroundColor = UIColorFromRGB(0xf0f0f0);
    [self setNavTitle:@"企业信息"];
    [self leftButtonItem:@"back_white_new"];
    _companyTable.separatorColor = UIColorFromRGB(0xe0e0e0);
    _companyTable.tableFooterView = [[UIView alloc]init];
}


#pragma mark--加载数据
-(void)loadData{
    model = [[PhotoVoiceDataModel alloc]init];
    dataArr = @[@"企业全称",@"企业简称",@"企业logo",@"企业规模",@"所属行业",@"企业主页"];
    [self requestData];
}

-(void)requestData{
    [BaseUIViewController showLoadView:YES content:nil view:nil];
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"company_id=%@",_companyId];
    NSString *function = @"getCompanyInfo";
    NSString *op = @"company_info_busi";
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        NSDictionary *dataDic = (NSDictionary *)result;
        _cInfoVO = [New_CompanyDataModel new];
        [_cInfoVO setValuesForKeysWithDictionary:dataDic];
        [_companyTable reloadData];
        [BaseUIViewController showLoadView:NO content:nil view:nil];

    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [BaseUIViewController showLoadView:NO content:nil view:nil];
    }];
}

#pragma mark--代理
//所属行业回调
- (void)editorSuccessWithTradeName:(NSString *)tradeName tradeId:(NSString *)tradeId{
    belongTo = tradeName;
    [_companyTable reloadData];
}

#pragma mark--tableView代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"settingCell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    UILabel *titleLb = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 100, 20)];
    titleLb.font = [UIFont systemFontOfSize:16];
    titleLb.textColor = UIColorFromRGB(0x333333);
    titleLb.text = dataArr[indexPath.row];
    [cell.contentView addSubview:titleLb];
    [self conLabelOrImg:indexPath withTable:cell];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //协同账号无法修改信息
    NSString *synergy_id = [CommonConfig getDBValueByKey:@"synergy_id"];
    if (synergy_id && synergy_id.length > 1) {
        return;
    }
    if (indexPath.row == 1) {//简称
        [self didSelectSimplyAndMain:0 withNowCname:cnameStr];
    }
    if(indexPath.row == 2){//logo
        UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选取",@"拍照", nil];
        [action showInView:self.view];
    }
    if (indexPath.row == 3) {//规模
        [self didSelectScaleAndBelong:1];
    }
    if (indexPath.row == 4) {//所属行业
        [self belongTo];
    }
    if (indexPath.row == 5) {//企业主页
        [self didSelectSimplyAndMain:1 withNowCname:mainCname];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

#pragma mark-action代理
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
        if(buttonIndex == 0){
            AlbumListCtl *albumListCtl = [[AlbumListCtl alloc]init];
            albumListCtl.maxCount = 1;
            albumListCtl.logoDelegate = self;
            albumListCtl.isOnlyOneSel = YES;
            [self.navigationController pushViewController:albumListCtl animated:YES];
            [albumListCtl beginLoad:nil exParam:nil];
        }
        else if(buttonIndex == 1){
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self.navigationController presentViewController:picker animated:YES completion:nil];
//            [self performSelector:@selector(setup:) withObject:picker.view afterDelay:0.5f];
        }
        else{
            return;
        }
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    uploadImage = [info objectForKey:UIImagePickerControllerEditedImage];
    uploadImage = [uploadImage fixOrientation];
    NSData *imgData = UIImageJPEGRepresentation(uploadImage, 0.3);
    NSArray *photoDataArr = [[NSArray alloc] initWithObjects:imgData, nil];
    [self uploadImgWithArr:photoDataArr];
}

#pragma mark - PhotoSelectCtlDelegate
- (void)hadFinishSelectPhoto:(NSArray *)imageArr
{
    if (imageArr.count > 0)
    {
        @try {
            NSMutableArray *imgDataArr = [NSMutableArray array];
            for (uploadImage in imageArr) {
                NSData *imgData = UIImageJPEGRepresentation(uploadImage, 0.3);
                [imgDataArr addObject:imgData];
            }
            uploadImage = [uploadImage fixOrientation];
            [self uploadImgWithArr:imgDataArr];
        }
        @catch (NSException *exception) {
            NSLog(@"%@",exception);
        }
        @finally {
            
        }
    }
}

#pragma mark - 图片上传成功代理返回图片ID
- (void)upLoadImageSuccess:(NSString *)photoId withImagePath:(NSString *)imagePathStr Image:(UIImage *)image
{
    model.photoId_ = photoId;
    model.photoSmallPath140_ = imagePathStr;
    model.image_ = image;
    [_companyTable reloadData];
}

#pragma mark--事件
-(void)setup:(UIView *) aView{
    
}


-(void)leftBtnClick:(id)button{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark--业务逻辑
-(void)conLabelOrImg:(NSIndexPath *)indexPath withTable:(UITableViewCell *)cell{
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 25, 18, 8, 13)];
    img.image = [UIImage imageNamed:@"right_grey.png"];
    
    UILabel *rightConLb = [[UILabel alloc]initWithFrame:CGRectMake(100, 15, ScreenWidth - 134, 20)];
    rightConLb.font = [UIFont systemFontOfSize:15];
    rightConLb.textColor = UIColorFromRGB(0xaaaaaa);
    rightConLb.textAlignment = NSTextAlignmentRight;
    if (indexPath.row == 2) {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 92, 7, 58, 35)];
        if (model.photoSmallPath140_.length > 0) {
            
            [imgView sd_setImageWithURL:[NSURL URLWithString:model.photoSmallPath140_]];
        }
        else{
            if (_cInfoVO.logopath.length > 0) {
                
                [imgView sd_setImageWithURL:[NSURL URLWithString:_cInfoVO.logopath]];
            }
        }
        [cell.contentView addSubview:imgView];
        [cell.contentView addSubview:img];
    }
    else{
        if (indexPath.row == 0) {
            rightConLb.frame = CGRectMake(100, 15, ScreenWidth - 115, 20);
            rightConLb.text = _cInfoVO.cname;

        }
        else{
            if(indexPath.row == 1){
                if (!cnameStr) {
                    cnameStr = _cInfoVO.cname_jc;
                }
                
                rightConLb.text = cnameStr;
            }
            if (indexPath.row == 3) {
                if (!scaleCname) {
                    scaleCname = _cInfoVO.yuangong;
                }
                rightConLb.text = scaleCname;
            }
            if (indexPath.row == 4) {
                if (!belongTo) {
                    belongTo = _cInfoVO.trade;
                }
                
                rightConLb.text = belongTo;
            }
            if (indexPath.row == 5){
                if (!mainCname) {
                    mainCname = _cInfoVO.http;
                }
                rightConLb.text = mainCname;
            }
            rightConLb.frame = CGRectMake(100, 15, ScreenWidth - 134, 20);
            [cell.contentView addSubview:img];
        }
        [cell.contentView addSubview:rightConLb];
    }
    
}
//企业简称，企业主页
-(void)didSelectSimplyAndMain:(NSInteger)numIdx withNowCname:(NSString *)nowCname{
    __weak typeof(self) WeakSelf = self;
    CompanyName_settingViewController *cnameVC = [[CompanyName_settingViewController alloc]init];
    cnameVC.cType = numIdx;
    cnameVC.nowCname = nowCname;
    cnameVC.companyId = _companyId;
    cnameVC.MyBlock = ^(NSString *cname){
        if (numIdx == 0) {
            cnameStr = cname;
        }
        else{
            mainCname = cname;
        }
        [WeakSelf.companyTable reloadData];
    };
    [self.navigationController pushViewController:cnameVC animated:YES];
}
//所属行业
-(void)belongTo{
    ELTradeChangeCtl *ctl = [[ELTradeChangeCtl alloc] init];
    ctl.delegate = self;
    User_DataModal *dataModel = [User_DataModal new];
    dataModel.tradeName = belongTo;
    ctl.type = 1;
    ctl.companyId = _companyId;
    [self.navigationController pushViewController:ctl animated:YES];
    [ctl beginLoad:dataModel exParam:nil];
}
//企业规模
-(void)didSelectScaleAndBelong:(NSInteger)numIdx{
     __weak typeof(self) WeakSelf = self;
    Enterprise_scaleViewController *scaleVC = [[Enterprise_scaleViewController alloc]init];
    scaleVC.selectedType = numIdx;
    scaleVC.cScaleName = scaleCname;
    scaleVC.companyId = _companyId;
    scaleVC.MyBlock = ^(NSString *scaleName){
        scaleCname = scaleName;
        [WeakSelf.companyTable reloadData];
    };
    [self.navigationController pushViewController:scaleVC animated:YES];
}

-(void)uploadImgWithArr:(NSArray *)arr{
    //图片上传/替换
    if (!requestVoiceAndPhotoCtl) {
        requestVoiceAndPhotoCtl = [[RequestViewCtl alloc]init];  //用于上传图片的Ctl
        requestVoiceAndPhotoCtl.delegate_ = self;
    }
    requestVoiceAndPhotoCtl.type_ = @"1";
    requestVoiceAndPhotoCtl.requestType = @"2";
    requestVoiceAndPhotoCtl.replacePhotoId_ = nil;
    requestVoiceAndPhotoCtl.logotype = 1;
    requestVoiceAndPhotoCtl.companyId = _companyId;
    requestVoiceAndPhotoCtl.logoPath = _cInfoVO.logopath;
    [requestVoiceAndPhotoCtl beginLoad:arr exParam:nil];
}

@end
