//
//  ConsignmentViewController.m
//  XianMao
//
//  Created by WJH on 17/2/7.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "ConsignmentViewController.h"
#import "PullRefreshTableView.h"
#import "SepTableViewCell.h"
#import "PublishChooseCateCell.h"
#import "PublishChooseBrandCell.h"
#import "PublishChooseGradeCell.h"
#import "WCAlertView.h"
#import "PublishChooseGradeViewController.h"
#import "Cate.h"
#import "PublishGoodsViewController.h"
#import "CategoryService.h"
#import "BrandInfo.h"
#import "PublishAttrInfo.h"
#import "PictureItemsEditViewForConsignment.h"
#import "ConsignmentPriceCell.h"
#import "SalesreturnAdressCell.h"
#import "UserAddressViewController.h"
#import "AddressInfo.h"
#import "UIImage+Resize.h"
#import "ConsignmentDescriptionCell.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "SendSaleNewViewController.h"
#import "PublishAgreementCell.h"

#define kADMImageSize 800

@interface ConsignmentViewController ()<UITableViewDelegate,UITableViewDataSource,PullRefreshTableViewDelegate,PublishChooseGradeViewControllerDelegate,PublishGoodsViewControllerDelegate,PublishSelectViewControllerDelegate,PictureItemsEditViewForConsignmentDelegate>

@property (nonatomic, strong) PullRefreshTableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSources;
@property (nonatomic, strong) NSMutableArray *cateList;
@property (nonatomic, strong) NSArray *brandList;
@property (nonatomic, strong) Cate *selectedCate;
@property (nonatomic, strong) BrandInfo *selectedBrandInfo;
@property (nonatomic, copy) NSString *grade;
@property (nonatomic, copy) NSString *cateName;
@property (nonatomic, copy) NSString *brandName;
@property (nonatomic, copy) NSString *descText;
@property (nonatomic, assign) double price;
@property (nonatomic, strong) AddressInfo * addressInfo;
@property (nonatomic, strong) PictureItemsEditViewForConsignment * picItemEditView;
@property (nonatomic, strong) CommandButton * publishBtn;
@property (nonatomic, strong) NSMutableArray * uploadFiles;
@property (nonatomic, strong) NSArray * pictrueItemArr;
@property (nonatomic, assign) BOOL isAgreement;
@end

@implementation ConsignmentViewController


- (PullRefreshTableView *)tableView{
    if (!_tableView) {
        _tableView = [[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, 65.5, kScreenWidth, kScreenHeight-65.5-60)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.enableLoadingMore = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.pullDelegate = self;
    }
    return _tableView;
}


-(PictureItemsEditViewForConsignment *)picItemEditView{
    if (!_picItemEditView) {
        _picItemEditView = [[PictureItemsEditViewForConsignment alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 145)];
        _picItemEditView.isNeedPushViewCtrl = NO;//YES是选照片之前要选商品类目
    }
    return _picItemEditView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [super setupTopBar];
    [super setupTopBarTitle:@"发布寄卖"];
    [super setupTopBarBackButton];
    
    
    _isAgreement = YES;
    
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.picItemEditView;
    self.picItemEditView.delegate = self;
    
    [self loadCell];
    [self createBottomView];
    
}

- (void)loadCell{
    NSMutableArray * dataSources = [NSMutableArray array];
    [dataSources addObject:[SepTableViewCell buildCellDict]];
    [dataSources addObject:[PublishChooseCateCell buildCellDict:self.cateName]];
    
    [dataSources addObject:[SegTabViewCellSmallTwo buildCellDict]];
    [dataSources addObject:[PublishChooseBrandCell buildCellDict:self.brandName]];
    
    [dataSources addObject:[SegTabViewCellSmallTwo buildCellDict]];
    [dataSources addObject:[PublishChooseGradeCell buildCellDict:self.grade]];
    
    [dataSources addObject:[SepTableViewCell buildCellDict]];
    [dataSources addObject:[ConsignmentDescriptionCell buildCellDict]];
    [dataSources addObject:[SepTableViewCell buildCellDict]];
    [dataSources addObject:[ConsignmentPriceCell buildCellDict]];
    [dataSources addObject:[SepTableViewCell buildCellDict]];
    [dataSources addObject:[SalesreturnAdressCell buildCellDict:self.addressInfo]];
    [dataSources addObject:[PublishAgreementCell buildCellDict]];

    self.dataSources = dataSources;
    [self.tableView reloadData];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
        WEAKSELF;
    if (ClsTableViewCell == [PublishChooseCateCell class]) {
        [self pulishSelectCate:self.cateList];
    } else if (ClsTableViewCell == [PublishChooseBrandCell class]) {
        [self publishSelectBrand:self.brandList];
    } else if (ClsTableViewCell == [PublishChooseGradeCell class]) {
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
    }else if ( ClsTableViewCell == [SalesreturnAdressCell class]){
        UserAddressViewControllerReturn *viewController = [[UserAddressViewControllerReturn alloc] init];
        viewController.isForSelectAddress = YES;
        viewController.handleAddressSelected = ^(UserAddressViewController *viewController, AddressInfo *addressInfo){
            self.addressInfo = addressInfo;
            [self loadCell];
        };
        [self pushViewController:viewController animated:YES];
    }
}

- (void)publishSelectBrand:(NSArray*)brandList
{
    WEAKSELF;
    if (weakSelf.selectedCate>0) {
        
    } else {
        
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



-(void)getGrade:(NSString *)grade andDescInfo:(GradeDescInfo *)descInfo{
    self.grade = grade;
    [self loadCell];
}

- (void)publishDidSelect:(PublishSelectViewController*)viewController selectableItem:(PublishSelectableItem*)selectableItem
{
    WEAKSELF;
    void(^popToPulishController)() = ^{
        NSArray *viewControllers= viewController.navigationController.viewControllers;
        for (UIViewController *viewController in viewControllers) {
            if ([viewController isKindOfClass:[ConsignmentViewController class]]) {
                [viewController.navigationController popToViewController:viewController animated:YES];
                break;
            }
        }
        
    };
    
    if ([selectableItem.attachedItem isKindOfClass:[Cate class]]) {
        if ([((Cate*)selectableItem.attachedItem).children count]==0) {
            _selectedCate = (Cate*)selectableItem.attachedItem;
            _picItemEditView.selectedCate = _selectedCate;
            self.cateName = selectableItem.title;
            self.brandName = nil;
            self.selectedBrandInfo = nil;
            [weakSelf loadCell];
            popToPulishController();
        } else {
            [self pulishSelectCate:((Cate*)selectableItem.attachedItem).children];
        }
    }
    else if ([selectableItem.attachedItem isKindOfClass:[BrandInfo class]]) {
        BrandInfo *brandInfo = (BrandInfo*)selectableItem.attachedItem;
        _selectedBrandInfo = brandInfo;
        self.brandName = selectableItem.title;
        [weakSelf loadCell];
        popToPulishController();
    }
    else if ([selectableItem.attachedItem isKindOfClass:[GradeInfo class]]) {
        GradeInfo *gradeInfo = (GradeInfo*)selectableItem.attachedItem;
        self.grade = gradeInfo.gradeName;
        [weakSelf loadCell];
        popToPulishController();
    }
    
}

#pragma mark - PictrueItemViewdelegate
-(void)imagePickerDidFinishPickingPhotos:(CGFloat)height picTrueItem:(NSArray *)pictreus{

    _pictrueItemArr = [NSArray arrayWithArray:pictreus];
    [AppDirs clearupConsignmentDir];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _uploadFiles = [[NSMutableArray alloc] init];
        for (UIImage * originalImage in _pictrueItemArr) {
            CGSize originalSize = originalImage.size;
            UIImage *image = originalImage;
            if (originalSize.width == kADMImageSize && originalSize.height== kADMImageSize) {
                //... originalImage
            } else {
                if (originalSize.width == originalSize.height) {
                    if (originalSize.width>kADMImageSize) {
                        CGSize size = CGSizeMake(kADMImageSize, kADMImageSize);
                        UIImage *scaledImage = [originalImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:size interpolationQuality:kCGInterpolationDefault];
                        image = scaledImage;
                    } else {
                        //... originalImage
                    }
                } else {
                    if (originalSize.width < kADMImageSize && originalSize.height<kADMImageSize) {
                        //... originalImage
                    } else {
                        
                        CGSize size = CGSizeMake(kADMImageSize, kADMImageSize);
                        UIImage *scaledImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:size interpolationQuality:kCGInterpolationDefault];
                        image = scaledImage;
                    }
                }
            }
            
            NSString *filePath = [AppDirs saveConsignmentPicture:image fileName:nil];
            
            [_uploadFiles addObject:filePath];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.picItemEditView.frame = CGRectMake(0, 0, kScreenWidth, height);
            self.tableView.tableHeaderView = self.picItemEditView;
            [self.tableView reloadData];
        });
       
        
    });
}

- (void)pulishSelectCate{
    [self pulishSelectCate:self.cateList];
}

#pragma mark -
- (void)createBottomView{
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-60, kScreenWidth, 60)];
    _publishBtn = [[CommandButton alloc] initWithFrame:CGRectMake(15, 15/2, kScreenWidth-30, 45)];
    [_publishBtn setTitle:@"发布" forState:UIControlStateNormal];
    [_publishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_publishBtn setBackgroundColor:[DataSources colorf9384c]];
    _publishBtn.layer.masksToBounds = YES;
    _publishBtn.layer.cornerRadius = 6;
    [self.view addSubview:view];
    [view addSubview:_publishBtn];
    
    WEAKSELF;
    _publishBtn.handleClickBlock =^(CommandButton * button){
        if (!weakSelf.isAgreement) {
            [weakSelf showHUD:@"请先阅读爱丁猫协议" hideAfterDelay:0.8];
        }else{
            [weakSelf clickPublishBtn];
        }
    };
   
}

- (void)clickPublishBtn{
    
    BOOL isValid = [self saveEditInfo];
    if (isValid) {
        NSArray *picItemArray = _uploadFiles;
        if (picItemArray.count == 0) {
            [self showHUD:@"请至少提供一个图片" hideAfterDelay:0.8f];
        } else {
            WEAKSELF;
            [weakSelf showProcessingHUD:@""];
            if ([_uploadFiles count]>0) {
                [[NetworkAPI sharedInstance] updaloadPics:_uploadFiles completion:^(NSArray *picUrlArray) {
                    NSMutableArray *picArr = [[NSMutableArray alloc] init];
                    for (int i = 0; i < picUrlArray.count; i++) {
                        UIImage *image = self.pictrueItemArr[i];
                        NSDictionary *dict = @{@"pic_url":picUrlArray[i], @"pic_desc":@"", @"width":@(image.size.width) ,@"height":@(image.size.height)};
                        [picArr addObject:dict];
                    }
                    
                    NSDictionary *params = @{@"category_id":@(weakSelf.selectedCate.cateId), @"brand_id":@(weakSelf.selectedBrandInfo.brandId), @"grade":@([weakSelf getGradeNum:weakSelf.grade]), @"goods_desc":weakSelf.descText, @"img":picArr, @"user_hope_price":[NSString stringWithFormat:@"%.2f", weakSelf.price], @"address_id":@(weakSelf.addressInfo.addressId)};
                    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodPOST:@"consignment" path:@"introduce_consignment" parameters:params completionBlock:^(NSDictionary *data) {
                        [weakSelf hideHUD];
                        [UIView animateWithDuration:0.000001 animations:^{
                            [weakSelf.navigationController popToRootViewControllerAnimated:NO];
                        } completion:^(BOOL finished) {
                            SendSaleNewViewController * viewController = [[SendSaleNewViewController alloc] init];
                            viewController.isNeesGuideView = YES;
                            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
                        }];
                    } failure:^(XMError *error) {
                        [weakSelf showHUD:[error errorMsg] hideAfterDelay:1.2];
                    } queue:nil]];
                    
                    
                } failure:^(XMError *error) {
                    [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
                }];
            }
        }
        
        
    }
    
    
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

- (BOOL)saveEditInfo{
    BOOL isValid = YES;
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
        if (!self.grade && self.grade.length > 0) {
            [WCAlertView showAlertWithTitle:@""
                                    message:@"请先选择成色"
                         customizationBlock:^(WCAlertView *alertView) {
                             alertView.style = WCAlertViewStyleWhite;
                         } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                         } cancelButtonTitle:@"确定" otherButtonTitles:nil];
            isValid = NO;
        }
    }
    
    if (isValid) {
        if (!(self.descText.length > 0 && self.descText)) {
            [WCAlertView showAlertWithTitle:@""
                                    message:@"填写描述信息更有利于出售哦~"
                         customizationBlock:^(WCAlertView *alertView) {
                             alertView.style = WCAlertViewStyleWhite;
                         } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                             
                         } cancelButtonTitle:@"确定" otherButtonTitles:nil];
            isValid = NO;
        }
    }
    return isValid;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSources.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dict = [self.dataSources objectAtIndex:indexPath.row];
    Class clsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    return [clsTableViewCell rowHeightForPortrait:dict];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dict = [self.dataSources objectAtIndex:indexPath.row];
    Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:dict];
    NSString * reuseIdentifier = [ClsTableViewCell reuseIdentifier];
    
    BaseTableViewCell * Cell = (BaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (Cell == nil) {
        Cell = [[ClsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        Cell.backgroundColor = [UIColor whiteColor];
        Cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if ([Cell isKindOfClass:[ConsignmentPriceCell class]]) {
        ((ConsignmentPriceCell *)Cell).handleConsignmentPriceBlcok = ^(double price){
            self.price = price;
        };
    }
    
    if ([Cell isKindOfClass:[ConsignmentDescriptionCell class]]) {
        ((ConsignmentDescriptionCell *)Cell).returnText =^(NSString *textViewText){
            self.descText = textViewText;
        };
    }
    
    if ([Cell isKindOfClass:[PublishAgreementCell class]]) {
        PublishAgreementCell *agreementCell = (PublishAgreementCell*)Cell;
        agreementCell.handleCircleBtnClickBlock =^(BOOL isYES){
            self.isAgreement = isYES;
        };
    }
    
    [Cell updateCellWithDict:dict];
    return Cell;
}

@end
