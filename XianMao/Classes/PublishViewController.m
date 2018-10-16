//
//  PublishViewController.m
//  yuncangcat
//
//  Created by apple on 16/7/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PublishViewController.h"
#import "PullRefreshTableView.h"
#import "BaseTableViewCell.h"
#import "PublishChooseCateCell.h"
#import "SepTableViewCell.h"
#import "PublishChooseBrandCell.h"
#import "PublishChooseGradeCell.h"
#import "PublishDescriptionCell.h"
#import "PublishPriceCell.h"
#import "PublishMeasurementCell.h"
#import "PublishAttachmentCell.h"
#import "SendGoodsTimeCell.h"
#import "LxGridViewFlowLayout.h"
#import "TZTestCell.h"
#import "UIView+Layout.h"
#import "TZImagePickerController.h"
//#import "PublishSelectViewController.h"
#import "PublishGoodsViewController.h"
#import "Cate.h"
#import "CategoryService.h"
#import "Error.h"
#import "GoodsEditableInfo.h"
#import "BrandInfo.h"
#import "Command.h"
#import "AppDirs.h"
#import "AuthenticateFlowCell.h"
//#import "AttrInfoEditButton.h"
#import "WCAlertView.h"
#import "PublishChooseGradeViewController.h"
#import "DigitalKeyboardView.h"
#import "DetailParamCell.h"
#import "PublishPromptView.h"
#import "PublishAttrInfo.h"
#import "ExpandTableViewCell.h"
#import "ExpandCell.h"
#import "AgreeCell.h"
#import "NetworkAPI.h"
#import "ExpandInputCell.h"
#import "ExpandColorCell.h"
#import "ExpandYiJianCell.h"
#import "PublishGoodsNameCell.h"
#import "TakePhotoViewController.h"
#import "publishBtn.h"
#import "Session.h"
#import "publishCheckModel.h"
#import "SDWebImageDecoder.h"
#import "PublishPromptCell.h"
#import "PriceNumberKeyboardView.h"
#import "BlackView.h"
#import "PublishAgreementCell.h"

@interface PublishViewController () <UITableViewDataSource, UITableViewDelegate, PullRefreshTableViewDelegate, TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate, PublishSelectViewControllerDelegate, PublishChooseGradeViewControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, PictureItemsEditViewDelegate>

@property (nonatomic, strong) PullRefreshTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSources;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) Cate *selectedCate;
@property (nonatomic, strong) NSMutableArray *cateList;

@property (nonatomic, strong) GoodsEditableInfo *editableInfo;
@property(nonatomic,strong) NSMutableDictionary *cateAttrInfoDict;
@property(nonatomic,strong) BrandInfo *selectedBrandInfo;
@property (nonatomic, strong) NSArray *brandList;

@property (nonatomic, copy) NSString *grade;
@property (nonatomic, assign) NSInteger gradeId;
@property (nonatomic, copy) NSString *cateName;
@property (nonatomic, copy) NSString *brandName;
@property (nonatomic, copy) NSString *brandEnName;

@property (nonatomic, copy) NSString *descText;

@property (nonatomic, copy) NSString *yuanPrice;
@property (nonatomic, copy) NSString *jianyiPrice;
@property (nonatomic, copy) NSString *dioahuoPrice;

@property (nonatomic, assign) NSInteger longInt;
@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSMutableArray *pickerArr;
@property (nonatomic, strong) UIButton *pickerCanCelBtn;
@property (nonatomic, strong) UIButton *pickerDownBtn;
@property (nonatomic, copy) NSString *pickerTitle;
@property (nonatomic, strong) UIView *pickerBgView;

@property (nonatomic, strong) PublishPromptView *promptView;

@property (nonatomic, strong) NSArray *goodsDesc;
@property (nonatomic, assign) NSInteger parent_cate_id;

@property (nonatomic, strong) NSMutableArray *attrList;
@property (nonatomic, assign) NSInteger index;//判断是否展开

@property (nonatomic, strong) publishBtn *publishBtn;


@property(nonatomic,strong) PictureItemsEditViewForPublishGoods *picturesEditView;
@property(nonatomic,strong) CALayer *picturesEditViewTop;
@property(nonatomic,strong) CALayer *picturesEditViewBottom;
@property(nonatomic,assign) CGFloat picturesEditViewHeight;

@property (nonatomic, strong) HTTPRequest *request;

@property (nonatomic, strong) NSMutableArray *picItemsArray;
@property (nonatomic, strong) NSMutableArray *attrInfoList;

@property (nonatomic, assign) NSInteger editPublish;
@property (nonatomic, strong) NSMutableArray *attrStrArr;

@property (nonatomic, strong) NSMutableDictionary *dict;
@property (nonatomic, copy) NSString *goodsName;
@property (nonatomic, strong) NSMutableDictionary *sampleListDict;
@property (nonatomic, assign) NSInteger sendTime;
@property (nonatomic, assign) NSInteger sendIndex;//临时记录row
@property (nonatomic, copy) NSString * gradeName;
@property (nonatomic, strong) VerticalCommandButton * addPicButton;
@property (nonatomic, strong) PriceNumberKeyboardView * priceKeyboardView;
@property (nonatomic, strong) BlackView * blackView;
@property (nonatomic, assign) BOOL isAgreement; //是否同意发布协议,默认YES同意
@end

static NSString *SPERSTR = @",";
@implementation PublishViewController

{
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
    
    CGFloat _itemWH;
    CGFloat _margin;
    LxGridViewFlowLayout *_layout;
}

- (PriceNumberKeyboardView *)priceKeyboardView{
    if (!_priceKeyboardView) {
        _priceKeyboardView = [[PriceNumberKeyboardView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 56)];
    }
    return _priceKeyboardView;
}
-(NSMutableDictionary *)sampleListDict{
    if (!_sampleListDict) {
        _sampleListDict = [[NSMutableDictionary alloc] init];
    }
    return _sampleListDict;
}

-(NSMutableDictionary *)dict{
    if (!_dict) {
        _dict = [[NSMutableDictionary alloc] init];
    }
    return _dict;
}

-(NSMutableArray *)attrStrArr{
    if (!_attrStrArr) {
        _attrStrArr = [[NSMutableArray alloc] init];
    }
    return _attrStrArr;
}

-(NSMutableArray *)attrInfoList{
    if (!_attrInfoList) {
        _attrInfoList = [[NSMutableArray alloc] init];
    }
    return _attrInfoList;
}

-(NSMutableArray *)picItemsArray{
    if (!_picItemsArray) {
        _picItemsArray = [[NSMutableArray alloc] init];
    }
    return _picItemsArray;
}

-(GoodsEditableInfo *)editableInfo{
    if (!_editableInfo) {
        _editableInfo = [[GoodsEditableInfo alloc] init];
    }
    return _editableInfo;
}

-(publishBtn *)publishBtn{
    if (!_publishBtn) {
        _publishBtn = [[publishBtn alloc] init];
    }
    return _publishBtn;
}


-(NSMutableArray *)attrList{
    if (!_attrList) {
        _attrList = [[NSMutableArray alloc] init];
    }
    return _attrList;
}

-(NSArray *)goodsDesc{
    if (!_goodsDesc) {
        _goodsDesc = [[NSArray alloc] init];
    }
    return _goodsDesc;
}

-(PublishPromptView *)promptView{
    if (!_promptView) {
        _promptView = [[PublishPromptView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight)];
        _promptView.backgroundColor = [UIColor clearColor];
    }
    return _promptView;
}

-(UIButton *)pickerDownBtn{
    if (!_pickerDownBtn) {
        _pickerDownBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_pickerDownBtn setTitle:@"确认" forState:UIControlStateNormal];
        [_pickerDownBtn setTitleColor:[UIColor colorWithHexString:@"434342"] forState:UIControlStateNormal];
        _pickerDownBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [_pickerDownBtn sizeToFit];
    }
    return _pickerDownBtn;
}

-(UIButton *)pickerCanCelBtn{
    if (!_pickerCanCelBtn) {
        _pickerCanCelBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_pickerCanCelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_pickerCanCelBtn setTitleColor:[UIColor colorWithHexString:@"434342"] forState:UIControlStateNormal];
        _pickerCanCelBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [_pickerCanCelBtn sizeToFit];
    }
    return _pickerCanCelBtn;
}

-(NSMutableArray *)pickerArr{
    if (!_pickerArr) {
        _pickerArr = [[NSMutableArray alloc] initWithObjects:@"立即",@"1~3天",@"3~5天",@"5~10天",@"需10天以上", nil];
    }
    return _pickerArr;
}

-(NSMutableArray *)dataSources{
    if (!_dataSources) {
        _dataSources = [[NSMutableArray alloc] init];
    }
    return _dataSources;
}

-(UIPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 180)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.backgroundColor = [UIColor colorWithHexString:@"bbbbbb"];
    }
    return _pickerView;
}

-(UIView *)pickerBgView{
    if (!_pickerBgView) {
        _pickerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 200)];
        _pickerBgView.backgroundColor = [UIColor colorWithHexString:@"bbbbbb"];
    }
    return _pickerBgView;
}

-(PullRefreshTableView *)tableView{
    if (!_tableView) {
        _tableView = [[PullRefreshTableView alloc] initWithFrame:CGRectZero];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        _tableView.enableLoadingMore = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.pullDelegate = self;
    }
    return _tableView;
}

- (BlackView *)blackView{
    if (!_blackView) {
        WEAKSELF;
        _blackView = [[BlackView alloc] initWithFrame:CGRectMake(0, self.topbarShadowHeight+self.topBarHeight, kScreenWidth, kScreenHeight -(self.topBarHeight+self.topbarShadowHeight))];
        _blackView.alpha = 0;
        _blackView.dissMissBlackView = ^(){
            [weakSelf.priceKeyboardView.yuanjiaTf resignFirstResponder];
            [weakSelf.priceKeyboardView.jianyiTf resignFirstResponder];
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.priceKeyboardView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 56);
            }];
        };
    }
    return _blackView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    WEAKSELF;
    [super setupTopBar];
    [super setupTopBarBackButton:[UIImage imageNamed:@"DisMiss_cha"] imgPressed:nil];
    [self customTopBarRightButton];
    self.isAgreement = YES;
    self.sendTime = 1;
    if (self.goodsId.length>0) {
        [super setupTopBarTitle:@"编辑商品"];
        [self showLoadingView];
        [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"goods" path:@"get_editable_info_v2" parameters:@{@"goods_id":self.goodsId,@"order_id":self.orderId?self.orderId:@""} completionBlock:^(NSDictionary *data) {//self.goodsId
            weakSelf.editPublish = 1;
            [weakSelf hideLoadingView];
            
            GoodsEditableInfo *editableInfo = [[GoodsEditableInfo alloc] initWithDict:data[@"goods_editable_info"]];
            weakSelf.editableInfo = editableInfo;
            weakSelf.selectedCate = [[Cate alloc] init];
            weakSelf.selectedCate.cateId = editableInfo.categoryId;
            weakSelf.selectedCate.name = editableInfo.categoryName;
            if (editableInfo.orderId) {
                weakSelf.orderId = editableInfo.orderId;
            }
            weakSelf.cateName = editableInfo.categoryName;
            weakSelf.selectedBrandInfo = [[BrandInfo alloc] init];
            weakSelf.selectedBrandInfo.brandId = editableInfo.brandId;
            weakSelf.selectedBrandInfo.brandName = editableInfo.brandName;
            weakSelf.selectedBrandInfo.brandEnName = editableInfo.brandEnName;
            weakSelf.brandName = editableInfo.brandName;
            weakSelf.brandEnName = editableInfo.brandEnName;
            weakSelf.goodsName = editableInfo.goodsName;
            weakSelf.sendTime = editableInfo.expected_delivery_type;
            if (weakSelf.sendTime) {
                weakSelf.pickerTitle = weakSelf.pickerArr[weakSelf.sendTime-1];
            }
            
            for (int i = 0; i < editableInfo.attrInfoList.count; i++) {
                AttrEditableInfo *attrInfo = editableInfo.attrInfoList[i];
                [weakSelf.dict setObject:attrInfo forKey:[NSString stringWithFormat:@"%ld", attrInfo.attrId]];
            }
            
            if (weakSelf.selectedCate.cateId > 0) {
                [weakSelf getList];
            }
            
            if (editableInfo.marketPrice > 0) {
                weakSelf.yuanPrice = [NSString stringWithFormat:@"%.2f", editableInfo.marketPrice];
            }
            if (editableInfo.shopPrice > 0) {
                weakSelf.jianyiPrice = [NSString stringWithFormat:@"%.2f", editableInfo.shopPrice];
            }
            //            if (editableInfo.diaohuo_price > 0) {
            //                weakSelf.dioahuoPrice = [NSString stringWithFormat:@"%.2f", editableInfo.diaohuo_price];
            //            }
            weakSelf.descText = editableInfo.summary;
            weakSelf.grade = weakSelf.editableInfo.gradeName;//[weakSelf gradeText:editableInfo.grade];
            weakSelf.gradeId = weakSelf.editableInfo.grade;
            if (_editableInfo.mainPicItem && [_editableInfo.mainPicItem.picUrl length]>0) {
                [weakSelf.picItemsArray addObject:_editableInfo.mainPicItem];
            }
            
            for (NSInteger i=0;i<[_editableInfo.gallary count];i++) {
                PictureItem *item = [_editableInfo.gallary objectAtIndex:i];
                if ([item isKindOfClass:[PictureItem class]]) {
                    [weakSelf.picItemsArray addObject:item];
                }
            }
            
            _selectedPhotos = [NSMutableArray array];
            _selectedAssets = [NSMutableArray array];
            
            [weakSelf configCollectionView];
            
            
        } failure:^(XMError *error) {
            [weakSelf hideLoadingView];
            [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8];
        } queue:nil]];
        
    } else {
        weakSelf.editPublish = 0;
        [super setupTopBarTitle:@"发布"];
        _selectedPhotos = [NSMutableArray array];
        _selectedAssets = [NSMutableArray array];
        
        [weakSelf configCollectionView];
    }
    
    
    if (self.isFromDraft) {
        [self getEditInfoFromDraft];
    }
    
    
    //    [weakSelf showLoadingView];
    //    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"category" path:@"get_goods_desc_options" parameters:@{@"cate_id":[NSNumber numberWithInteger:self.selectedCate.cateId]} completionBlock:^(NSDictionary *data) {
    
    //        [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"category" path:@"get_attr_list" parameters:@{@"cate_id":[NSNumber numberWithInteger:self.selectedCate.cateId]} completionBlock:^(NSDictionary *data) {
    //            [weakSelf hideLoadingView];
    
    //            NSArray *goodsDesc = data[@"get_goods_desc_options"];
    //            self.goodsDesc = goodsDesc;
    
    //            _selectedPhotos = [NSMutableArray array];
    //            _selectedAssets = [NSMutableArray array];
    //
    //            [self configCollectionView];
    
    //        } failure:^(XMError *error) {
    //            [weakSelf hideLoadingView];
    //            [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8];
    //        } queue:nil]];
    //
    //    } failure:^(XMError *error) {
    //        [weakSelf hideLoadingView];
    //        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8];
    //    } queue:nil]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputTextField:) name:@"inputTextField" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getGoodsName:) name:@"getGoodsName" object:nil];
    [self.view addSubview:self.blackView];
    [self.priceKeyboardView showInView:self.view];
    
    self.priceKeyboardView.dissmissKeyboard =^(){
        [weakSelf.priceKeyboardView.yuanjiaTf resignFirstResponder];
        [weakSelf.priceKeyboardView.jianyiTf resignFirstResponder];
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.priceKeyboardView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 56);
            weakSelf.blackView.alpha = 0;
        }];
    };
    
    self.priceKeyboardView.inputPrice =^(NSString * yuanjiaPrice, NSString * jianyiPrice){
        weakSelf.yuanPrice = yuanjiaPrice;
        weakSelf.jianyiPrice = jianyiPrice;
        [weakSelf reloadData];
    };

}

- (void)customTopBarRightButton{
    [super setupTopBarRightButton];
    self.topBarRightButton.backgroundColor = [UIColor clearColor];
    [self.topBarRightButton setTitle:@"拍摄技巧" forState:UIControlStateNormal];
    [self.topBarRightButton setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
    self.topBarRightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.topBarRightButton.frame = CGRectMake(kScreenWidth- 80, 35, 80, 30);
}

- (void)handleTopBarRightButtonClicked:(UIButton *)sender{
    [self showPhotoShootTechniqueView];
}

-(void)getEditInfoFromDraft
{
    
    GoodsEditableInfo *editableInfo = [[Session sharedInstance] loadPublishGoodsFromDraft];
    self.editableInfo = editableInfo;
    self.selectedCate = [[Cate alloc] init];
    self.selectedCate.cateId = editableInfo.categoryId;
    self.selectedCate.name = editableInfo.categoryName;
    self.cateName = editableInfo.categoryName;
    self.selectedBrandInfo = [[BrandInfo alloc] init];
    self.selectedBrandInfo.brandId = editableInfo.brandId;
    self.selectedBrandInfo.brandName = editableInfo.brandName;
    self.selectedBrandInfo.brandEnName = editableInfo.brandEnName;
    self.brandName = editableInfo.brandName;
    self.brandEnName = editableInfo.brandEnName;
    self.goodsName = editableInfo.goodsName;
    self.sendTime = editableInfo.expected_delivery_type;
    
    if (self.sendTime) {
        self.pickerTitle = self.pickerArr[self.sendTime-1];
    }
    
    for (int i = 0; i < editableInfo.attrInfoList.count; i++) {
        AttrEditableInfo *attrInfo = editableInfo.attrInfoList[i];
        [self.dict setObject:attrInfo forKey:[NSString stringWithFormat:@"%ld", attrInfo.attrId]];
    }
    
    if (self.selectedCate.cateId > 0) {
        [self getList];
    }
    
    if (editableInfo.marketPrice > 0) {
        self.yuanPrice = [NSString stringWithFormat:@"%.2f", editableInfo.marketPrice];
    }
    
    if (editableInfo.shopPrice > 0) {
        self.jianyiPrice = [NSString stringWithFormat:@"%.2f",editableInfo.shopPrice];
    }
    
    self.descText = editableInfo.summary;
    self.grade = [self gradeText:editableInfo.grade];
    
    if (_editableInfo.mainPicItem && [_editableInfo.mainPicItem.picUrl length]>0) {
        [self.picItemsArray addObject:_editableInfo.mainPicItem];
    }
    
    for (NSInteger i=0;i<[_editableInfo.gallary count];i++) {
        PictureItem *item = [_editableInfo.gallary objectAtIndex:i];
        if ([item isKindOfClass:[PictureItem class]]) {
            [self.picItemsArray addObject:item];
        }
    }
    
    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
    [self configCollectionView];
}

-(void)handleTopBarBackButtonClicked:(UIButton *)sender
{
    
    //    if (self.isResell) {
    //        [self dismiss:YES];
    //    }else{
    //        [WCAlertView showAlertWithTitle:nil message:@"退出当前编辑的商品信息将会丢失,是否退出?" customizationBlock:^(WCAlertView *alertView) {
    //
    //        } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
    //            if (buttonIndex == 0) {
    //
    //            }else{
    //                [self dismiss:YES];
    //            }
    //        } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    //    }
    
    BOOL isEditing = [self isEditingInfo];
    if (!isEditing) {
        UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"存草稿箱",@"不存草稿箱", nil];
        [actionSheet showInView:self.view];
    }else{
        [self dismiss:YES];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self saveDraft];
    }else{
        [self dismiss:YES];
    }
}

-(void)saveDraft
{
    
    
    [super showProcessingHUD:nil];
    WEAKSELF;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSArray *picItemArray = [_picturesEditView picItemsArray];
        NSMutableArray *uploadFiles = [[NSMutableArray alloc] init];
        for (NSInteger i=0;i<[picItemArray count];i++) {
            PictureItem *item = [picItemArray objectAtIndex:i];
            if (item.picId == kPictureItemLocalPicId) {
                [uploadFiles addObject:item.picUrl];
            }else{
                NSString * picUrl = [self loadPictrue:item.picUrl];
                [uploadFiles addObject:picUrl];
                item.picId = kPictureItemLocalPicId;
            }
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideHUD];
            if ([uploadFiles count]>0) {
                [weakSelf savePublishGoods:uploadFiles];
            } else {
                [weakSelf savePublishGoods:nil];
            }
        });
    });
    
}


-(NSString *)loadPictrue:(NSString *)urlString{
    
    NSString * filePath;
    UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]]];
    filePath = [AppDirs savePublishGoodsPicture:image fileName:nil];
    return filePath;
}

- (void)savePublishGoods:(NSArray*)picUrlArray {
    WEAKSELF;
    NSArray *picItemArray = [_picturesEditView picItemsArray];
    NSInteger index = 0;
    for (PictureItem *item in picItemArray) {
        if (item.picId == kPictureItemLocalPicId) {
            if (index < [picUrlArray count]) {
                item.picUrl = [picUrlArray objectAtIndex:index];
            }
            index+=1;
        }
    }
    NSMutableArray *gallery = [[NSMutableArray alloc] init];
    for (NSInteger i=0;i<[picItemArray count];i++) {
        PictureItem *item = [picItemArray objectAtIndex:i];
        if (i==0) {
            self.editableInfo.mainPicItem = item;
        } else {
            [gallery addObject:item];
        }
    }
    self.editableInfo.gallary = gallery;
    
    for (NSInteger i = 0; i < [picItemArray count]; i++) {
        PictureItem *item = [picItemArray objectAtIndex:i];
        if (item.isCer) {
            [self.editableInfo.voucherPictures addObject:item];
        }
    }
    BOOL flag = NO;
    for (NSInteger i = 0; i < self.editableInfo.voucherPictures.count; i++) {
        PictureItem *itemTemp = [[PictureItem alloc] initWithDict:self.editableInfo.voucherPictures[i]];
        for (NSInteger j = 0; j < picItemArray.count; j++) {
            PictureItem *item = [picItemArray objectAtIndex:j];
            if ([item.picUrl isEqualToString:itemTemp.picUrl]) {
                flag = YES;
                break;
            } else {
                
            }
        }
        if (!flag) {
            [self.editableInfo.voucherPictures removeObjectAtIndex:i];
            i--;
            flag = NO;
        }
        
    }
    
    self.editableInfo.categoryId = self.selectedCate.cateId;
    self.editableInfo.categoryName = self.selectedCate.name;
    self.editableInfo.brandId = self.selectedBrandInfo.brandId;
    self.editableInfo.brandName = self.selectedBrandInfo.brandName;
    self.editableInfo.brandEnName = self.selectedBrandInfo.brandEnName;
    self.editableInfo.shopPrice = self.jianyiPrice.doubleValue;
    self.editableInfo.shopPriceCent = self.jianyiPrice.doubleValue*100;
    self.editableInfo.marketPrice = self.yuanPrice.doubleValue;
    self.editableInfo.marketPriceCent = self.yuanPrice.doubleValue*100;
    self.editableInfo.summary = self.descText;
    self.editableInfo.grade = [self getGradeNum:self.grade];
    self.editableInfo.goodsName = self.goodsName;
    self.editableInfo.expected_delivery_type = self.sendTime;
    
    NSMutableArray *list = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.attrList.count; i++) {
        PublishAttrInfo *pubAttrInfo = self.attrList[i];
        if (self.dict[[NSString stringWithFormat:@"%ld", pubAttrInfo.attr_id]]) {
            AttrEditableInfo *attrNewInfo = self.dict[[NSString stringWithFormat:@"%ld", pubAttrInfo.attr_id]];
            [list addObject:attrNewInfo];
        }
    }
    weakSelf.attrInfoList = list;
    self.editableInfo.attrInfoList = weakSelf.attrInfoList;
    
    [[Session sharedInstance] savePublishGoodsToDraft:self.editableInfo];
    [self dismiss:YES];
    
}

- (BOOL)isEditingInfo
{
    BOOL isValid = NO;
    
    NSArray *picItemsArray = [_picturesEditView picItemsArray];
    if (!self.selectedCate &&
        !self.selectedBrandInfo &&
        [self getGradeNum:self.grade] == -1 &&
        self.dioahuoPrice.length == 0 &&
        [picItemsArray count]==0 &&
        self.yuanPrice.length == 0 &&
        self.descText.length == 0) {
        
        isValid = YES;
    }
    
    return isValid;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)configCollectionView {
    WEAKSELF;
    _layout = [[LxGridViewFlowLayout alloc] init];
    _margin = 0;
    _itemWH = (self.view.tz_width - 2 * _margin - 4) / 3 - _margin;
    _layout.itemSize = CGSizeMake((kScreenWidth-(15*2+5*2))/3, (kScreenWidth-(15*2+5*2))/3);
    _layout.minimumInteritemSpacing = 5;//_margin;
    _layout.minimumLineSpacing = 5;//_margin;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(_margin, 0, self.view.tz_width - 2 * _margin, ((400-10)/3)*(_selectedPhotos.count/3)) collectionViewLayout:_layout];
    
    CGFloat rgb = 244 / 255.0;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.contentInset = UIEdgeInsetsMake(5, 15, 0, 15);
    _collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, -2);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
    
//    _picturesEditView = [[PictureItemsEditViewForPublishGoods alloc] initWithFrame:CGRectMake(_margin, 0, self.view.tz_width - 2 * _margin, ((400-10)/3)*(_selectedPhotos.count/3)) isShowMainPicTip:YES isHaveFengM:NO]; //若要显示拍卖技巧购物凭证 isHaveFengM设置为YES
    _picturesEditView = [[PictureItemsEditViewForPublishGoods alloc] initWithFrame:CGRectMake(_margin, 0, self.view.tz_width - 2 * _margin, ((400-10)/3)*(_selectedPhotos.count/3)) isShowMainPicTip:YES];
    _picturesEditView.contentView = self;
    _picturesEditView.backgroundColor = [UIColor whiteColor];
    _picturesEditView.viewController = self;
    _picturesEditView.delegate = self;
    _picturesEditView.isEdit = NO;
    
    _addPicButton = [[VerticalCommandButton alloc] initWithFrame:_picturesEditView.bounds];
    _addPicButton.backgroundColor = [UIColor whiteColor];
    [_addPicButton setImage:[UIImage imageNamed:@"publish_add_pic"] forState:UIControlStateNormal];
    [_addPicButton setTitle:@"添加图片" forState:UIControlStateNormal];
    _addPicButton.contentMarginTop = 30;
    _addPicButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_addPicButton setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
    _addPicButton.imageTextSepHeight = 6;
    _addPicButton.handleClickBlock = ^(CommandButton *sender){
        [weakSelf.picturesEditView addPics:0];
    };
    [_picturesEditView addSubview:_addPicButton];
    if (self.picItemsArray.count > 0) {
        if (self.isResell || self.isFromDraft) {
            _picturesEditView.isEdit = NO;
        }else{
            _picturesEditView.isEdit = YES;
        }
        _addPicButton.hidden = YES;
        _picturesEditView.picItemsArray = self.picItemsArray;
        
    }else{
       _addPicButton.hidden = NO;
    }
    _picturesEditView.handleAddPicActionBlock = ^(NSInteger userData) {
        NSInteger cateId = weakSelf.selectedCate?weakSelf.selectedCate.cateId:weakSelf.editableInfo.categoryId;
        TakePhotoViewController *viewController = [[TakePhotoViewController alloc] init];
        viewController.title = weakSelf.selectedCate?weakSelf.selectedCate.name:@"";
        viewController.userData = userData;
        viewController.cateId = cateId;
        viewController.sampleList = [weakSelf.sampleListDict objectForKey:[NSNumber numberWithInteger:cateId]];;
        viewController.handleImagePicked = ^(NSInteger userData, UIImage *image, NSString *filePath) {
            [weakSelf.picturesEditView handleImagePicked:userData image:image filePath:filePath];
        };
        viewController.handleSampleListFetchedBlock = ^(NSInteger caiteId, NSArray *sampleList) {
            [weakSelf.sampleListDict setObject:[NSNumber numberWithInteger:cateId] forKey:sampleList];
        };
        [weakSelf pushViewController:viewController animated:YES];
    };
    
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.publishBtn];
    
    [self.view addSubview:self.pickerBgView];
    [self.pickerBgView addSubview:self.pickerView];
    [self.view addSubview:self.pickerCanCelBtn];
    [self.view addSubview:self.pickerDownBtn];
    
    
    self.publishBtn.buttonClick = ^(){
        if (!weakSelf.isAgreement) {
            [weakSelf showHUD:@"请先阅读爱丁猫协议" hideAfterDelay:0.8];
        }else{
            [weakSelf clickPublishBtn];
        }
    };
    
    
    //    [self.publishBtn addTarget:self action:@selector(clickPublishBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.pickerDownBtn addTarget:self action:@selector(clickPickerDownBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.pickerCanCelBtn addTarget:self action:@selector(clickPickerCanCelBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [self setUpUI];
    [self loadCell];
}

-(void)showPhotoShootTechniqueView{
    
    WEAKSELF;
    [self.view addSubview:self.promptView];
    [UIView animateWithDuration:0.25 animations:^{
        self.promptView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    }];
    self.promptView.disPublishPrompt = ^(){
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.promptView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
        } completion:^(BOOL finished) {
            [weakSelf.promptView removeFromSuperview];
        }];
    };
    
}

-(void)clickPublishBtn{
    
    BOOL isValid = [self saveEditInfo];
    if (!isValid) {
        NSArray *picItemArray = [_picturesEditView picItemsArray];
        if (picItemArray.count == 0) {
            [self showHUD:@"请至少提供一个主图" hideAfterDelay:0.8f];
        } else {
            [self showHUD:@"请检查有必填项未填写" hideAfterDelay:0.8f];
        }
        return;
    }
    
    for (int i = 0; i < self.attrList.count; i++) {
        PublishAttrInfo *pubAttrInfo = self.attrList[i];
        if (self.dict[[NSString stringWithFormat:@"%ld", pubAttrInfo.attr_id]]) {
//            AttrEditableInfo *attrNewInfo = self.dict[[NSString stringWithFormat:@"%ld", pubAttrInfo.attr_id]];
            
        } else {
//            if (pubAttrInfo.is_must == 1) {
//                [self showHUD:[NSString stringWithFormat:@"请完善必填项[%@]", pubAttrInfo.attr_name] hideAfterDelay:1.8f];
//                return;
//            }
        }
    }
    
    NSArray *picItemArray = [_picturesEditView picItemsArray];
    // add code
    
    
    NSMutableArray *uploadFiles = [[NSMutableArray alloc] init];
    for (NSInteger i=0;i<[picItemArray count];i++) {
        PictureItem *item = [picItemArray objectAtIndex:i];
        if (item.picId == kPictureItemLocalPicId) {
            [uploadFiles addObject:item.picUrl];
        }
    }
    WEAKSELF;
    [weakSelf showProcessingHUD:nil];
    if ([uploadFiles count]>0) {
        [[NetworkAPI sharedInstance] updaloadPics:uploadFiles completion:^(NSArray *picUrlArray) {
            [weakSelf publishGoods:picUrlArray];
        } failure:^(XMError *error) {
            [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
        }];
    } else {
        [weakSelf publishGoods:nil];
    }
}

- (void)publishGoods:(NSArray*)picUrlArray {
    WEAKSELF;
    NSArray *picItemArray = [_picturesEditView picItemsArray];
    NSInteger index = 0;
    for (PictureItem *item in picItemArray) {
        if (item.picId == kPictureItemLocalPicId) {
            if (index < [picUrlArray count]) {
                item.picUrl = [picUrlArray objectAtIndex:index];
            }
            index+=1;
        }
    }
    NSMutableArray *gallery = [[NSMutableArray alloc] init];
    for (NSInteger i=0;i<[picItemArray count];i++) {
        PictureItem *item = [picItemArray objectAtIndex:i];
        if (item.picId == kPictureItemLocalPicId) {
            item.picId = 0;
        }
        if (i==0) {
            self.editableInfo.mainPicItem = item;
        } else {
            [gallery addObject:item];
        }
    }
    self.editableInfo.gallary = gallery;
    
    //    NSMutableArray *cretArr = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < [picItemArray count]; i++) {
        PictureItem *item = [picItemArray objectAtIndex:i];
        if (item.isCer) {
            [self.editableInfo.voucherPictures addObject:item];
        }
    }
    BOOL flag = NO;
    for (NSInteger i = 0; i < self.editableInfo.voucherPictures.count; i++) {
        PictureItem *itemTemp = [[PictureItem alloc] initWithDict:self.editableInfo.voucherPictures[i]];
        for (NSInteger j = 0; j < picItemArray.count; j++) {
            PictureItem *item = [picItemArray objectAtIndex:j];
            if ([item.picUrl isEqualToString:itemTemp.picUrl]) {
                flag = YES;
                break;
            } else {
                
            }
        }
        if (!flag) {
            [self.editableInfo.voucherPictures removeObjectAtIndex:i];
            i--;
            flag = NO;
        }
        
    }
    
    self.publishBtn.userInteractionEnabled = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"endEdit" object:nil];
    //    _editableInfo.voucherPictures = cretArr;
    self.editableInfo.categoryId = self.selectedCate.cateId;
    self.editableInfo.categoryName = self.selectedCate.name;
    self.editableInfo.brandId = self.selectedBrandInfo.brandId;
    self.editableInfo.brandName = self.selectedBrandInfo.brandName;
    self.editableInfo.brandEnName = self.selectedBrandInfo.brandEnName;
    //    self.editableInfo.diaohuo_price = self.dioahuoPrice.doubleValue;
    self.editableInfo.shopPrice = self.jianyiPrice.doubleValue;
    self.editableInfo.shopPriceCent = self.jianyiPrice.doubleValue*100;
    self.editableInfo.marketPrice = self.yuanPrice.doubleValue;
    self.editableInfo.marketPriceCent = self.yuanPrice.doubleValue*100;
    self.editableInfo.summary = self.descText;
    self.editableInfo.grade = self.gradeId;//[self getGradeNum:self.grade];
    self.editableInfo.goodsName = self.goodsName;
    self.editableInfo.expected_delivery_type = self.sendTime;
    if (self.isResell) {
        self.editableInfo.goodsId = @"";
        self.editableInfo.orderId = self.orderId;
    }
    
    NSMutableArray *list = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.attrList.count; i++) {
        PublishAttrInfo *pubAttrInfo = self.attrList[i];
        if (self.dict[[NSString stringWithFormat:@"%ld", pubAttrInfo.attr_id]]) {
            AttrEditableInfo *attrNewInfo = self.dict[[NSString stringWithFormat:@"%ld", pubAttrInfo.attr_id]];
            [list addObject:attrNewInfo];
        }
    }
    weakSelf.attrInfoList = list;
    NSLog(@"%@", weakSelf.attrInfoList);
    self.editableInfo.attrInfoList = weakSelf.attrInfoList;
    
    NSNumber *num = [NSNumber numberWithInteger:0];
    NSDictionary * parm = @{@"publish_type":num};
    NSLog(@"goodsId ==  %@",weakSelf.editableInfo.goodsId);
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"goods" path:@"publish_check_v2" parameters:parm completionBlock:^(NSDictionary *data) {
        self.publishBtn.userInteractionEnabled = YES;
        publishCheckModel * model = [publishCheckModel createWithDict:data];
        //0 跳转APPSTORE 1 发布商品      pop0 不弹框 1 弹窗
        if (model.pop == 1) {
            [WCAlertView showAlertWithTitle:nil message:[NSString stringWithFormat:@"%@.\n%@",model.msg,model.buttonTxt] customizationBlock:^(WCAlertView *alertView) {
                
            } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                [weakSelf hideHUD];
                if (buttonIndex == 0) {
                    
                }else{
                    
                    if (model.qualification == 0) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.buttonUrl]];
                    }else if (model.qualification == 1){
                        [weakSelf publishGoods];
                    }
                }
                
            } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        }else if (model.pop == 0){
            [weakSelf publishGoods];
        }
        
        
    } failure:^(XMError *error) {
        [self showHUD:[error errorMsg] hideAfterDelay:0.8];
        self.publishBtn.userInteractionEnabled = YES;
    } queue:nil]];
    
}

-(void)publishGoods
{
    WEAKSELF;
    NSNumber *num;
    if (self.isResell) {
        num = [NSNumber numberWithInteger:3];
    }else{
        num = [NSNumber numberWithInteger:0];
    }
    NSInteger userId = [Session sharedInstance].currentUser?[Session sharedInstance].currentUserId:0;
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId], @"goods_editable_info":self.editableInfo?[self.editableInfo toDictionary]:@"", @"publish_type" : num,@"order_id":self.orderId?self.orderId:@""};//publishType 0 担保商品 1 求回收商品 2 云仓商品(22)
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodPOST:@"goods" path:@"publish_v2" parameters:parameters completionBlock:^(NSDictionary *data) {
        self.publishBtn.userInteractionEnabled = YES;
        if (data[@"goods_id"]) {
            weakSelf.editableInfo.goodsId = data[@"goods_id"];
        }
        [weakSelf dismiss];
        if (weakSelf.handlePublishGoodsFinished) {
            weakSelf.handlePublishGoodsFinished(weakSelf.editableInfo);
        }
        [[CoordinatingController sharedInstance] showHUD:@"发布成功" hideAfterDelay:1.6];
        
    } failure:^(XMError *error) {
        self.publishBtn.userInteractionEnabled = YES;
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8];
    } queue:nil]];
    
    //如果是发布草稿箱的商品,就把草稿箱删除
    if (self.isFromDraft) {
        [AppDirs removeFile:[AppDirs publishGoodsCacheFile]];
    }
    
    NSLog(@"%@", self.editableInfo);
}

-(NSInteger)getGradeNum:(NSString *)text{
    NSInteger index = -1;
    
    if ([text isEqualToString:@"N1"]) {
        index = 1;
    } else if ([text isEqualToString:@"N2"]) {
        index = 5;
    } else if ([text isEqualToString:@"N3"]) {
        index = 2;
    } else if ([text isEqualToString:@"S1"]) {
        index = 7;
    } else if ([text isEqualToString:@"S2"]) {
        index = 3;
    } else if ([text isEqualToString:@"B1"]) {
        index = 6;
    } else if ([text isEqualToString:@"B2"]) {
        index = 4;
    }
    
    return index;
}

-(NSString *)gradeText:(NSInteger )grade{
    NSString *text = [[NSString alloc] init];
    switch (grade) {
        case 1:
            text = @"N1";
            break;
        case 5:
            text = @"N2";
            break;
        case 2:
            text = @"N3";
            break;
        case 7:
            text = @"S1";
            break;
        case 3:
            text = @"S2";
            break;
        case 6:
            text = @"B1";
            break;
        case 4:
            text = @"B2";
            break;
        default:
            break;
    }
    return text;
}


- (void)picturesEditViewHeightChanged:(PictureItemsEditView*)view height:(CGFloat)height{
    dispatch_async(dispatch_get_main_queue(), ^{
        _picturesEditView.frame = CGRectMake(0, 12, kScreenWidth, height);
        _addPicButton.frame = _picturesEditView.bounds;
        self.tableView.tableHeaderView = _picturesEditView;
    });
    //    [self setUpUI];
}

- (void)picturesEditViewPictureItemDeleted:(PictureItemsEditView*)view item:(PictureItem*)item{
    NSArray * arr = [view picItemsArray];
    [self hideTakePhotoButton:arr.count];
}
- (void)picturesEditViewPictureItemAdded:(PictureItemsEditView*)view{
    NSArray * arr = [view picItemsArray];
    [self hideTakePhotoButton:arr.count];
}

- (void)hideTakePhotoButton:(NSInteger)pictureItemCount{
    _addPicButton.hidden = pictureItemCount > 0 ? YES : NO;
}

-(void)loadCell{
    [self.dataSources removeAllObjects];
    [self.dataSources addObject:[SegTabViewCellSmallTwo buildCellDict]];
    [self.dataSources addObject:[PublishChooseCateCell buildCellDict:self.cateName]];
    
    [self.dataSources addObject:[SegTabViewCellSmallTwo buildCellDict]];
    [self.dataSources addObject:[PublishChooseBrandCell buildCellDict:self.brandName]];
    
    [self.dataSources addObject:[SegTabViewCellSmallTwo buildCellDict]];
    [self.dataSources addObject:[PublishChooseGradeCell buildCellDict:self.grade]];
    
    if (self.cateName.length>0 && self.brandName.length>0 && self.grade.length>0) {
        if (self.goodsId.length>0) {
            self.grade = [self gradeText:self.editableInfo.grade];
            self.cateName = self.editableInfo.categoryName;
            self.brandName = self.editableInfo.brandName;
            self.brandEnName = self.editableInfo.brandEnName;
        } else {
            NSMutableString *goodsNameStr = [[NSMutableString alloc] init];
            [goodsNameStr appendString:self.grade];
            [goodsNameStr appendString:@" "];
            [goodsNameStr appendString:self.brandName];
            [goodsNameStr appendString:@" "];
            [goodsNameStr appendString:self.cateName];
            [goodsNameStr appendString:@" "];
            self.goodsName = goodsNameStr;
        }
        [self.dataSources addObject:[SegTabViewCellSmallTwo buildCellDict]];
        [self.dataSources addObject:[PublishGoodsNameCell buildCellDict:self.goodsName cateName:self.cateName brandName:self.brandName grade:self.grade brandEnName:self.brandEnName]];
    }
    
    [self.dataSources addObject:[SegTabViewCellSmallTwo buildCellDict]];
    [self.dataSources addObject:[PublishDescriptionCell buildCellDict:self.goodsDesc andDesc:self.descText]];
    [self.dataSources addObject:[SepTableViewCell buildCellDict]];
    [self.dataSources addObject:[PublishPriceCell buildCellDict:self.yuanPrice diaohuoPrice:self.dioahuoPrice jianyiPrice:self.jianyiPrice]];
    //[self.dataSources addObject:[SegTabViewCellSmallTwo buildCellDict]];
    //    [self.dataSources addObject:[PublishMeasurementCell buildCellDict:self.longInt width:self.width height:self.height]];
    //    [self.dataSources addObject:[PublishAttachmentCell buildCellDict:nil]];
    //[self.dataSources addObject:[SepTableViewCell buildCellDict]];
    //[self.dataSources addObject:[AuthenticateFlowCell buildCellDict]];
    [self.dataSources addObject:[SepTableViewCell buildCellDict]];
    [self.dataSources addObject:[SendGoodsTimeCell buildCellDict:self.pickerTitle]];
    //    [self.dataSources addObject:[SegTabViewCellSmallTwo buildCellDict]];
    if (self.cateName.length > 0 && self.brandName.length > 0) {
        [self.dataSources addObject:[SepTableViewCell buildCellDict]];
        [self.dataSources addObject:[DetailParamCell buildCellDict:nil]];
        
        if (self.index == 0) {
            [self setUnMustCell];
        }
    }
    [self.dataSources addObject:[PublishAgreementCell buildCellDict]];
}

-(void)setUnMustCell{
    self.index = 1;
    for (int i = 0; i < self.attrList.count; i++) {
        PublishAttrInfo *attrInfo = self.attrList[i];
        if (attrInfo.placeholder && attrInfo.placeholder.length > 0) {
            [self.dataSources addObject:[PublishPromptCell buildCellText:attrInfo.placeholder]];
        }
        if (attrInfo.type == TYPE_SELECE) {
            [self.dataSources addObject:[ExpandCell buildCellDict:attrInfo dict:self.dict]];
        } else if (attrInfo.type == TYPE_TEXT_INPUT) {
            [self.dataSources addObject:[ExpandInputCell buildCellDict:attrInfo andAttrDict:self.dict]];
        } else if (attrInfo.type == TYPE_SIZE) {
            [self.dataSources addObject:[PublishMeasurementCell buildCellDict:attrInfo dict:self.dict]];
        } else if (attrInfo.type == TYPE_COLOR) {
            [self.dataSources addObject:[ExpandColorCell buildCellDict:attrInfo andDict:self.dict]];
        } else if (attrInfo.type == TYPE_MATCH) {
            [self.dataSources addObject:[ExpandYiJianCell buildCellDict:attrInfo brandId:self.selectedBrandInfo.brandId cateId:self.selectedCate.cateId]];
        }
        
    }
}

-(void)setUpUI{
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBar.mas_bottom).offset(0.5);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-65);
    }];

    if (_selectedPhotos.count < 3) {
        _collectionView.frame = CGRectMake(_margin, 0, self.view.tz_width - 2 * _margin, ((400-10)/3)*(3/3));
    } else if (_selectedPhotos.count == 9) {
        _collectionView.frame = CGRectMake(_margin, 0, self.view.tz_width - 2 * _margin, ((400-28)/3)*((_selectedPhotos.count/3)));
    } else {
        _collectionView.frame = CGRectMake(_margin, 0, self.view.tz_width - 2 * _margin, ((400-28)/3)*((_selectedPhotos.count/3)+1));
    }
    
    if (self.editPublish == 0) {
        _picturesEditView.frame = CGRectMake(0, 12, kScreenWidth, [PictureItemsEditView itemViewHeight]+40);
        _addPicButton.frame  = _picturesEditView.bounds;
        self.tableView.tableHeaderView = _picturesEditView;
    }
    
    [self.pickerCanCelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pickerView.mas_top);
        make.left.equalTo(self.pickerView.mas_left).offset(12);
    }];
    
    [self.pickerDownBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pickerView.mas_top);
        make.right.equalTo(self.pickerView.mas_right).offset(-12);
    }];
    
    [self.publishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.tableView.mas_bottom);
    }];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"endEdit" object:nil];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //    [self.view endEditing:YES];
    [self pickerViewDisMiss];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_tableView scrollViewDidEndDragging:scrollView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSources.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    WEAKSELF;
    Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:dict];
    NSString *reuseIdentifier = [ClsTableViewCell reuseIdentifier];
    
    BaseTableViewCell *tableViewCell = (BaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (tableViewCell == nil) {
        tableViewCell = [[ClsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        [tableViewCell setBackgroundColor:[UIColor whiteColor]];
        [tableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    if ([tableViewCell isKindOfClass:[PublishDescriptionCell class]]) {
        PublishDescriptionCell *descCell = (PublishDescriptionCell*)tableViewCell;
        descCell.returnText = ^(NSString *textViewText){
            weakSelf.descText = textViewText;
        };
    } else if ([tableViewCell isKindOfClass:[PublishAgreementCell class]]) {
        PublishAgreementCell *agreementCell = (PublishAgreementCell*)tableViewCell;
        agreementCell.handleCircleBtnClickBlock =^(BOOL isYES){
            weakSelf.isAgreement = isYES;
        };
    } else if ([tableViewCell isKindOfClass:[ExpandCell class]]) {
        ExpandCell *expandCell = (ExpandCell*)tableViewCell;
        
        expandCell.getAttrInfo = ^(CommandButton *sender, NSInteger isMutChoose){
            
            if (sender.isMultiSelected == 1) {
                if (weakSelf.dict[[NSString stringWithFormat:@"%ld", sender.attrId]]) {
                    AttrEditableInfo *attrInfo = self.dict[[NSString stringWithFormat:@"%ld", sender.attrId]];
                    
                    if([attrInfo.attrValue rangeOfString:sender.titleLabel.text].location !=NSNotFound){
                        NSMutableString *mutStr = [[NSMutableString alloc] init];
                        NSArray *array= [attrInfo.attrValue componentsSeparatedByString:@","];
                        NSMutableArray *mutArr = [[NSMutableArray alloc] initWithArray:array];
                        for (int i = 0; i < mutArr.count; i++) {
                            NSString *str = mutArr[i];
                            if ([str isEqualToString:sender.titleLabel.text]) {
                                [mutArr removeObject:str];
                            }
                        }
                        
                        for (int i = 0; i < mutArr.count; i++) {
                            NSString *str = mutArr[i];
                            if ([str isEqualToString:@","]) {
                                
                            } else {
                                [mutStr appendString:str];
                                if (str.length == 0) {
                                    
                                } else {
                                    if (i < mutArr.count - 1) {
                                        [mutStr appendString:SPERSTR];
                                    }
                                }
                            }
                        }
                        
                        attrInfo.attrValue = mutStr;
                        NSLog(@"%@", mutArr);
                        NSLog(@"%@", attrInfo.attrValue);
                        return;
                    }
                    
                    NSMutableString *str = [[NSMutableString alloc] init];
                    [str appendString:attrInfo.attrValue];
                    if (str.length == 0) {
                        
                    } else {
                        [str appendString:SPERSTR];
                    }
                    [str appendString:sender.titleLabel.text];
                    attrInfo.attrValue = str;
                    NSLog(@"%@", attrInfo.attrValue);
                } else {
                    AttrEditableInfo *attrInfo = [[AttrEditableInfo alloc] init];
                    attrInfo.attrId = sender.attrId;
                    attrInfo.attrValue = sender.titleLabel.text;
                    [weakSelf.dict setObject:attrInfo forKey:[NSString stringWithFormat:@"%ld", sender.attrId]];
                    NSLog(@"%@", attrInfo.attrValue);
                }
            } else {
                if (weakSelf.dict[[NSString stringWithFormat:@"%ld", sender.attrId]]) {
                    AttrEditableInfo *attrInfo = weakSelf.dict[[NSString stringWithFormat:@"%ld", sender.attrId]];
                    if ([attrInfo.attrValue isEqualToString:sender.titleLabel.text]) {
                        [weakSelf.dict removeObjectForKey:[NSString stringWithFormat:@"%ld", sender.attrId]];
                    } else {
                        attrInfo.attrValue = sender.titleLabel.text;
                    }
                } else {
                    AttrEditableInfo *attrInfo = [[AttrEditableInfo alloc] init];
                    attrInfo.attrId = sender.attrId;
                    attrInfo.attrValue = sender.titleLabel.text;
                    [weakSelf.dict setObject:attrInfo forKey:[NSString stringWithFormat:@"%ld", sender.attrId]];
                }
            }
            //            [self.dict setObject:@(sender.attrId) forKey:@(sender.attrId)];
            //            [self.dict setObject:sender.titleLabel.text forKey:@"attrText"];
            NSLog(@"%@", weakSelf.dict);
        };
    } else if ([tableViewCell isKindOfClass:[ExpandColorCell class]]) {
        ExpandColorCell *expandColorCell = (ExpandColorCell*)tableViewCell;
        expandColorCell.clickColor = ^(XMWebImageView *sender){
            
            if (sender.isMutCho == 0) {
                if (weakSelf.dict[[NSString stringWithFormat:@"%ld", sender.attrId]]) {
                    AttrEditableInfo *attrInfo = weakSelf.dict[[NSString stringWithFormat:@"%ld", sender.attrId]];
                    if ([attrInfo.attrValue isEqualToString:sender.valueName]) {
                        [weakSelf.dict removeObjectForKey:[NSString stringWithFormat:@"%ld", sender.attrId]];
                    } else {
                        attrInfo.attrValue = sender.valueName;
                    }
                } else {
                    AttrEditableInfo *attrInfo = [[AttrEditableInfo alloc] init];
                    attrInfo.attrId = sender.attrId;
                    attrInfo.attrValue = sender.valueName;
                    [weakSelf.dict setObject:attrInfo forKey:[NSString stringWithFormat:@"%ld", sender.attrId]];
                }
            }
            NSLog(@"%@", weakSelf.dict);
            
        };
    } else if ([tableViewCell isKindOfClass:[ExpandInputCell class]]) {
        ExpandInputCell *expandInputCell = (ExpandInputCell*)tableViewCell;
        expandInputCell.returnInputTextField = ^(NSString *text, NSInteger attrId){
            if (weakSelf.dict[[NSString stringWithFormat:@"%ld", attrId]]) {
                AttrEditableInfo *attrInfo = weakSelf.dict[[NSString stringWithFormat:@"%ld", attrId]];
                //                if ([attrInfo.attrValue isEqualToString:text]) {
                //                    [self.dict removeObjectForKey:[NSString stringWithFormat:@"%ld", attrId]];
                //                } else {
                attrInfo.attrValue = text;
                //                }
            } else {
                AttrEditableInfo *attrInfo = [[AttrEditableInfo alloc] init];
                attrInfo.attrId = attrId;
                attrInfo.attrValue = text;
                [weakSelf.dict setObject:attrInfo forKey:[NSString stringWithFormat:@"%ld", attrId]];
            }
        };
    } else if ([tableViewCell isKindOfClass:[ExpandYiJianCell class]]) {
        ExpandYiJianCell *yijianCell = (ExpandYiJianCell*)tableViewCell;
        yijianCell.yijianpipei = ^(NSMutableDictionary *dict){
            weakSelf.dict = dict;
            [weakSelf reloadData];
        };
        yijianCell.yijianEndEdit = ^(NSString *text, NSInteger attrId){
            if (weakSelf.dict[[NSString stringWithFormat:@"%ld", attrId]]) {
                AttrEditableInfo *attrInfo = weakSelf.dict[[NSString stringWithFormat:@"%ld", attrId]];
                //                if ([attrInfo.attrValue isEqualToString:text]) {
                //                    [self.dict removeObjectForKey:[NSString stringWithFormat:@"%ld", attrId]];
                //                } else {
                attrInfo.attrValue = text;
                //                }
            } else {
                AttrEditableInfo *attrInfo = [[AttrEditableInfo alloc] init];
                attrInfo.attrId = attrId;
                attrInfo.attrValue = text;
                [weakSelf.dict setObject:attrInfo forKey:[NSString stringWithFormat:@"%ld", attrId]];
            }
        };
    } else if ([tableView isKindOfClass:[PublishMeasurementCell class]]) {
        PublishMeasurementCell *measureCell = (PublishMeasurementCell*)tableViewCell;
        
    } else if ([tableView isKindOfClass:[PublishGoodsNameCell class]]) {
        PublishGoodsNameCell *goodsNameCell = (PublishGoodsNameCell*)tableViewCell;
        //        goodsNameCell.downGoodsName = ^(NSString *goodsName){
        //            weakSelf.goodsName = goodsName;
        //        };
        //        goodsNameCell.goodsNameDelegate = self;
    }
    
    [tableViewCell updateCellWithDict:dict];
    return tableViewCell;
}

-(void)getGoodsName:(NSNotification *)notify{
    NSDictionary *dict3 = notify.object;
    self.goodsName = dict3[@"goodsName"];
    NSLog(@"%@", self.goodsName);
}

-(void)inputTextField:(NSNotification *)notify{
    NSDictionary *dict = notify.object;
    NSArray *textFArr = dict[@"textFidleArr"];
    NSNumber *attrId = dict[@"attr_id"];
    NSMutableString *str = [[NSMutableString alloc] init];
    for (int i = 0; i < textFArr.count; i++) {
        
        UITextField *textField = textFArr[i];
        if (textField.text.length == 0) {
            return;
        }
        [str appendString:textField.text];
        if (i < textFArr.count - 1) {
            [str appendString:@"X"];
        }
        NSLog(@"%@", str);
        if (self.dict[[NSString stringWithFormat:@"%ld", attrId.integerValue]]) {
            AttrEditableInfo *attrInfo = self.dict[[NSString stringWithFormat:@"%ld", attrId.integerValue]];
            //                if ([attrInfo.attrValue isEqualToString:text]) {
            //                    [self.dict removeObjectForKey:[NSString stringWithFormat:@"%ld", attrId]];
            //                } else {
            attrInfo.attrValue = str;
            //                }
        } else {
            AttrEditableInfo *attrInfo = [[AttrEditableInfo alloc] init];
            attrInfo.attrId = attrId.integerValue;
            attrInfo.attrValue = str;
            [self.dict setObject:attrInfo forKey:[NSString stringWithFormat:@"%ld", attrId.integerValue]];
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    
    if (ClsTableViewCell == [PublishChooseCateCell class]) {
        [self pulishSelectCate:self.cateList];
    } else if (ClsTableViewCell == [PublishChooseBrandCell class]) {
        [self publishSelectBrand:self.brandList];
    } else if (ClsTableViewCell == [PublishChooseGradeCell class]) {
        WEAKSELF;
        if (!self.selectedCate) {
            [WCAlertView showAlertWithTitle:@""
                                    message:@"请先选择商品类目"
                         customizationBlock:^(WCAlertView *alertView) {
                             alertView.style = WCAlertViewStyleWhite;
                         } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                             [weakSelf pulishSelectCate:weakSelf.cateList];
                         } cancelButtonTitle:@"确定" otherButtonTitles:nil];
        } else {
            PublishChooseGradeViewController *controller = [[PublishChooseGradeViewController alloc] init];
            controller.cateId = self.selectedCate.cateId;
            controller.gradeDelegate = self;
            controller.grade = self.grade;
            controller.cateName = self.cateName;
            [self pushViewController:controller animated:YES];
        }
    } else if (ClsTableViewCell == [PublishMeasurementCell class]) {
        //        [self priceTapAction];
    } else if (ClsTableViewCell == [SendGoodsTimeCell class]) {
        [self pickerViewAppear];
    }else if (ClsTableViewCell == [PublishPriceCell class]){
        
        [self.view bringSubviewToFront:self.priceKeyboardView];
        [self.priceKeyboardView.yuanjiaTf becomeFirstResponder];
        [UIView animateWithDuration:0.25 animations:^{
            self.blackView.alpha = 0.6;
            self.priceKeyboardView.frame = CGRectMake(0, kScreenHeight-56, kScreenWidth, 56);
        }];
    }
    
//取消点击收起
//else if (ClsTableViewCell == [DetailParamCell class]) {
//        if (self.index == 0) {
//            self.index = 1;
//            for (int i = 0; i < self.attrList.count; i++) {
//                PublishAttrInfo *attrInfo = self.attrList[i];
//                if (attrInfo.placeholder && attrInfo.placeholder.length > 0) {
//                    [self.dataSources addObject:[PublishPromptCell buildCellText:attrInfo.placeholder]];
//                }
//                if (attrInfo.type == TYPE_SELECE) {
//                    [self.dataSources addObject:[ExpandCell buildCellDict:attrInfo dict:self.dict]];
//                } else if (attrInfo.type == TYPE_TEXT_INPUT) {
//                    [self.dataSources addObject:[ExpandInputCell buildCellDict:attrInfo andAttrDict:self.dict]];
//                } else if (attrInfo.type == TYPE_SIZE) {
//                    [self.dataSources addObject:[PublishMeasurementCell buildCellDict:attrInfo dict:self.dict]];
//                } else if (attrInfo.type == TYPE_COLOR) {
//                    [self.dataSources addObject:[ExpandColorCell buildCellDict:attrInfo andDict:self.dict]];
//                } else if (attrInfo.type == TYPE_MATCH) {
//                    [self.dataSources addObject:[ExpandYiJianCell buildCellDict:attrInfo brandId:self.selectedBrandInfo.brandId cateId:self.selectedCate.cateId]];
//                }
//                
//            }
//            //            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:10 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
//            [UIView animateWithDuration:0.25 animations:^{
//                self.tableView.contentOffset = CGPointMake(0, (375/kScreenWidth)*(kScreenHeight/2));
//                [self.tableView reloadData];
//            }];
//        } else {
//            self.index = 0;
//            for (int i = 0; i < self.attrList.count; i++) {
//                PublishAttrInfo *attrInfo = self.attrList[i];
//                if (attrInfo.type == TYPE_SELECE) {
//                    [self.dataSources removeObject:[ExpandCell buildCellDict:attrInfo dict:self.dict]];
//                } else if (attrInfo.type == TYPE_TEXT_INPUT) {
//                    [self.dataSources removeObject:[ExpandInputCell buildCellDict:attrInfo andAttrDict:self.dict]];
//                } else if (attrInfo.type == TYPE_SIZE) {
//                    [self.dataSources removeObject:[PublishMeasurementCell buildCellDict:attrInfo dict:self.dict]];
//                } else if (attrInfo.type == TYPE_COLOR) {
//                    [self.dataSources removeObject:[ExpandColorCell buildCellDict:attrInfo andDict:self.dict]];
//                } else if (attrInfo.type == TYPE_MATCH) {
//                    [self.dataSources removeObject:[ExpandYiJianCell buildCellDict:attrInfo brandId:self.selectedBrandInfo.brandId cateId:self.selectedCate.cateId]];
//                }
//                
//            }
//            [UIView animateWithDuration:0.25 animations:^{
//                [self.tableView reloadData];
//            }];
//        }
//    }
    
}

-(void)pickerViewAppear{
    self.pickerCanCelBtn.alpha = 0;
    self.pickerDownBtn.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.pickerCanCelBtn.alpha = 1;
        self.pickerDownBtn.alpha = 1;
        self.pickerBgView.frame = CGRectMake(0, kScreenHeight-200, kScreenWidth, 200);
    }];
}

-(void)pickerViewDisMiss{
    [UIView animateWithDuration:0.25 animations:^{
        self.pickerBgView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 200);
    }];
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.pickerArr.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    //    NSArray *arayM= self.pickerArr[component];
    //    //2.获取当前列对应的行的数据
    //    NSString *name=arayM[row];
    //    self.pickerTitle = [self.pickerArr objectAtIndex:row];
    
    return [self.pickerArr objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    self.sendIndex = row + 1;
    self.pickerTitle = [self.pickerArr objectAtIndex:row];
    
}

-(void)clickPickerDownBtn{
    self.sendTime = self.sendIndex;
    [self reloadData];
    [self pickerViewDisMiss];
}

-(void)clickPickerCanCelBtn{
    [self pickerViewDisMiss];
}

- (void)priceTapAction {
    //    WEAKSELF;
    //    if (weakSelf.selectedCate || weakSelf.editableInfo.categoryId>0) {
    //        DigitalPriceInputView *intputView = [[DigitalPriceInputView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    //        //交换
    //        intputView.shopPriceCent = weakSelf.editableInfo.marketPriceCent;
    //        intputView.marketPriceCent = weakSelf.editableInfo.shopPriceCent;
    //
    //        [DigitalKeyboardView showInViewFromPublish:weakSelf.view inputContainerView:intputView
    //                                    textFieldArray:[NSArray arrayWithObjects:intputView.priceTextField,intputView.marketPriceTextField,intputView.heightPriceTextField, nil] completion:^(DigitalInputContainerView *inputContainerView) {
    //                                        //因为修改了售价和买入价的位置, 这里做了互换
    //                                        NSInteger marketPriceCent = ((DigitalPriceInputView*)inputContainerView).shopPriceCent;
    //                                        NSInteger shopPriceCent = ((DigitalPriceInputView*)inputContainerView).marketPriceCent;
    //                                        NSInteger longInt = ((DigitalPriceInputView*)inputContainerView).longPriceCent;
    //
    //                                        self.height = longInt;
    //                                        self.width = shopPriceCent;
    //                                        self.longInt = marketPriceCent;
    //
    //                                        [self reloadData];
    //                                        weakSelf.editableInfo.shopPriceCent = shopPriceCent;
    //                                        weakSelf.editableInfo.marketPriceCent = marketPriceCent;
    //
    //
    //                                    }];
    //    } else {
    //        [WCAlertView showAlertWithTitle:@""
    //                                message:@"请先选择商品类目"
    //                     customizationBlock:^(WCAlertView *alertView) {
    //                         alertView.style = WCAlertViewStyleWhite;
    //                     } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
    //                         [weakSelf pulishSelectCate:weakSelf.cateList];
    //                     } cancelButtonTitle:@"确定" otherButtonTitles:nil];
    //
    //    }
}

-(void)getGrade:(NSString *)grade andDescInfo:(GradeDescInfo *)descInfo{
    self.grade = grade;
    self.gradeId = descInfo.gradeValue;
    //    for (int i = 0; i < self.dataSources.count; i++) {
    //        NSDictionary *dict = self.dataSources[i];
    //        NSLog(@"%@", dict);
    //        if ([dict[@"clsName"] isEqualToString:@"PublishChooseGradeCell"]) {
    //
    //        }
    //    }
    [self reloadData];
}

-(void)reloadData{
    self.index = 0;
    [self loadCell];
    [self.tableView reloadData];
}

-(void)getList{
    WEAKSELF;
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"category" path:@"get_goods_desc_options" parameters:@{@"cate_id":[NSNumber numberWithInteger:weakSelf.selectedCate.cateId]} completionBlock:^(NSDictionary *data) {
        //            NSLog(@"%@", data);
        
        NSArray *goodsDesc = data[@"get_goods_desc_options"];
        weakSelf.goodsDesc = goodsDesc;
        [weakSelf reloadData];
        
        [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"category" path:@"get_attr_list" parameters:@{@"cate_id":[NSNumber numberWithInteger:self.selectedCate.cateId]} completionBlock:^(NSDictionary *data) {
            [weakSelf hideLoadingView];
            
            NSArray *attrList = data[@"get_attr_list"];
            [weakSelf.attrList removeAllObjects];
            for (int i = 0; i < attrList.count; i++) {
                PublishAttrInfo *attrInfo = [PublishAttrInfo createWithDict:attrList[i]];
                NSLog(@"%@", attrInfo);
                [weakSelf.attrList addObject:attrInfo];
            }
            
        } failure:^(XMError *error) {
            [weakSelf hideLoadingView];
            [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8];
        } queue:nil]];
        
    } failure:^(XMError *error) {
        [weakSelf hideLoadingView];
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8];
    } queue:nil]];
}

- (void)publishDidSelect:(PublishSelectViewController*)viewController selectableItem:(PublishSelectableItem*)selectableItem
{
    WEAKSELF;
    void(^popToPulishController)() = ^{
        NSArray *viewControllers= viewController.navigationController.viewControllers;
        for (UIViewController *viewController in viewControllers) {
            if ([viewController isKindOfClass:[PublishViewController class]]) {
                [viewController.navigationController popToViewController:viewController animated:YES];
                break;
            }
        }
        
        [weakSelf getList];
        
    };
    
    if ([selectableItem.attachedItem isKindOfClass:[Cate class]]) {
        if ([((Cate*)selectableItem.attachedItem).children count]==0) {
            _selectedCate = (Cate*)selectableItem.attachedItem;
            self.cateName = selectableItem.title;
            self.brandName = nil;
            self.selectedBrandInfo = nil;
            //            [self reloadData];
            
            //            UILabel *lbl = (UILabel*)[_cateSelectorBtn viewWithTag:100];
            //            lbl.text = _selectedCate.name;
            //            if (self.editableInfo.categoryId!=_selectedCate.cateId) {
            //                self.tagGroupList = [NSArray array];
            //                self.brandList = [NSArray array];
            //                self.goods_name_sample = nil;
            //                self.poundage_explain = nil;
            //                self.poundage_cent = 0;
            //            }
            //            if ([self.goods_name_sample length]==0 || [self.poundage_explain length]==0 || self.poundage_cent==0) {
            //                [self reload_goods_publish_info:_selectedCate.cateId];
            //            }
            //            self.editableInfo.categoryId = _selectedCate.cateId;
            //            self.editableInfo.categoryName = _selectedCate.name;
            //            [_cateSelectorBtn setTitleColor:[UIColor colorWithHexString:@"181818"] forState:UIControlStateNormal];
            
            
            WEAKSELF;
            void(^reloadWithAttrInfoList)(NSArray *attrInfoList) = ^(NSArray *attrInfoList){
                if ([attrInfoList count]>0) {
                    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:attrInfoList.count];
                    for (AttrEditableInfo *editInfo in attrInfoList) {
                        BOOL isExist = NO;
                        for (AttrEditableInfo *tmp in weakSelf.editableInfo.attrInfoList) {
                            if (tmp.attrId == editInfo.attrId) {
                                isExist = YES;
                                [array addObject:tmp];
                                break;
                            }
                        }
                        if (!isExist) {
                            [array addObject:editInfo];
                        }
                    }
                    weakSelf.editableInfo.attrInfoList = array;
                    [weakSelf.cateAttrInfoDict setObject:array forKey:[NSNumber numberWithInteger:weakSelf.selectedCate.cateId]];
                    //                    [weakSelf saveEditInfo];
                    [weakSelf loadCell];
                } else {
                    weakSelf.editableInfo.attrInfoList = nil;
                    //                    [weakSelf saveEditInfo];
                    [weakSelf loadCell];
                }
            };
            NSArray *attrInfoList = [weakSelf.cateAttrInfoDict objectForKey:[NSNumber numberWithInteger:weakSelf.selectedCate.cateId]];
            if (attrInfoList) {
                reloadWithAttrInfoList(attrInfoList);
            } else {
                //                dispatch_async(dispatch_get_main_queue(), ^{
                //                    [weakSelf showProcessingHUD:nil];
                //                    [CategoryService getAttrInfoList:_selectedCate.cateId completion:^(NSArray *attrInfoList) {
                //                        [weakSelf hideHUD];
                //                        reloadWithAttrInfoList(attrInfoList);
                //                    } failure:^(XMError *error) {
                //                        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
                //                    }];
                //                });
            }
            popToPulishController();
        } else {
            [self pulishSelectCate:((Cate*)selectableItem.attachedItem).children];
        }
    }
    else if ([selectableItem.attachedItem isKindOfClass:[BrandInfo class]]) {
        BrandInfo *brandInfo = (BrandInfo*)selectableItem.attachedItem;
        _selectedBrandInfo = brandInfo;
        self.brandName = selectableItem.title;
        [self reloadData];
        
        //        UILabel *lbl = (UILabel*)[_brandSelectorBtn viewWithTag:100];
        //        if ([brandInfo.brandEnName length]>0 && [brandInfo.brandName length]>0) {
        //            lbl.text = [NSString stringWithFormat:@"%@/%@",brandInfo.brandEnName,brandInfo.brandName];
        //        } else if ([brandInfo.brandEnName length]>0) {
        //            lbl.text = brandInfo.brandEnName;
        //        } else if (brandInfo.brandName) {
        //            lbl.text = brandInfo.brandName;
        //        }
        
        //        self.editableInfo.brandId = brandInfo.brandId;
        //        self.editableInfo.brandName = brandInfo.brandName;
        //        self.editableInfo.brandEnName = brandInfo.brandEnName;
        //        [_brandSelectorBtn setTitleColor:[UIColor colorWithHexString:@"181818"] forState:UIControlStateNormal];
        popToPulishController();
    }
    else if ([selectableItem.attachedItem isKindOfClass:[GradeInfo class]]) {
        GradeInfo *gradeInfo = (GradeInfo*)selectableItem.attachedItem;
        //        UILabel *lbl = (UILabel*)[_gradeBtn viewWithTag:100];
        //        lbl.text = [NSString stringWithFormat:@"%@ (%@)",gradeInfo.gradeName,gradeInfo.gradeDesc];
        //        self.editableInfo.grade = gradeInfo.grade;
        //        [_gradeBtn setTitleColor:[UIColor colorWithHexString:@"181818"] forState:UIControlStateNormal];
        popToPulishController();
    }
    else if ([selectableItem.attachedItem isKindOfClass:[NSNumber class]]) {
        if (viewController.view.tag==1000) {
            self.editableInfo.grade = [((NSNumber*)selectableItem.attachedItem) integerValue];
            //            UILabel *lbl = (UILabel*)[_gradeBtn viewWithTag:100];
            //            lbl.text = selectableItem.title;
            self.editableInfo.grade = self.editableInfo.grade;
            //            [_gradeBtn setTitleColor:[UIColor colorWithHexString:@"181818"] forState:UIControlStateNormal];
        }
        else if (viewController.view.tag==1001) {
            self.editableInfo.fitPeople = [((NSNumber*)selectableItem.attachedItem) integerValue];
            //            UILabel *lbl = (UILabel*)[_fitPeopleBtn viewWithTag:100];
            //            lbl.text = selectableItem.title;
            //            self.editableInfo.fitPeople = self.editableInfo.fitPeople;
            //            [_fitPeopleBtn setTitleColor:[UIColor colorWithHexString:@"181818"] forState:UIControlStateNormal];
        }
        popToPulishController();
    }
    else if ([selectableItem.attachedItem isKindOfClass:[AttrInfoEditButton class]]) {
        //        AttrInfoEditButton *attrInfoEditButton = (AttrInfoEditButton*)selectableItem.attachedItem;
        //        AttrEditableInfo *attrEditableInfo = attrInfoEditButton.attrEditableInfo;
        //        attrEditableInfo.attrValue = selectableItem.title;
        //        UILabel *lbl = (UILabel*)[attrInfoEditButton viewWithTag:100];
        //        lbl.text = selectableItem.title;
        //        [attrInfoEditButton setTitleColor:[UIColor colorWithHexString:@"181818"] forState:UIControlStateNormal];
        popToPulishController();
    }
}

- (BOOL)saveEditInfo
{
    BOOL isValid = YES;
    
    NSLog(@"%@--------%@", self.selectedCate, self.selectedBrandInfo);
    if (isValid) {
        if (!self.selectedCate) {
            [WCAlertView showAlertWithTitle:@""
                                    message:@"请先选择商品类目"
                         customizationBlock:^(WCAlertView *alertView) {
                             alertView.style = WCAlertViewStyleWhite;
                         } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                             [self pulishSelectCate:self.cateList];
                         } cancelButtonTitle:@"确定" otherButtonTitles:nil];
            isValid = NO;
        }
    }
    
    if (isValid) {
        if (!self.selectedBrandInfo) {
            [WCAlertView showAlertWithTitle:@""
                                    message:@"请先选择品牌"
                         customizationBlock:^(WCAlertView *alertView) {
                             alertView.style = WCAlertViewStyleWhite;
                         } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                             [self publishSelectBrand:self.brandList];
                         } cancelButtonTitle:@"确定" otherButtonTitles:nil];
            isValid = NO;
        }
    }
    
    if (isValid) {
        if (self.gradeId == 0) {//[self getGradeNum:self.grade] == -1
            [WCAlertView showAlertWithTitle:@""
                                    message:@"请先选择成色"
                         customizationBlock:^(WCAlertView *alertView) {
                             alertView.style = WCAlertViewStyleWhite;
                         } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                             //                         [self publishSelectBrand:self.brandList];
                         } cancelButtonTitle:@"确定" otherButtonTitles:nil];
            isValid = NO;
        }
    }
    
    if (isValid) {
        if (self.yuanPrice.length == 0 || self.jianyiPrice.length == 0) {
            [WCAlertView showAlertWithTitle:@""
                                    message:@"请填写价格"
                         customizationBlock:^(WCAlertView *alertView) {
                             alertView.style = WCAlertViewStyleWhite;
                         } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                             
                         } cancelButtonTitle:@"确定" otherButtonTitles:nil];
            isValid = NO;
        }
    }
    
    if (isValid) {
        if (self.jianyiPrice.integerValue < self.dioahuoPrice.integerValue) {
            [WCAlertView showAlertWithTitle:@""
                                    message:@"建议零售价不得低于调货价"
                         customizationBlock:^(WCAlertView *alertView) {
                             alertView.style = WCAlertViewStyleWhite;
                         } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                             //                         [self publishSelectBrand:self.brandList];
                         } cancelButtonTitle:@"确定" otherButtonTitles:nil];
            isValid = NO;
        }
    }
    
    if (isValid) {
        if (self.descText && !(self.descText.length > 0)) {
            [WCAlertView showAlertWithTitle:@""
                                    message:@"填写描述信息更有利于出售哦~"
                         customizationBlock:^(WCAlertView *alertView) {
                             alertView.style = WCAlertViewStyleWhite;
                         } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                         } cancelButtonTitle:@"确定" otherButtonTitles:nil];
            isValid = NO;
        }
    }
    
    if (isValid) {
        //        if (!self.descText.length > 0) {
        //            [WCAlertView showAlertWithTitle:@""
        //                                    message:@"填写描述信息更有利于出售哦~"
        //                         customizationBlock:^(WCAlertView *alertView) {
        //                             alertView.style = WCAlertViewStyleWhite;
        //                         } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
        //                             //                         [self publishSelectBrand:self.brandList];
        //                         } cancelButtonTitle:@"确定" otherButtonTitles:nil];
        //            isValid = YES;
        //        }
    }
    
    NSArray *picItemsArray = [_picturesEditView picItemsArray];
    if ([picItemsArray count]==0) {
        isValid = NO;
        _editableInfo.mainPicItem = nil;
        _editableInfo.gallary = nil;
    } else {
        _editableInfo.mainPicItem = [picItemsArray objectAtIndex:0];
        if ([picItemsArray count]>1) {
            NSMutableArray *gallery = [[NSMutableArray alloc] initWithCapacity:picItemsArray.count-1];
            for (NSInteger i=1;i<picItemsArray.count;i++) {
                [gallery addObject:[picItemsArray objectAtIndex:i]];
            }
            _editableInfo.gallary = gallery;
        } else {
            _editableInfo.gallary = nil;
        }
    }
    return isValid;
}

- (void)publishSelectBrand:(NSArray*)brandList
{
    WEAKSELF;
    if (weakSelf.selectedCate || weakSelf.editableInfo.categoryId>0) {
        
    } else {
        //        [weakSelf.cateSelectorBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        //        UIAlertView *alertView = [[UIAlertView alloc ] initWithTitle:@""
        //                                                             message:@"请先选择商品类目 "
        //                                                            delegate:nil
        //                                                   cancelButtonTitle:nil
        //                                                   otherButtonTitles:@"确定", nil];
        //        [alertView show];
        
        [WCAlertView showAlertWithTitle:@""
                                message:@"请先选择商品类目"
                     customizationBlock:^(WCAlertView *alertView) {
                         alertView.style = WCAlertViewStyleWhite;
                     } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                         [weakSelf pulishSelectCate:weakSelf.cateList];
                     } cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        return;
    }
    
    
    PublishSelectViewController *viewController = [[PublishSelectViewController alloc] init];
    typeof(viewController) __weak weakViewController = viewController;
    viewController.title = @"选择品牌";
    viewController.delegate = weakSelf;
    viewController.isGroupedWithName = YES;
    viewController.isSupportSearch = YES;
    
    //add code
    viewController.isShowHeader = YES;
    
    if ([brandList count]>0) {
        viewController.callbackBlockAfterWiewDidLoad = ^{
            NSMutableArray *selectableItemArray = [[NSMutableArray alloc] initWithCapacity:brandList.count];
            for (BrandInfo *brandInfo in brandList) {
                NSString *name = @"";
                if ([brandInfo.brandEnName length]>0 && [brandInfo.brandName length]>0) {
                    name = [NSString stringWithFormat:@"%@/%@",brandInfo.brandEnName,brandInfo.brandName];
                } else if ([brandInfo.brandEnName length]>0) {
                    name = brandInfo.brandEnName;
                } else if (brandInfo.brandName) {
                    name = brandInfo.brandName;
                }
                if ([name length]>0) {
                    [selectableItemArray addObject:[PublishSelectableItem buildSelectableItem:name summary:nil isSelected:weakSelf.selectedBrandInfo==brandInfo attatchedItem:brandInfo]];
                }
            }
            weakViewController.selectableItemArray = selectableItemArray;
            [weakViewController reloadData];
        };
    } else {
        viewController.callbackBlockAfterWiewDidLoad = ^{
            [weakViewController showProcessingHUD:nil];
            //_selectedCate?0:
            [BrandService getBrandList:_selectedCate.cateId completion:^(NSArray *fechtedBrandList) {
                [weakViewController hideHUD];
                NSLog(@"%ld, %ld", (long)_selectedCate.cateId, (long)_selectedCate.parentId);
                NSMutableArray *selectableItemArray = [[NSMutableArray alloc] initWithCapacity:fechtedBrandList.count];
                for (BrandInfo *brandInfo in fechtedBrandList) {
                    NSString *name = @"";
                    if ([brandInfo.brandEnName length]>0 && [brandInfo.brandName length]>0) {
                        name = [NSString stringWithFormat:@"%@/%@",brandInfo.brandEnName,brandInfo.brandName];
                    } else if ([brandInfo.brandEnName length]>0) {
                        name = brandInfo.brandEnName;
                    } else if (brandInfo.brandName) {
                        name = brandInfo.brandName;
                    }
                    if ([name length]>0) {
                        [selectableItemArray addObject:[PublishSelectableItem buildSelectableItem:name summary:nil isSelected:weakSelf.selectedBrandInfo==brandInfo attatchedItem:brandInfo]];
                    }
                }
                weakSelf.brandList = fechtedBrandList;
                weakViewController.selectableItemArray = selectableItemArray;
                [weakViewController reloadData];
            } failure:^(XMError *error) {
                [weakViewController showHUD:[error errorMsg] hideAfterDelay:0.8f];
            }];
        };
    }
    [weakSelf pushViewController:viewController animated:YES];
}

- (void)pulishSelectCate:(NSArray*)cateList
{
    WEAKSELF;
    PublishSelectViewController *viewController = [[PublishSelectViewController alloc] init];
    typeof(viewController) __weak weakViewController = viewController;
    //        viewController.delegate = weakSelf;
    //        viewController.selectedCateId = weakSelf.editableInfo.categoryId;
    //        viewController.selectedCateName = weakSelf.editableInfo.categoryName;
    viewController.title = @"选择类别";
    viewController.delegate = self;
    viewController.selectableItemArray = nil;
    if ([cateList count]>0) {
        NSMutableArray *selectableItemArray = [[NSMutableArray alloc] initWithCapacity:cateList.count];
        for (Cate *cate in cateList) {
            if ([cate isKindOfClass:[Cate class]]) {
                if ([cate.children count]>0) {
                    [selectableItemArray addObject:[PublishSelectableItem buildSelectableItem:cate.name summary:nil hasChildren:YES attatchedItem:cate]];
                    NSLog(@"%@", selectableItemArray);
                } else {
                    [selectableItemArray addObject:[PublishSelectableItem buildSelectableItem:cate.name summary:nil isSelected:cate==weakSelf.selectedCate attatchedItem:cate]];
                    
                    weakViewController.isSupportSearch = YES;
                }
            }
        }
        weakViewController.selectableItemArray = selectableItemArray;
    } else {
        viewController.callbackBlockAfterWiewDidLoad = ^{
            [weakViewController showProcessingHUD:nil];
            [CategoryService getCateList:^(NSDictionary *data) {
                [weakViewController hideHUD];
                NSArray *cateListDicts = [data arrayValueForKey:@"list"];
                NSMutableArray *selectableItemArray = [[NSMutableArray alloc] initWithCapacity:cateListDicts.count];
                NSMutableArray *cateList = [[NSMutableArray alloc] initWithCapacity:cateListDicts.count];
                for (NSDictionary *dict in cateListDicts) {
                    if ([dict isKindOfClass:[NSDictionary class]]) {
                        Cate *cate = [Cate createWithDict:dict];
                        //一级
                        [cateList addObject:cate];
                        if ([cate.children count]>0) {
                            [selectableItemArray addObject:[PublishSelectableItem buildSelectableItem:cate.name summary:nil hasChildren:YES attatchedItem:cate]];
                        } else {
                            [selectableItemArray addObject:[PublishSelectableItem buildSelectableItem:cate.name summary:nil isSelected:NO attatchedItem:cate]];
                            weakViewController.isSupportSearch = YES;
                        }
                    }
                }
                weakSelf.cateList = cateList;
                weakViewController.selectableItemArray = selectableItemArray;
                [weakViewController reloadData];
            } failure:^(XMError *error) {
                [weakViewController showHUD:[error errorMsg] hideAfterDelay:0.8f];
            }];
        };
    }
    self.brandList = nil;
    [self pushViewController:viewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    return [ClsTableViewCell rowHeightForPortrait:dict];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _selectedPhotos.count + 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    if (indexPath.row == _selectedPhotos.count) {
        cell.imageView.image = [UIImage imageNamed:@"AlbumAddBtn"];
        cell.imageView.contentMode = UIViewContentModeCenter;
        cell.imageView.layer.borderColor = [UIColor colorWithHexString:@"bbbbbb"].CGColor;
        cell.imageView.layer.borderWidth = 1.f;
        cell.titleLbl.hidden = NO;
        cell.promptLbl.hidden = YES;
        cell.deleteBtn.hidden = YES;
    } else if (indexPath.row == _selectedPhotos.count+1) {
        cell.imageView.image = [UIImage imageNamed:@"Publish_Prompt"];
        cell.layer.cornerRadius = ((kScreenWidth-(15*2+5*2))/3)/2/2;
        cell.layer.masksToBounds = YES;
        cell.titleLbl.hidden = YES;
        cell.deleteBtn.hidden = YES;
        cell.promptLbl.hidden = YES;
    } else {
        cell.imageView.image = _selectedPhotos[indexPath.row];
        cell.imageView.contentMode = UIViewContentModeScaleToFill;
        cell.imageView.layer.borderWidth = 0.f;
        cell.promptLbl.hidden = YES;
        cell.titleLbl.hidden = YES;
        cell.deleteBtn.hidden = NO;
    }
    if (indexPath.item == 9) {
        cell.hidden = YES;
        _collectionView.frame = CGRectMake(_margin, 0, self.view.tz_width - 2 * _margin, ((400-28)/3)*((_selectedPhotos.count/3)));
    } else if (indexPath.item == 10) {
        cell.hidden = YES;
        
    } else {
        cell.hidden = NO;
    }
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WEAKSELF;
    if (indexPath.row == _selectedPhotos.count) {
        [self pickPhotoButtonClick:nil];
    } else if (indexPath.row == _selectedPhotos.count+1) {
        [UIView animateWithDuration:0.25 animations:^{
            self.promptView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        }];
    } else { // preview photos / 预览照片
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.row];
        imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
        // imagePickerVc.allowPickingOriginalPhoto = NO;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            _selectedPhotos = [NSMutableArray arrayWithArray:photos];
            _selectedAssets = [NSMutableArray arrayWithArray:assets];
            _isSelectOriginalPhoto = isSelectOriginalPhoto;
            _layout.itemCount = _selectedPhotos.count;
            [_collectionView reloadData];
            _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    if (sourceIndexPath.item >= _selectedPhotos.count || destinationIndexPath.item >= _selectedPhotos.count) return;
    UIImage *image = _selectedPhotos[sourceIndexPath.item];
    if (image) {
        [_selectedPhotos exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
        [_selectedAssets exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
        [_collectionView reloadData];
    }
}

#pragma mark Click Event

- (void)deleteBtnClik:(UIButton *)sender {
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_selectedAssets removeObjectAtIndex:sender.tag];
    _layout.itemCount = _selectedPhotos.count;
    
    [_collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
        if (_selectedPhotos.count < 3) {
            _collectionView.frame = CGRectMake(_margin, 0, self.view.tz_width - 2 * _margin, ((400-10)/3)*(3/3));
        } else {
            _collectionView.frame = CGRectMake(_margin, 0, self.view.tz_width - 2 * _margin, ((400-28)/3)*((_selectedPhotos.count/3)+1));
        }
    } completion:^(BOOL finished) {
        [_collectionView reloadData];
    }];
    [self setUpUI];
}

- (IBAction)pickPhotoButtonClick:(UIButton *)sender {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    imagePickerVc.selectedAssets = _selectedAssets; // optional, 可选的
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    
    // Set the appearance
    // 在这里设置imagePickerVc的外观
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    
    // Set allow picking video & photo & originalPhoto or not
    // 设置是否可以选择视频/图片/原图
    // imagePickerVc.allowPickingVideo = NO;
    // imagePickerVc.allowPickingImage = NO;
    // imagePickerVc.allowPickingOriginalPhoto = NO;
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark TZImagePickerControllerDelegate

/// User click cancel button
/// 用户点击了取消
- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    // NSLog(@"cancel");
}

/// User finish picking photo，if assets are not empty, user picking original photo.
/// 用户选择好了图片，如果assets非空，则用户选择了原图。
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    _layout.itemCount = _selectedPhotos.count;
    if (_selectedPhotos.count < 3) {
        _collectionView.frame = CGRectMake(_margin, 0, self.view.tz_width - 2 * _margin, ((400-10)/3)*(3/3));
    } else {
        _collectionView.frame = CGRectMake(_margin, 0, self.view.tz_width - 2 * _margin, ((400-28)/3)*((_selectedPhotos.count/3)+1));
    }
    
    [_collectionView reloadData];
    _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
    [self setUpUI];
}

/// User finish picking video,
/// 用户选择好了视频
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    _selectedPhotos = [NSMutableArray arrayWithArray:@[coverImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    _layout.itemCount = _selectedPhotos.count;
    // open this code to send video / 打开这段代码发送视频
    // [[TZImageManager manager] getVideoOutputPathWithAsset:asset completion:^(NSString *outputPath) {
    // NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
    // Export completed, send video here, send by outputPath or NSData
    // 导出完成，在这里写上传代码，通过路径或者通过NSData上传
    
    // }];
    [_collectionView reloadData];
    _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
}

@end


