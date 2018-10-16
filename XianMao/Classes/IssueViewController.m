//
//  IssueViewController.m
//  XianMao
//
//  Created by apple on 16/1/22.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "IssueViewController.h"
#import "PromptView.h"
#import "PullRefreshTableView.h"

#import "InsureViewController.h"

#import "PublishGoodsViewController.h"
#import "BaseTableViewCell.h"
#import "QualityTableViewCell.h"
#import "TitleTableViewCell.h"
#import "LineTableViewCell.h"
#import "ChooseTableViewCell.h"
#import "TitleTableViewCell1.h"
#import "FieldTableViewCell.h"
#import "PhotoTableViewCell.h"
#import "FooterView.h"
#import "WebViewController.h"

#import "NSString+AES.h"

#import "PictureItemsEditView.h"
#import "GoodsEditableInfo.h"

#import "NetworkAPI.h"
#import "Error.h"
#import "Masonry.h"
#import "CategoryService.h"
#import "WCAlertView.h"
#import "GoodsEditableInfo.h"

#import "TakePhotoViewController.h"
#import "RecoveryCell.h"
#import "RecoveryCell1.h"
#import "RecoveryCell2.h"
#import "Cate.h"
#import "BrandInfo.h"
#import "GoodsEditableInfo.h"
#import "SmallLineCellTwo.h"

@interface IssueViewController () <UITableViewDataSource, UITableViewDelegate, TitleTableViewCellDelegate, PictureItemsEditViewDelegate, FieldTableViewCellDelegate, QualityTableViewCellDelegate, FooterViewDelegate, PublishSelectViewControllerDelegate>

@property(nonatomic,strong) PictureItemsEditView *picturesEditView;
@property (nonatomic, strong) UIButton *rightLabel;
@property (nonatomic, strong) PromptView *promrtView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) PictureItemsEditView *editView;

@property (nonatomic, strong) UIButton *seletedBtn;
@property (nonatomic, strong) NSMutableArray *seletedArr;

@property (nonatomic, assign) CGFloat heigth;
@property (nonatomic, strong) GoodsEditableInfo *editInfo;
@property (nonatomic, strong) AttrEditableInfo *attrInfo;
@property (nonatomic, strong) AttrEditableInfo *attrInfoI;
@property (nonatomic, strong) GoodsEditableInfo *editInfoI;
@property (nonatomic, strong) NSArray *attrInfoMutArr;
@property (nonatomic, strong) NSMutableString *attrStr;
@property (nonatomic, copy) NSString *summer;
@property (nonatomic, assign) NSInteger grade;
@property (nonatomic, weak) FooterView *footerView;

@property (nonatomic, strong) NSMutableArray *attrInfos;



@property (nonatomic, strong) NSArray *cateList;
@property (nonatomic, strong) NSArray *brandList;
@property(nonatomic,strong) Cate *selectedCate;
@property(nonatomic,strong) BrandInfo *selectedBrandInfo;
@property (nonatomic, strong) GoodsEditableInfo *editableInfo;

@property (nonatomic, strong) RecoveryCell *recoveryCell;
@property (nonatomic, strong) RecoveryCell1 *recoveryCell1;
@property (nonatomic, strong) RecoveryCell2 *recoveryCell2;
@property (nonatomic, assign) NSInteger turnIndex;
@property (nonatomic, strong) NSMutableArray *arr;
@end

@implementation IssueViewController
{
    HTTPRequest *_request;
}

-(GoodsEditableInfo *)editableInfo{
    if (!_editableInfo) {
        _editableInfo = [[GoodsEditableInfo alloc] init];
    }
    return _editableInfo;
}

-(NSMutableArray *)attrInfos{
    if (!_attrInfos) {
        _attrInfos = [[NSMutableArray alloc] init];
    }
    return _attrInfos;
}

-(GoodsEditableInfo *)editInfo{
    if (!_editInfo) {
        _editInfo = [[GoodsEditableInfo alloc] init];
    }
    return _editInfo;
}

-(NSMutableString *)attrStr{
    if (!_attrStr) {
        _attrStr = [[NSMutableString alloc] init];
    }
    return _attrStr;
}

-(NSMutableArray *)seletedArr{
    if (!_seletedArr) {
        _seletedArr = [NSMutableArray array];
    }
    return _seletedArr;
}

-(UIButton *)rightLabel{
    if (!_rightLabel) {
        _rightLabel = [[UIButton alloc] init];
        [_rightLabel setTitle:@"小贴士" forState:UIControlStateNormal];
        [_rightLabel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _rightLabel.titleLabel.textAlignment = NSTextAlignmentCenter;
        _rightLabel.titleLabel.font = [UIFont systemFontOfSize:15.f];
    }
    return _rightLabel;
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.footerView layoutSubviews];
    [self.view layoutSubviews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.turnIndex = 1;
    [self setupTopBar];
    [self setupTopBarTitle:self.titleText];
    [self setupTopBarBackButton];
    
//    [self.topBar addSubview:self.rightLabel];
    [self setupTopBarRightButton:[UIImage imageNamed:@"Insure_rigth_btn_MF"] imgPressed:nil];
    self.editInfo.attrInfoList = [NSMutableArray array];
//    [self.rightLabel addTarget:self action:@selector(clickTopRightBtn) forControlEvents:UIControlEventTouchUpInside];
    
//    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 100)];
//    bottomView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:bottomView];
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    FooterView *footerView = [[FooterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 112)];
    tableView.tableFooterView = footerView;
    self.footerView = footerView;
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    footerView.footDelegate = self;
    
//    [self buildDataWithTableViewCell];
    
    if (!self.releaseIndex) {
        self.footerView.isEdit = 1;
    }
    
    if (self.index == 100) {
        WEAKSELF;
        [self showLoadingView];
        _request = [[NetworkAPI sharedInstance] getEditableInfo:self.goodsID type:1 completion:^(NSDictionary *editableInfoDict) {
            [weakSelf hideLoadingView];
            GoodsEditableInfo *editInfo = [[GoodsEditableInfo alloc] initWithDict:editableInfoDict];
            weakSelf.cate_id = editInfo.categoryId;
            weakSelf.brand_id = editInfo.brandId;
            weakSelf.cateName = editInfo.categoryName;
            weakSelf.brandName = editInfo.brandName;
            weakSelf.titleText = [NSString stringWithFormat:@"%@-%@", editInfo.categoryName, editInfo.brandName];
            [super setupTopBarTitle:self.titleText];
            weakSelf.editInfoI = editInfo;
            if (editInfo) {
                for (AttrEditableInfo *attrInfo in editInfo.attrInfoList) {
                    if (attrInfo.is_multi_choice == 1) {
                        NSString *nstring = attrInfo.attrValue;
                        NSArray *array = [nstring componentsSeparatedByString:@","];
                        for (int i = 0; i < [array count]; i++) {
                            NSLog(@"string:%@", [array objectAtIndex:i]);
                            UIButton *btn = [[UIButton alloc] init];
                            btn.tag = attrInfo.attrId;
                            btn.titleLabel.text = array[i];
                            [self.seletedArr addObject:btn];
                        }
                        
                    } else if (attrInfo.is_multi_choice == 0) {
                        
                        [self.attrInfos addObject:attrInfo];
                        NSLog(@"%@", _attrInfos);
                    }
                }
            }
            [weakSelf buildDataWithTableViewCell];
//            [weakSelf.tableView reloadData];
        } failure:^(XMError *error) {
            [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
        }];
    } else {
        [self buildDataWithTableViewCell];
    }

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dissMissBackView) name:@"dissMissBackView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addPhotoView:) name:@"photo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataChoose:) name:@"getDataChoose" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remDataChoose:) name:@"remDataChoose" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(aidingmaoPush:) name:@"aidingmaoPush" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cammer) name:@"cammer" object:nil];
    [self setUpUI];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"dissMissBackView" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"photo" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getDataChoose" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"remDataChoose" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"aidingmaoPush" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cammer" object:nil];
}

-(void)aidingmaoPush:(NSNotification *)notify{
    WebViewController *viewController = notify.object;
    [self pushViewController:viewController animated:YES];
}

-(void)cammer{
//    TakePhotoViewController *viewController = [[TakePhotoViewController alloc] init];
//    [self presentViewController:viewController animated:YES completion:nil];
}

-(void)addPhotoView:(NSNotification *)notify{
    
    PhotoTableViewCell *cell = notify.object;
    PictureItemsEditView *editView = [[PictureItemsEditView alloc] initWithFrame:CGRectMake(0, 15, kScreenWidth, [PictureItemsEditView heightForOrientationPortrait:0 maxItemsCount:21]) isShowMainPicTip:YES];
    editView.backgroundColor = [UIColor clearColor];
    editView.maxItemsCount = 9;
    editView.delegate = self;
    editView.viewController = self;
    [editView setIsShowMainPicTip:YES];
    //    if (self.index == 100) {
    if (self.releaseIndex) {
        editView.isEdit = NO;
    } else {
        editView.isEdit = YES;
    }
    
    if (self.editInfoI) {
        //这里放到主线来执行，防止UI错乱..
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            [arr addObject:self.editInfoI.mainPicItem];
            for (PictureItem *pictItem in self.editInfoI.gallary) {
                [arr addObject:pictItem];
            }
            editView.picItemsArray = arr;
        });
    }
    [cell.contentView addSubview:editView];
    self.picturesEditView = editView;
}

-(void)handleTopBarBackButtonClicked:(UIButton *)sender{
    if (self.releaseIndex) {
        [super handleTopBarBackButtonClicked:sender];
    } else {
        [WCAlertView showAlertWithTitle:@"提示" message:@"您的编辑将会无效，确认返回？" customizationBlock:^(WCAlertView *alertView) {
            
        } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
            
            if (buttonIndex == 1) {
                [super handleTopBarBackButtonClicked:sender];
            }
            
        } cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    }
}

- (void)picturesEditViewHeightChanged:(PictureItemsEditView*)view height:(CGFloat)height{
    self.heigth = height;
    [self.tableView reloadData];
}

-(void)buildDataWithTableViewCell{
    
    [self showLoadingView];
    WEAKSELF;
    [CategoryService getArecoveryAttrInfoList:self.cate_id completion:^(NSArray *attrInfoList) {
        [self hideLoadingView];
        
        self.attrInfoMutArr = attrInfoList;
        
        NSMutableArray *dataSource = [[NSMutableArray alloc] init];
        
        if (weakSelf.editInfoI) {
            self.grade = self.editInfoI.grade;

            [dataSource addObject:[FieldTableViewCell buildCellDict:weakSelf.editInfoI]];
            [dataSource addObject:[PhotoTableViewCell buildCellDict]];
            
            [dataSource addObject:[RecoveryCell buildCellDict]];
            [dataSource addObject:[SmallLineCellTwo buildCellDict]];
            [dataSource addObject:[RecoveryCell1 buildCellDict]];
            [dataSource addObject:[SmallLineCellTwo buildCellDict]];
            [dataSource addObject:[RecoveryCell2 buildCellDict]];
            [dataSource addObject:[SmallLineCellTwo buildCellDict]];
            
//            [dataSource addObject:[TitleTableViewCell buildCellDict:nil andPrompTitle:@""]];
//            [dataSource addObject:[LineSmallTableViewCell buildCellDict]];
//            [dataSource addObject:[QualityTableViewCell buildCellDict:weakSelf.editInfoI]];
//            for (AttrEditableInfo *attrInfo in weakSelf.editInfoI.attrInfoList) {
//                [self.editInfo.attrInfoList addObject:attrInfo];
//                [dataSource addObject:[LineTableViewCell buildCellDict]];
//                [dataSource addObject:[TitleTableViewCell buildCellDict:attrInfo.attrName andPrompTitle:attrInfo.explain]];
//                [dataSource addObject:[LineSmallTableViewCell buildCellDict]];
//                [dataSource addObject:[ChooseTableViewCell buildCellDict:attrInfo]];
//            }
//            [dataSource addObject:[LineTableViewCell buildCellDict]];
//            [dataSource addObject:[TitleTableViewCell buildCellDict:@"补充描述" andPrompTitle:@"选填"]];
//            [dataSource addObject:[LineSmallTableViewCell buildCellDict]];
//            [dataSource addObject:[FieldTableViewCell buildCellDict:weakSelf.editInfoI]];
            
//            [dataSource addObject:[LineTableViewCell buildCellDict]];
//            [dataSource addObject:[TitleTableViewCell buildCellDict:@"实拍照片" andPrompTitle:@""]];
//            [dataSource addObject:[LineSmallTableViewCell buildCellDict]];
//            [dataSource addObject:[PhotoTableViewCell buildCellDict]];
        } else {

            [dataSource addObject:[FieldTableViewCell buildCellDict:nil]];
            [dataSource addObject:[PhotoTableViewCell buildCellDict]];
            
            [dataSource addObject:[RecoveryCell buildCellDict]];
            [dataSource addObject:[SmallLineCellTwo buildCellDict]];
            [dataSource addObject:[RecoveryCell1 buildCellDict]];
            [dataSource addObject:[SmallLineCellTwo buildCellDict]];
            [dataSource addObject:[RecoveryCell2 buildCellDict]];
            [dataSource addObject:[SmallLineCellTwo buildCellDict]];
            
//            [dataSource addObject:[TitleTableViewCell buildCellDict:nil andPrompTitle:@""]];
//            [dataSource addObject:[LineSmallTableViewCell buildCellDict]];
//            [dataSource addObject:[QualityTableViewCell buildCellDict:nil]];
//            for (AttrEditableInfo *attrInfo in attrInfoList) {
//                [self.editInfo.attrInfoList addObject:attrInfo];
//                [dataSource addObject:[LineTableViewCell buildCellDict]];
//                [dataSource addObject:[TitleTableViewCell buildCellDict:attrInfo.attrName andPrompTitle:attrInfo.explain]];
//                [dataSource addObject:[LineSmallTableViewCell buildCellDict]];
//                [dataSource addObject:[ChooseTableViewCell buildCellDict:attrInfo]];
//            }
//            [dataSource addObject:[LineTableViewCell buildCellDict]];
//            [dataSource addObject:[TitleTableViewCell buildCellDict:@"补充描述" andPrompTitle:@"选填"]];
//            [dataSource addObject:[LineSmallTableViewCell buildCellDict]];
//            [dataSource addObject:[FieldTableViewCell buildCellDict:nil]];
            
//            [dataSource addObject:[LineTableViewCell buildCellDict]];
//            [dataSource addObject:[TitleTableViewCell buildCellDict:@"实拍照片" andPrompTitle:@""]];
//            [dataSource addObject:[LineSmallTableViewCell buildCellDict]];
//            [dataSource addObject:[PhotoTableViewCell buildCellDict]];
        }
        
        self.dataSource = dataSource;
        [self.tableView reloadData];
        
    } failure:^(XMError *error) {
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
    }];
    
}

-(void)setUpUI{
//    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.topBar.mas_top).offset(20);
//        make.right.equalTo(self.topBar.mas_right).offset(-8);
//        make.bottom.equalTo(self.topBar.mas_bottom);
//        make.width.equalTo(@45);
//    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBar.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [self.dataSource objectAtIndex:[indexPath row]];
    Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:dict];
    NSString *reuseIdentifier = [ClsTableViewCell reuseIdentifier];
    
    BaseTableViewCell *tableViewCell = (BaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (tableViewCell == nil) {
        tableViewCell = [[ClsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        [tableViewCell setBackgroundColor:[tableView backgroundColor]];
        [tableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    if ([tableViewCell isKindOfClass:[RecoveryCell class]]) {
        RecoveryCell *recoveryCell = (RecoveryCell *)tableViewCell;
        recoveryCell.subStr = self.brandName;
        self.recoveryCell = recoveryCell;
        [recoveryCell setTitleText:@"品牌" andImageName:@"right_arrow_gray"];
    }
    
    else if ([tableViewCell isKindOfClass:[RecoveryCell1 class]]) {
        RecoveryCell1 *recoveryCell1 = (RecoveryCell1 *)tableViewCell;
        recoveryCell1.subStr = self.cateName;
        self.recoveryCell1 = recoveryCell1;
        [recoveryCell1 setTitleText1:@"类目" andImageName:@"right_arrow_gray"];
    }
    
    else if ([tableViewCell isKindOfClass:[RecoveryCell2 class]]) {
        RecoveryCell2 *recoveryCell2 = (RecoveryCell2 *)tableViewCell;
        self.recoveryCell2 = recoveryCell2;
        [recoveryCell2 setTitleText2:@"补充" andImageName:@"right_Down_gray"];
    }
    
    else if ([tableViewCell isKindOfClass:[TitleTableViewCell class]]) {
        TitleTableViewCell *titleTableViewCell = (TitleTableViewCell *)tableViewCell;
        [titleTableViewCell updateCellWithDict:dict];
        titleTableViewCell.titleDelegate = self;
    }
    
    else if ([tableViewCell isKindOfClass:[ChooseTableViewCell class]]) {
        ChooseTableViewCell *chooseTableViewCell = (ChooseTableViewCell *)tableViewCell;
        [chooseTableViewCell updateCellWithDict:dict];
    }
    
    else if ([tableViewCell isKindOfClass:[FieldTableViewCell class]]) {
        FieldTableViewCell *fieldTableViewCell = (FieldTableViewCell *)tableViewCell;
        [fieldTableViewCell updateCellWithDict:dict];
        fieldTableViewCell.fieldDelegate = self;
    }
    
    else if ([tableViewCell isKindOfClass:[QualityTableViewCell class]]) {
        QualityTableViewCell *quaTableViewCell = (QualityTableViewCell *)tableViewCell;
        [quaTableViewCell updateCellWithDict:dict];
        quaTableViewCell.quaDelegate = self;
    }
    
    else {
        [tableViewCell updateCellWithDict:dict];
    }
    return tableViewCell;
}

-(void)addCell{
    NSMutableArray *arr = [NSMutableArray array];
    if (self.editInfoI) {
        self.grade = self.editInfoI.grade;
        [arr addObject:[TitleTableViewCell buildCellDict:nil andPrompTitle:@""]];
        [arr addObject:[LineSmallTableViewCell buildCellDict]];
        [arr addObject:[QualityTableViewCell buildCellDict:self.editInfoI]];
        for (AttrEditableInfo *attrInfo in self.editInfoI.attrInfoList) {
            [self.editInfo.attrInfoList addObject:attrInfo];
            [arr addObject:[LineTableViewCell buildCellDict]];
            [arr addObject:[TitleTableViewCell buildCellDict:attrInfo.attrName andPrompTitle:attrInfo.explain]];
            [arr addObject:[LineSmallTableViewCell buildCellDict]];
            [arr addObject:[ChooseTableViewCell buildCellDict:attrInfo]];
        }
    } else {
        [arr addObject:[TitleTableViewCell buildCellDict:nil andPrompTitle:@""]];
        [arr addObject:[LineSmallTableViewCell buildCellDict]];
        [arr addObject:[QualityTableViewCell buildCellDict:nil]];
        for (AttrEditableInfo *attrInfo in self.attrInfoMutArr) {
            [self.editInfo.attrInfoList addObject:attrInfo];
            [arr addObject:[LineTableViewCell buildCellDict]];
            [arr addObject:[TitleTableViewCell buildCellDict:attrInfo.attrName andPrompTitle:attrInfo.explain]];
            [arr addObject:[LineSmallTableViewCell buildCellDict]];
            [arr addObject:[ChooseTableViewCell buildCellDict:attrInfo]];
        }
    }
    self.arr = arr;
    [self.dataSource addObjectsFromArray:arr];
}

-(void)remCell{
    
    [self.dataSource removeObjectsInArray:self.arr];
    
//    if (self.editInfoI) {
//        self.grade = self.editInfoI.grade;
//        
//        [self.dataSource addObject:[FieldTableViewCell buildCellDict:self.editInfoI]];
//        [self.dataSource addObject:[PhotoTableViewCell buildCellDict]];
//        
//        [self.dataSource addObject:[RecoveryCell buildCellDict]];
//        [self.dataSource addObject:[LineSmallTableViewCell buildCellDict]];
//        [self.dataSource addObject:[RecoveryCell1 buildCellDict]];
//        [self.dataSource addObject:[LineSmallTableViewCell buildCellDict]];
//        [self.dataSource addObject:[RecoveryCell2 buildCellDict]];
//        [self.dataSource addObject:[LineSmallTableViewCell buildCellDict]];
//
//    } else {
//        
//        [self.dataSource addObject:[FieldTableViewCell buildCellDict:nil]];
//        [self.dataSource addObject:[PhotoTableViewCell buildCellDict]];
//        
//        [self.dataSource addObject:[RecoveryCell buildCellDict]];
//        [self.dataSource addObject:[LineSmallTableViewCell buildCellDict]];
//        [self.dataSource addObject:[RecoveryCell1 buildCellDict]];
//        [self.dataSource addObject:[LineSmallTableViewCell buildCellDict]];
//        [self.dataSource addObject:[RecoveryCell2 buildCellDict]];
//        [self.dataSource addObject:[LineSmallTableViewCell buildCellDict]];
//    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [self.dataSource objectAtIndex:[indexPath row]];
    BaseTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[RecoveryCell class]]) {
        [self publishSelectBrand:self.brandList];
    } else if ([cell isKindOfClass:[RecoveryCell1 class]]) {
        [self pulishSelectCate:self.cateList];
    } else if ([cell isKindOfClass:[RecoveryCell2 class]]) {
        //1 下   else 上
        if (self.turnIndex == 1) {
            [self.recoveryCell2 turnRightImage:self.turnIndex];
            self.turnIndex = 0;
            [self addCell];
            [tableView reloadData];
        } else {
            [self.recoveryCell2 turnRightImage:self.turnIndex];
            self.turnIndex = 1;
            [self remCell];
            [tableView reloadData];
        }
        
    }
    
}

-(void)publishDidSelectHeaderView:(NSInteger)brandId andBrandName:(NSString *)brandName{
    self.brand_id = brandId;
    self.brandName = brandName;
    self.recoveryCell.subStr = brandName;
    NSDictionary *data = @{@"brandId":@(brandId)};
    [self client:data];
}

//选择品牌

- (void)publishSelectBrand:(NSArray*)brandList
{
    WEAKSELF;
//    if (weakSelf.selectedCate || weakSelf.editableInfo.categoryId>0) {
//        
//    } else {
//        
//        [WCAlertView showAlertWithTitle:@""
//                                message:@"请先选择商品类目"
//                     customizationBlock:^(WCAlertView *alertView) {
//                         alertView.style = WCAlertViewStyleWhite;
//                     } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
//                         [weakSelf pulishSelectCate:weakSelf.cateList];
//                     } cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        
//        return;
//    }
    
    PublishSelectViewController *viewController = [[PublishSelectViewController alloc] init];
    typeof(viewController) __weak weakViewController = viewController;
    viewController.title = @"选择品牌";
    viewController.delegate = weakSelf;
    viewController.isGroupedWithName = YES;
    viewController.isSupportSearch = YES;
    viewController.cate_id = self.cate_id;
    
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
            [BrandService getBrandList:_selectedCate.parentId completion:^(NSArray *fechtedBrandList) {
                [weakViewController hideHUD];
                NSLog(@"%ld, %ld", _selectedCate.cateId, _selectedCate.parentId);
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
    [ClientReportObject clientReportObjectWithViewCode:PublishRecoveryRegionCode regionCode:IssureBrandViewCode referPageCode:IssureBrandViewCode andData:nil];
    [weakSelf pushViewController:viewController animated:YES];
}

//选择类目
- (void)pulishSelectCate:(NSArray*)cateList
{
    WEAKSELF;
    PublishSelectViewController *viewController = [[PublishSelectViewController alloc] init];
    typeof(viewController) __weak weakViewController = viewController;
    //        viewController.delegate = weakSelf;
    //        viewController.selectedCateId = weakSelf.editableInfo.categoryId;
    //        viewController.selectedCateName = weakSelf.editableInfo.categoryName;
    viewController.title = @"选择类别";
    viewController.delegate = weakSelf;
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
    [ClientReportObject clientReportObjectWithViewCode:PublishRecoveryRegionCode regionCode:IssureCatalogueViewCode referPageCode:IssureCatalogueViewCode andData:nil];
    [weakSelf pushViewController:viewController animated:YES];
}

-(void)client:(NSDictionary *)data{
    [ClientReportObject clientReportObjectWithViewCode:IssureBrandViewCode regionCode:PublishRecoveryRegionCode referPageCode:PublishRecoveryRegionCode andData:data];
}

- (void)publishDidSelect:(PublishSelectViewController*)viewController selectableItem:(PublishSelectableItem*)selectableItem
{
    WEAKSELF;
    void(^popToPulishController)() = ^{
        NSArray *viewControllers= viewController.navigationController.viewControllers;
        for (UIViewController *viewController in viewControllers) {
            if ([viewController isKindOfClass:[IssueViewController class]]) {
                [viewController.navigationController popToViewController:viewController animated:YES];
                break;
            }
        }
    };
    
    
    //remove防止退出时出现数组数据错乱
    if ([selectableItem.attachedItem isKindOfClass:[BrandInfo class]]) {
        BrandInfo *brand = (BrandInfo *)selectableItem.attachedItem;
        
        //        self.titleStr1 = selectableItem.title;
        //        NSString *str = [NSString stringWithFormat:@"%@-%@", self.titleStr, self.titleStr1];
        //        IssueViewController *issueController = [[IssueViewController alloc] init];
        //        issueController.titleText = str;
        self.brandName = brand.brandName;
        self.brand_id = brand.brandId;
        //        issueController.cateName = self.titleStr;
        //        issueController.brandName = self.titleStr1;
        //        issueController.releaseIndex = YES;
        //        [self pushViewController:issueController animated:YES];
        //        self.brandList = nil;
        //        [viewController removeFromParentViewController];
        //        return;
        self.recoveryCell.subStr = brand.brandName;
        NSLog(@"%@", brand.brandName);
        NSDictionary *data = @{@"brandId":@(brand.brandId)};
        [self client:data];
        popToPulishController();
        return;
    }
    
    if ([selectableItem.attachedItem isKindOfClass:[Cate class]]) {
        if ([((Cate*)selectableItem.attachedItem).children count]==0) {
            
            Cate *cate = (Cate *)selectableItem.attachedItem;
            //        self.selectedCate = cate;
            //        [self publishSelectBrand:self.brandList];
            //        self.selectedCate = nil;
            //        self.titleStr = cate.name;
            //        self.cate_id = cate.cateId;
            //        [viewController removeFromParentViewController];
            //稍后做些操作
            self.cate_id = cate.cateId;
            self.cateName = cate.name;
            self.editableInfo.categoryId = cate.cateId;
            self.recoveryCell1.subStr = cate.name;
            NSLog(@"%@", cate.name);
            NSDictionary *data = @{@"cateId":@(cate.cateId)};
            [ClientReportObject clientReportObjectWithViewCode:IssureCatalogueViewCode regionCode:PublishRecoveryRegionCode referPageCode:PublishRecoveryRegionCode andData:data];
            popToPulishController();
        }
        else {
            
            [self pulishSelectCate:((Cate*)selectableItem.attachedItem).children andTitle:selectableItem.title];
            //        [viewController removeFromParentViewController];
        }
    }
}

- (void)pulishSelectCate:(NSArray*)cateList andTitle:(NSString *)title
{
    WEAKSELF;
    PublishSelectViewController *viewController = [[PublishSelectViewController alloc] init];
    typeof(viewController) __weak weakViewController = viewController;
    //        viewController.delegate = weakSelf;
    //        viewController.selectedCateId = weakSelf.editableInfo.categoryId;
    //        viewController.selectedCateName = weakSelf.editableInfo.categoryName;
    viewController.title = title;
    viewController.delegate = weakSelf;
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
    }
    else {
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
    [self.navigationController pushViewController:viewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSource objectAtIndex:[indexPath row]];
    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    if ([ClsTableViewCell isSubclassOfClass:[PhotoTableViewCell class]]) {
        if (self.heigth == 0) {
            return 167;
        } else {
            return self.heigth + 20;
        }
    }
    return [ClsTableViewCell rowHeightForPortrait:dict];
}
//获取补充描述的数据   选填
-(void)getData:(NSString *)text{
    self.summer = text;
}

-(void)getDataChoose:(NSNotification *)notify{
    NSDictionary *dict = notify.object;
    UIButton *seletedBtn = dict[@"button"];
    AttrEditableInfo *attrInfo = dict[@"attr"];
    
    if (self.attrInfos.count > 0) {
        for (AttrEditableInfo *attrInfoM in self.attrInfos) {
            if (attrInfoM.attrId == attrInfo.attrId) {
                [self.attrInfos removeAllObjects];
            }
        }
    }
    
    NSMutableArray *attrInfos = _editInfo.attrInfoList;
    if (attrInfo.is_multi_choice == 0) {
        for (AttrEditableInfo *attrInfoList in attrInfos) {
            if (attrInfoList.attrId == attrInfo.attrId) {
                attrInfoList.attrValue = seletedBtn.titleLabel.text;
                [self.attrInfos addObject:attrInfoList];
            }
        }
//        self.seletedBtn = seletedBtn;
        
    } else {
        NSLog(@"-----%@", seletedBtn.titleLabel.text);
        seletedBtn.tag = attrInfo.attrId;
        [self.seletedArr addObject:seletedBtn];
    }
    
    NSLog(@"%@", self.seletedBtn.titleLabel.text);
    
    NSLog(@"%@", self.seletedArr);
    
}

-(void)remDataChoose:(NSNotification *)notify{
    
//    for (UIButton *btn in self.seletedArr) {
//        if (btn == remBtn) {
    if (self.seletedArr.count > 0) {
        UIButton *remBtn = notify.object;
        for (int i = 0 ; i < self.seletedArr.count; i++) {
            UIButton *btn = self.seletedArr[i];
            if ([btn.titleLabel.text isEqualToString:remBtn.titleLabel.text]) {
                NSLog(@"%@", btn);
                NSLog(@"%@", remBtn);
                [self.seletedArr removeObject:btn];
                NSLog(@"%@", self.seletedArr);
                
            }
        }
//        [self.seletedArr removeObject:remBtn];
//        NSLog(@"%@", self.seletedArr);
    }
}

-(void)releaseBtnClick{
    
    
    self.attrStr = nil;
    if (self.seletedArr.count > 0) {
        _editInfo;
        for (AttrEditableInfo *attrInfo in _editInfo.attrInfoList) {
            NSMutableString *str = [[NSMutableString alloc] init];
            if (attrInfo.is_multi_choice == 1) {
                for (UIButton *btn in self.seletedArr) {
                    if (btn.tag == attrInfo.attrId) {
                        [str appendFormat:@"%@,", btn.titleLabel.text];
                    }
                }
                attrInfo.attrValue = [str substringToIndex:[str length] - 1];
                [self.attrInfos addObject:attrInfo];
            }
        }
    }
    
    if (self.editInfoI) {
        if (self.attrInfos.count > 0) {
//            [self.editInfoI.attrInfoList removeAllObjects];
            self.editInfoI.attrInfoList = self.attrInfos;
        }
    } else {
//        [self.editInfo.attrInfoList removeAllObjects];
        if (self.attrInfos.count > 0) {
            self.editInfo.attrInfoList = self.attrInfos;
            
        }
    }
    
    
//    for (AttrEditableInfo *attrInfo in self.attrInfoMutArr) {
//        if (attrInfo.isMust && attrInfo.is_multi_choice == 0) {
//            attrInfo.attrValue = self.seletedBtn.titleLabel.text;
//            self.attrInfoI = attrInfo;
//        }
//        if (!attrInfo.isMust && attrInfo.is_multi_choice == 1) {
////            for (UIButton *btn in self.seletedArr) {
////                [self.attrStr appendFormat:@"%@,", btn.titleLabel.text];
////            }
//            for (UIButton *btn in self.seletedArr) {
//                [self.attrStr appendFormat:@"%@,", btn.titleLabel.text];
//            }
//            if (self.seletedArr.count > 0) {
//                NSString *str = [self.attrStr substringToIndex:[self.attrStr length] - 1];
//                attrInfo.attrValue = str;
//                NSLog(@"%@", str);
//            } else {
//                attrInfo.attrValue = nil;
//            }
//        }
    
//        if (_editInfoI) {
//            [self.editInfoI.attrInfoList addObject:attrInfo];
//        } else {
//            [self.editInfo.attrInfoList addObject:attrInfo];
//        }
//    }
    NSLog(@"%@", _editInfo.attrInfoList);
    
    if (self.editInfoI) {
        self.editInfoI.summary = self.summer;
        self.editInfoI.grade = self.grade;
        self.editInfoI.categoryId = self.cate_id;
        self.editInfoI.brandId = self.brand_id;
        self.editInfoI.categoryName = self.cateName;
        self.editInfoI.brandName = self.brandName;
    } else {
        self.editInfo.summary = self.summer;
        self.editInfo.grade = self.grade;
        self.editInfo.categoryId = self.cate_id;
        self.editInfo.brandId = self.brand_id;
        self.editInfo.categoryName = self.cateName;
        self.editInfo.brandName = self.brandName;
    }
    
    
    BOOL isLoggedIn = [[CoordinatingController sharedInstance] checkBindingStateAndPresentLoginController:self bindingAlert:@"请绑定手机号，当您错过买家的消息时，我们将会给您手机短信通知。" completion:^{ }];
    if (isLoggedIn) {
        if (_editInfoI) {
            self.editInfo = self.editInfoI;
            //        return YES;
        }
        [self publish];
    }
    
    
}


- (BOOL)saveEditInfo
{
    BOOL isValid = YES;
    
    
    //修改业务逻辑   改变选填 必填。。。
    
//    if (_editInfo.categoryId==0) {
//        isValid = NO;
//    }
//    if (_editInfo.brandId == 0) {
//        isValid = NO;
//    }
//    if (_editInfo.grade == -1) {
//        [self showHUD:@"您有必填项还没有填写，请仔细检查" hideAfterDelay:0.8f];
//        isValid = NO;
//    }
    
    if (self.summer.length == 0) {
        [self showHUD:@"请填写商品描述" hideAfterDelay:0.8f];
        isValid = NO;
    }
    
    if (_editInfoI) {
        isValid = YES;
    } else {
        for (AttrEditableInfo *attrInfo in self.editInfo.attrInfoList) {
            if (attrInfo.isMust == YES) {
                if (attrInfo.attrValue.length == 0) {
                    [self showHUD:@"您有必填项还没有填写，请仔细检查" hideAfterDelay:0.8f];
                    isValid = NO;
                }
            }
        }
    }

//    for (AttrEditableInfo *attrInfo in self.attrInfoMutArr) {
//        if (attrInfo.isMust && attrInfo.is_multi_choice == 0) {
//            [self.editInfo.attrInfoList addObject:attrInfo];
//        }
//        if (!attrInfo.isMust && attrInfo.is_multi_choice == 1) {
//            self.editInfo.attrInfoList addObject:<#(nonnull id)#>
//        }
//    }
    //    if (_editableInfo.fitPeople==-1) {
    //        [_fitPeopleBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    //        isValid = NO;
    //    }
    
//    if (_editInfo.expected_delivery_type<=0) {
//        isValid = NO;
//    }
    
//    _editInfo.summary = [_summer trim];
    
    
    NSArray *picItemsArray = [_picturesEditView picItemsArray];
    if ([picItemsArray count]==0) {
        isValid = NO;
        _editInfo.mainPicItem = nil;
        _editInfo.gallary = nil;
    } else {
        _editInfo.mainPicItem = [picItemsArray objectAtIndex:0];
        if ([picItemsArray count]>1) {
            NSMutableArray *gallery = [[NSMutableArray alloc] initWithCapacity:picItemsArray.count-1];
            for (NSInteger i=1;i<picItemsArray.count;i++) {
                [gallery addObject:[picItemsArray objectAtIndex:i]];
            }
            _editInfo.gallary = gallery;
        } else {
            _editInfo.gallary = nil;
        }
    }
    
    //    for (AttrInfoEditButton *btn in _attrBtnArray) {
    //        if (btn.attrEditableInfo.isMust && [btn.attrEditableInfo.attrValue length]==0) {
    //            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    //            isValid = NO;
    //        }
    //    }
    return isValid;
}

- (void)publish
{
    BOOL isValid = [self saveEditInfo];
    if (isValid == NO) {
        NSArray *picItemArray = [_picturesEditView picItemsArray];
        if (picItemArray.count == 0) {
            [self showHUD:@"请至少提供一个主图" hideAfterDelay:0.8f];
        } else {
            [self showHUD:@"请检查有必填项未填写" hideAfterDelay:0.8f];
        }
        return;
    }
    
    NSArray *picItemArray = [_picturesEditView picItemsArray];
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
            _editInfo.mainPicItem = item;
        } else {
            [gallery addObject:item];
        }
    }
    _editInfo.gallary = gallery;
    
    WEAKSELF;
    _request = [[NetworkAPI sharedInstance] publishGoods:_editInfo publish_type:1 completion:^(GoodsPublishResultInfo *resultInfo) {
        
        
        
//        InsureTableViewController *insureTableView = [[InsureTableViewController alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
//        
//        [self presentViewController:insureTableView animated:YES completion:^{
//            [weakSelf dismiss];
//        }];
        
//        InsureViewController *insureController = [[InsureViewController alloc] init];
//        [insureController getGoodsID:resultInfo.goodsId];
//        MyNavigationController *nav = [[MyNavigationController alloc] initWithRootViewController:insureController];
//        [nav setNavigationBarHidden:YES];
//        [weakSelf presentViewController:nav animated:YES completion:^{
            [[CoordinatingController sharedInstance] showHUD:@"发布成功" hideAfterDelay:2.f];
//            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            [weakSelf dismiss];
//        }];
        
//        [weakSelf pushViewController:insureController animated:YES];
    
        
//        if (((PublishGoodsViewController*)(weakSelf)).handlePublishGoodsFinished) {
//            ((PublishGoodsViewController*)(weakSelf)).handlePublishGoodsFinished(weakSelf.editInfo);
//        }
        
        
    } failure:^(XMError *error) {
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
    }];
}

-(void)dissMissBackView{
    [UIView animateWithDuration:0.25 animations:^{
        self.backView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.backView removeFromSuperview];
    }];
}

-(void)getQuaData:(UIButton *)btn{
    self.grade = btn.tag;
}

//执行cell代理方法
-(void)sheetQuaView{
    
    if (!self.backView) {
        self.backView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    self.backView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.backView];
    self.backView.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.backView.alpha = 0.7;
    } completion:^(BOOL finished) {
        nil;
    }];
    
    if (!self.promrtView) {
        self.promrtView = [[PromptView alloc] init];
    }
    self.promrtView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.promrtView];
    
    UIImageView *promrtImageView = [[UIImageView alloc] init];
    promrtImageView.image = [UIImage imageNamed:@"promrt_MF"];
    [self.promrtView addSubview:promrtImageView];
    
    UIButton *dissBtn = [[UIButton alloc] init];
    [dissBtn setImage:[UIImage imageNamed:@"dissMiss_Recocer_MF"] forState:UIControlStateNormal];
    [promrtImageView addSubview:dissBtn];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"成色定义";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:15.f];
    [titleLabel sizeToFit];
    [promrtImageView addSubview:titleLabel];
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.numberOfLines = 0;
    textLabel.backgroundColor = [UIColor whiteColor];
    textLabel.textColor = [UIColor colorWithHexString:@"595757"];
    textLabel.font = [UIFont systemFontOfSize:12.f];
    [textLabel sizeToFit];
    textLabel.text = @"     全新（未使用品）";
    [promrtImageView addSubview:textLabel];
    
    UILabel *textLabel1 = [[UILabel alloc] init];
    textLabel1.numberOfLines = 0;
    textLabel1.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
    textLabel1.textColor = [UIColor colorWithHexString:@"a5a5a5"];
    textLabel1.font = [UIFont systemFontOfSize:9.f];
    [textLabel1 sizeToFit];
    textLabel1.text = @"     全新品未曾使用，无任何痕迹";
    [promrtImageView addSubview:textLabel1];
    
    UILabel *textLabel2 = [[UILabel alloc] init];
    textLabel2.numberOfLines = 0;
    textLabel2.backgroundColor = [UIColor whiteColor];
    textLabel2.textColor = [UIColor colorWithHexString:@"595757"];
    textLabel2.font = [UIFont systemFontOfSize:12.f];
    [textLabel2 sizeToFit];
    textLabel2.text = @"     98成新（未使用品，陈列品）";
    [promrtImageView addSubview:textLabel2];
    
    UILabel *textLabel3 = [[UILabel alloc] init];
    textLabel3.numberOfLines = 0;
    textLabel3.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
    textLabel3.textColor = [UIColor colorWithHexString:@"a5a5a5"];
    textLabel3.font = [UIFont systemFontOfSize:9.f];
    [textLabel3 sizeToFit];
    textLabel3.text = @"     有极其轻微放置痕迹，因陈列导致有极其轻微的磨损";
    [promrtImageView addSubview:textLabel3];
    
    UILabel *textLabel4 = [[UILabel alloc] init];
    textLabel4.numberOfLines = 0;
    textLabel4.backgroundColor = [UIColor whiteColor];
    textLabel4.textColor = [UIColor colorWithHexString:@"595757"];
    textLabel4.font = [UIFont systemFontOfSize:12.f];
    [textLabel4 sizeToFit];
    textLabel4.text = @"     95成新（几乎未使用过）";
    [promrtImageView addSubview:textLabel4];
    
    UILabel *textLabel5 = [[UILabel alloc] init];
    textLabel5.numberOfLines = 0;
    textLabel5.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
    textLabel5.textColor = [UIColor colorWithHexString:@"a5a5a5"];
    textLabel5.font = [UIFont systemFontOfSize:9.f];
    [textLabel5 sizeToFit];
    textLabel5.text = @"     整体成色较新，有轻微使用痕迹，品相完整";
    [promrtImageView addSubview:textLabel5];
    
    UILabel *textLabel6 = [[UILabel alloc] init];
    textLabel6.numberOfLines = 0;
    textLabel6.backgroundColor = [UIColor whiteColor];
    textLabel6.textColor = [UIColor colorWithHexString:@"595757"];
    textLabel6.font = [UIFont systemFontOfSize:12.f];
    [textLabel6 sizeToFit];
    textLabel6.text = @"     9成新（偶尔使用）";
    [promrtImageView addSubview:textLabel6];
    
    UILabel *textLabel7 = [[UILabel alloc] init];
    textLabel7.numberOfLines = 0;
    textLabel7.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
    textLabel7.textColor = [UIColor colorWithHexString:@"a5a5a5"];
    textLabel7.font = [UIFont systemFontOfSize:9.f];
    [textLabel7 sizeToFit];
    textLabel7.text = @"     外观有日常使用痕迹，局部有少数划痕、污渍、磨损等情况，品相良好";
    [promrtImageView addSubview:textLabel7];
    
    UILabel *textLabel8 = [[UILabel alloc] init];
    textLabel8.numberOfLines = 0;
    textLabel8.backgroundColor = [UIColor whiteColor];
    textLabel8.textColor = [UIColor colorWithHexString:@"595757"];
    textLabel8.font = [UIFont systemFontOfSize:12.f];
    [textLabel8 sizeToFit];
    textLabel8.text = @"     85成新（正常使用）";
    [promrtImageView addSubview:textLabel8];
    
    UILabel *textLabel9 = [[UILabel alloc] init];
    textLabel9.numberOfLines = 0;
    textLabel9.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
    textLabel9.textColor = [UIColor colorWithHexString:@"a5a5a5"];
    textLabel9.font = [UIFont systemFontOfSize:9.f];
    [textLabel9 sizeToFit];
    textLabel9.text = @"     外观有日常使用痕迹，局部有明显划痕、污渍、磨损等情况，品相普通";
    [promrtImageView addSubview:textLabel9];
    
    UILabel *textLabel10 = [[UILabel alloc] init];
    textLabel10.numberOfLines = 0;
    textLabel10.backgroundColor = [UIColor whiteColor];
    textLabel10.textColor = [UIColor colorWithHexString:@"595757"];
    textLabel10.font = [UIFont systemFontOfSize:12.f];
    [textLabel10 sizeToFit];
    textLabel10.text = @"     8成新（长期使用）";
    [promrtImageView addSubview:textLabel10];
    
    UILabel *textLabel11 = [[UILabel alloc] init];
    textLabel11.numberOfLines = 0;
//    textLabel11.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
    textLabel11.textColor = [UIColor colorWithHexString:@"a5a5a5"];
    textLabel11.font = [UIFont systemFontOfSize:9.f];
    [textLabel11 sizeToFit];
    textLabel11.text = @"     外观有长期使用痕迹，局部有较严重划痕、污渍、磨损等情况，不影响正常使用";
    [promrtImageView addSubview:textLabel11];
    
    [self.promrtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.centerY.equalTo(self.view.mas_centerY);
        make.height.equalTo(textLabel.mas_height).offset(390);
    }];
    
    [promrtImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.promrtView);
    }];
    
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(promrtImageView.mas_top).offset(40);
        make.left.equalTo(promrtImageView.mas_left).offset(0);
        make.right.equalTo(promrtImageView.mas_right).offset(0);
        make.height.equalTo(@35);
    }];
    
    [textLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textLabel.mas_bottom);
        make.left.equalTo(promrtImageView.mas_left).offset(0);
        make.right.equalTo(promrtImageView.mas_right).offset(0);
        make.height.equalTo(@28);
    }];
    
    [textLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textLabel1.mas_bottom);
        make.left.equalTo(promrtImageView.mas_left).offset(0);
        make.right.equalTo(promrtImageView.mas_right).offset(0);
        make.height.equalTo(@35);
    }];
    
    [textLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textLabel2.mas_bottom);
        make.left.equalTo(promrtImageView.mas_left).offset(0);
        make.right.equalTo(promrtImageView.mas_right).offset(0);
        make.height.equalTo(@28);
    }];
    
    [textLabel4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textLabel3.mas_bottom);
        make.left.equalTo(promrtImageView.mas_left).offset(0);
        make.right.equalTo(promrtImageView.mas_right).offset(0);
        make.height.equalTo(@35);
    }];
    
    [textLabel5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textLabel4.mas_bottom);
        make.left.equalTo(promrtImageView.mas_left).offset(0);
        make.right.equalTo(promrtImageView.mas_right).offset(0);
        make.height.equalTo(@28);
    }];
    
    [textLabel6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textLabel5.mas_bottom);
        make.left.equalTo(promrtImageView.mas_left).offset(0);
        make.right.equalTo(promrtImageView.mas_right).offset(0);
        make.height.equalTo(@35);
    }];
    
    [textLabel7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textLabel6.mas_bottom);
        make.left.equalTo(promrtImageView.mas_left).offset(0);
        make.right.equalTo(promrtImageView.mas_right).offset(0);
        make.height.equalTo(@28);
    }];
    
    [textLabel8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textLabel7.mas_bottom);
        make.left.equalTo(promrtImageView.mas_left).offset(0);
        make.right.equalTo(promrtImageView.mas_right).offset(0);
        make.height.equalTo(@35);
    }];
    
    [textLabel9 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textLabel8.mas_bottom);
        make.left.equalTo(promrtImageView.mas_left).offset(0);
        make.right.equalTo(promrtImageView.mas_right).offset(0);
        make.height.equalTo(@28);
    }];
    
    [textLabel10 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textLabel9.mas_bottom);
        make.left.equalTo(promrtImageView.mas_left).offset(0);
        make.right.equalTo(promrtImageView.mas_right).offset(0);
        make.height.equalTo(@35);
    }];
    
    [textLabel11 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textLabel10.mas_bottom);
        make.left.equalTo(promrtImageView.mas_left).offset(0);
        make.right.equalTo(promrtImageView.mas_right).offset(0);
        make.height.equalTo(@28);
    }];
    
    [dissBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(promrtImageView.mas_top).offset(5);
        make.right.equalTo(promrtImageView.mas_right).offset(-15);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(promrtImageView.mas_centerX);
        make.top.equalTo(promrtImageView.mas_top).offset(11);
    }];
    
    self.promrtView.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.promrtView.alpha = 1;
    }];
}

-(void)handleTopBarRightButtonClicked:(UIButton *)sender{
    [self clickTopRightBtn];
}

-(void)clickTopRightBtn{
    
    if (!self.backView) {
        self.backView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    self.backView.backgroundColor = [UIColor blackColor];
    self.backView.alpha = 0;
    [self.view addSubview:self.backView];
    [UIView animateWithDuration:0.25 animations:^{
        self.backView.alpha = 0.7;
    } completion:^(BOOL finished) {
        nil;
    }];
    
    if (!self.promrtView) {
        self.promrtView = [[PromptView alloc] init];
    }
    self.promrtView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.promrtView];
    
    UIImageView *promrtImageView = [[UIImageView alloc] init];
    promrtImageView.image = [UIImage imageNamed:@"promrt_MF"];
    [self.promrtView addSubview:promrtImageView];
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.numberOfLines = 0;
    textLabel.textColor = [UIColor colorWithHexString:@"595757"];
    [textLabel sizeToFit];
//    textLabel.text = @"商品发布后，爱丁猫将根据该商品信息匹配回收商，收集报价并实时呈现给您。\n\n"
////    "每一件求回收的商品自最后1次编辑起，7天内没售出将会自动下架，下架后，您可以再次编辑上架。\n\n"
//    "商品上架后，8小时内未售出将会自动下架，下架2小时后可再次上架。\n\n"
//    "每一件求回收商品再次编辑或者上架后，不会被再次推送给回收商，但您可以主动去寻求专区寻找/筛选回收商。";
    
    textLabel.text = @"发布须知\n"
    "图片要求："
    "请拍摄商品正面、背面、底部、侧面、手柄、肩带、五金件等部位并清晰的拍摄出划痕、褪色、磨损等瑕疵问题。\n\n"
    "内容要求："
    "详细描述包包的成色瑕疵等实际情况，如：肩带有轻微使用痕迹，拉链头氧化等。\n\n"
    "商品上架："
    "24小时内未售出将会自动下架，下架2小时后可再次上架。";
    [promrtImageView addSubview:textLabel];
    
    UIButton *dissBtn = [[UIButton alloc] init];
    [dissBtn setImage:[UIImage imageNamed:@"dissMiss_Recocer_MF"] forState:UIControlStateNormal];
    [promrtImageView addSubview:dissBtn];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"小贴士";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:15.f];
    [titleLabel sizeToFit];
    [promrtImageView addSubview:titleLabel];
    
    [self.promrtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.centerY.equalTo(self.view.mas_centerY);
        make.height.equalTo(textLabel.mas_height).offset(115);
    }];
    
    [promrtImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.promrtView);
    }];
    
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(promrtImageView.mas_top).offset(75);
        make.left.equalTo(promrtImageView.mas_left).offset(15);
        make.right.equalTo(promrtImageView.mas_right).offset(-15);
//        make.bottom.equalTo(self.promrtView.mas_bottom).offset(-35);
    }];
    
    [dissBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(promrtImageView.mas_top).offset(5);
        make.right.equalTo(promrtImageView.mas_right).offset(-15);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(promrtImageView.mas_centerX);
        make.top.equalTo(promrtImageView.mas_top).offset(11);
    }];
    
    self.promrtView.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.promrtView.alpha = 1;
    }];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [UIView animateWithDuration:0.25 animations:^{
        self.promrtView.alpha = 0;
        self.backView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.promrtView removeFromSuperview];
        [self.backView removeFromSuperview];
    }];
}

@end
